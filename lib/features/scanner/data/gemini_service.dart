import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SolvedProblemResult {
  final String title;
  final String subject;
  final bool isCorrect;
  final int score;
  final String extractedEquation;
  final int errorStep;
  final String errorExplanation;
  final String hintLevel1;
  final String hintLevel2;
  final String fullSolution;
  final String similarProblem;

  SolvedProblemResult({
    required this.title,
    required this.subject,
    required this.isCorrect,
    required this.score,
    required this.extractedEquation,
    required this.errorStep,
    required this.errorExplanation,
    required this.hintLevel1,
    required this.hintLevel2,
    required this.fullSolution,
    required this.similarProblem,
  });

  factory SolvedProblemResult.fromJson(Map<String, dynamic> json) {
    return SolvedProblemResult(
      title: json['title'] ?? 'Bài tập 4 môn trọng tâm',
      subject: json['subject'] ?? 'Toán học',
      isCorrect: json['isCorrect'] ?? false,
      score: json['score'] ?? 8,
      extractedEquation: json['extractedEquation'] ?? '',
      errorStep: json['errorStep'] ?? 0,
      errorExplanation: json['errorExplanation'] ?? '',
      hintLevel1: json['hintLevel1'] ?? '',
      hintLevel2: json['hintLevel2'] ?? '',
      fullSolution: json['fullSolution'] ?? '',
      similarProblem: json['similarProblem'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subject': subject,
      'isCorrect': isCorrect,
      'score': score,
      'extractedEquation': extractedEquation,
      'errorStep': errorStep,
      'errorExplanation': errorExplanation,
      'hintLevel1': hintLevel1,
      'hintLevel2': hintLevel2,
      'fullSolution': fullSolution,
      'similarProblem': similarProblem,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}

class GeminiService {
  static const String _prefApiKey = 'user_gemini_api_key';

  static Future<String?> getSavedApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefApiKey);
  }

  static Future<void> saveApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefApiKey, key.trim());
  }

  Future<GenerativeModel> _getModel({String modelName = 'gemini-1.5-flash'}) async {
    final savedKey = await getSavedApiKey();
    final apiKey = (savedKey != null && savedKey.isNotEmpty)
        ? savedKey
        : 'AIzaSyCkrr2ZxwzQ0WZj_v4dfA8gFGkQ-ZJFcjg'; // Fallback demo key

    return GenerativeModel(
      model: modelName,
      apiKey: apiKey,
    );
  }

  // 100% Real Gemini Vision Grading & Analysis
  Future<SolvedProblemResult> analyzeProblemImage(
    Uint8List imageBytes, {
    String selectedSubject = 'Toán học',
  }) async {
    try {
      final model = await _getModel();
      final prompt = Content.multi([
        TextPart('''
Bạn là một gia sư AI chuyên gia 4 môn: Toán học, Vật Lý, Hóa Học, Tiếng Anh.
Hãy đọc ảnh bài làm/bài tập của học sinh môn "$selectedSubject" và chấm bài theo định dạng JSON:
{
  "title": "Tên bài tập hoặc chủ đề",
  "subject": "$selectedSubject",
  "isCorrect": true/false (true nếu bài làm ĐÚNG hoàn toàn, false nếu có LỖI SAI hoặc chưa hoàn thành),
  "score": số_điểm_thang_10 (ví dụ 10 nếu đúng, 6-9 nếu đúng một phần, 0-5 nếu sai nặng),
  "extractedEquation": "Nội dung đề bài và lời giải trích xuất từ ảnh",
  "errorStep": số_bước_bị_sai (nếu isCorrect=true thì để 0),
  "errorExplanation": "Nếu làm ĐÚNG: Khen ngợi và khen điểm hay của lời giải. Nếu làm SAI: Chỉ rõ lý do vì sao bước đó chưa chính xác",
  "hintLevel1": "Gợi ý mức 1 (nhắc nhở định hướng tư duy)",
  "hintLevel2": "Gợi ý mức 2 (công thức hoặc quy tắc cần áp dụng)",
  "fullSolution": "Lời giải chi tiết từng bước chuẩn xác",
  "similarProblem": "1 bài tập tương tự kèm đáp số để luyện tập"
}
Chỉ trả về duy nhất chuỗi JSON thuần túy, không kèm khối mã markdown.
'''),
        if (imageBytes.isNotEmpty) DataPart('image/jpeg', imageBytes),
      ]);

      final response = await model.generateContent([prompt]);
      final rawText = response.text ?? '{}';
      final cleanJson = rawText
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      final parsed = jsonDecode(cleanJson) as Map<String, dynamic>;
      final result = SolvedProblemResult.fromJson(parsed);

      // Save grading history to Cloud Firestore Database
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('grading_history')
            .add(result.toMap());
      }

      return result;
    } catch (e) {
      debugPrint('Gemini Vision Grading Error: $e');
      throw Exception('Chưa thể kết nối Gemini AI. Vui lòng nhập Gemini API Key của bạn (tạo miễn phí tại aistudio.google.com) hoặc kiểm tra lại kết nối mạng.');
    }
  }

  // 100% Real Gemini AI Tutor Chat Response
  Future<String> askAiTutor({
    required String query,
    required String subject,
  }) async {
    try {
      final model = await _getModel();
      final prompt = '''
Bạn là một gia sư AI thân thiện, kiên nhẫn chuyên môn "$subject" (Toán học, Vật Lý, Hóa Học, Tiếng Anh).
Học sinh đang hỏi: "$query".
Hãy trả lời ngắn gọn, dễ hiểu, sử dụng biểu tượng cảm xúc (emoji) và giải thích từng bước rõ ràng.
''';

      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Gia sư AI chưa thể phản hồi lúc này. Vui lòng hỏi lại nhé!';
    } catch (e) {
      debugPrint('Gemini Chat Error: $e');
      return 'Không thể kết nối Gemini AI: $e. Vui lòng kiểm tra lại Gemini API Key của bạn.';
    }
  }
}
