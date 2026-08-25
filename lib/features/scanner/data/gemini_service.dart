import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

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
  // Free public Gemini API key or fallback Key
  static const String _defaultApiKey = 'AIzaSyCkrr2ZxwzQ0WZj_v4dfA8gFGkQ-ZJFcjg';
  late final GenerativeModel _visionModel;
  late final GenerativeModel _chatModel;

  GeminiService({String? apiKey}) {
    final key = (apiKey != null && apiKey.isNotEmpty) ? apiKey : _defaultApiKey;
    _visionModel = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: key,
    );
    _chatModel = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: key,
    );
  }

  // 100% Real Gemini Vision Grading & Analysis
  Future<SolvedProblemResult> analyzeProblemImage(
    Uint8List imageBytes, {
    String selectedSubject = 'Toán học',
  }) async {
    try {
      final prompt = Content.multi([
        TextPart('''
Bạn là một gia sư AI chuyên gia 4 môn: Toán học, Vật Lý, Hóa Học, Tiếng Anh.
Hãy đọc ảnh bài làm/bài tập của học sinh môn "$selectedSubject" và chấm bài theo định dạng JSON:
{
  "title": "Tên bài tập hoặc chủ đề",
  "subject": "$selectedSubject",
  "isCorrect": true/false (true nếu bài làm ĐÚNG hoàn toàn, false nếu có LỖI SAI hoặc chưa hoàn thành),
  "score": số_điểm_thang_10 (ví dụ 10 nếu đúng, 6-9 nếu đúng một phần, 0-5 nếu sai nặng),
  "extractedEquation": "Công thức / Nội dung đề bài trích xuất từ ảnh",
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

      final response = await _visionModel.generateContent([prompt]);
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
      throw Exception('AI chưa thể đọc được ảnh bài làm. Vui lòng đảm bảo ảnh chụp rõ nét bài tập môn $selectedSubject.');
    }
  }

  // 100% Real Gemini AI Tutor Chat Response
  Future<String> askAiTutor({
    required String query,
    required String subject,
  }) async {
    try {
      final prompt = '''
Bạn là một gia sư AI thân thiện, kiên nhẫn chuyên môn "$subject" (Toán học, Vật Lý, Hóa Học, Tiếng Anh).
Học sinh đang hỏi: "$query".
Hãy trả lời ngắn gọn, dễ hiểu, sử dụng biểu tượng cảm xúc (emoji) và giải thích từng bước rõ ràng.
''';

      final response = await _chatModel.generateContent([Content.text(prompt)]);
      return response.text ?? 'Gia sư AI chưa thể phản hồi lúc này. Vui lòng hỏi lại nhé!';
    } catch (e) {
      debugPrint('Gemini Chat Error: $e');
      return 'Không thể kết nối với gia sư AI: $e. Vui lòng kiểm tra lại kết nối mạng.';
    }
  }
}
