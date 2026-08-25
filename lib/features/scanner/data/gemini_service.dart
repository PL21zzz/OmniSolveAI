import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class SolvedProblemResult {
  final String title;
  final String extractedEquation;
  final int errorStep;
  final String errorExplanation;
  final String hintLevel1;
  final String hintLevel2;
  final String fullSolution;
  final String similarProblem;

  SolvedProblemResult({
    required this.title,
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
      title: json['title'] ?? 'Bài tập STEM',
      extractedEquation: json['extractedEquation'] ?? '',
      errorStep: json['errorStep'] ?? 0,
      errorExplanation: json['errorExplanation'] ?? '',
      hintLevel1: json['hintLevel1'] ?? '',
      hintLevel2: json['hintLevel2'] ?? '',
      fullSolution: json['fullSolution'] ?? '',
      similarProblem: json['similarProblem'] ?? '',
    );
  }
}

class GeminiService {
  final String? apiKey;
  GenerativeModel? _model;

  GeminiService({this.apiKey}) {
    if (apiKey != null && apiKey!.isNotEmpty) {
      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey!,
      );
    }
  }

  Future<SolvedProblemResult> analyzeProblemImage(Uint8List imageBytes) async {
    if (_model == null) {
      // Return realistic AI diagnostic mock data for demonstration
      await Future.delayed(const Duration(seconds: 2));
      return SolvedProblemResult(
        title: 'Phương trình vi phân & Tích phân',
        extractedEquation: r'\int_{0}^{\pi} x \cdot \sin(x) \, dx',
        errorStep: 2,
        errorExplanation:
            'Tại bước 2, bạn đã áp dụng công thức Tích phân từng phần u = x, dv = sin(x)dx, nhưng quên đổi dấu khi tính -x.cos(x) tại biên cận x = pi.',
        hintLevel1: 'Gợi ý 1: Nhớ rằng \\cos(\\pi) = -1. Hãy kiểm tra lại dấu âm trước ngoặc!',
        hintLevel2: r'Gợi ý 2: Ta có \left[-x \cos(x)\right]_{0}^{\pi} = -\pi \cos(\pi) - (0) = -\pi(-1) = \pi.',
        fullSolution: r'''
**Lời giải chi tiết từng bước:**
1. Đặt $u = x \implies du = dx$.
2. Đặt $dv = \sin(x)dx \implies v = -\cos(x)$.
3. Áp dụng công thức tích phân từng phần:
   $$\int x \sin(x) dx = -x \cos(x) - \int (-\cos(x)) dx = -x \cos(x) + \sin(x)$$
4. Thay cận từ $0$ đến $\pi$:
   $$\left[-x \cos(x) + \sin(x)\right]_{0}^{\pi} = (-\pi \cos(\pi) + \sin(\pi)) - (0) = \pi + 0 = \pi$$
''',
        similarProblem: r'Tính tích phân tương tự: \int_{0}^{\frac{\pi}{2}} x \cdot \cos(x) \, dx',
      );
    }

    try {
      final prompt = Content.multi([
        TextPart('''
Bạn là một gia sư AI toán/lý/hóa chuyên nghiệp. Hãy đọc ảnh bài làm tay sau và trả về kết quả định dạng JSON đúng như mẫu:
{
  "title": "Tên dạng bài toán",
  "extractedEquation": "Công thức toán dạng LaTeX",
  "errorStep": số_bước_bị_sai_nếu_có (1-indexed),
  "errorExplanation": "Giải thích chi tiết vì sao bước đó bị sai",
  "hintLevel1": "Gợi ý cấp 1",
  "hintLevel2": "Gợi ý cấp 2",
  "fullSolution": "Lời giải hoàn chỉnh dạng Markdown/LaTeX",
  "similarProblem": "Bài toán tương tự dạng LaTeX để luyện tập"
}
Chỉ trả về chuỗi JSON thuần túy không chứa khối ```json.
'''),
        DataPart('image/jpeg', imageBytes),
      ]);

      final response = await _model!.generateContent([prompt]);
      final rawText = response.text ?? '{}';
      final cleanJson = rawText.replaceAll('```json', '').replaceAll('```', '').trim();
      final parsed = jsonDecode(cleanJson) as Map<String, dynamic>;
      return SolvedProblemResult.fromJson(parsed);
    } catch (e) {
      debugPrint('Gemini Error: $e');
      throw Exception('Không thể phân tích ảnh qua AI: $e');
    }
  }
}
