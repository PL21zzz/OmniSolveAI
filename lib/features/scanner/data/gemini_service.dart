import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class SolvedProblemResult {
  final String title;
  final String subject;
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

  Future<SolvedProblemResult> analyzeProblemImage(Uint8List imageBytes, {String selectedSubject = 'Toán học'}) async {
    if (_model == null) {
      await Future.delayed(const Duration(milliseconds: 1200));
      return _getMockResultBySubject(selectedSubject);
    }

    try {
      final prompt = Content.multi([
        TextPart('''
Bạn là một gia sư AI chuyên sâu 4 môn: Toán học, Vật Lý, Hóa Học, Tiếng Anh. Hãy đọc ảnh bài làm tay và trả về kết quả định dạng JSON:
{
  "title": "Tên bài tập",
  "subject": "Môn học (Toán học/Vật Lý/Hóa Học/Tiếng Anh)",
  "extractedEquation": "Công thức/Nội dung bài tập trích xuất",
  "errorStep": số_bước_bị_sai_nếu_có (1-indexed),
  "errorExplanation": "Giải thích chi tiết vì sao bước đó bị sai",
  "hintLevel1": "Gợi ý cấp 1",
  "hintLevel2": "Gợi ý cấp 2",
  "fullSolution": "Lời giải hoàn chỉnh từng bước",
  "similarProblem": "Bài tập tương tự để luyện tập"
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
      throw Exception('Hệ thống AI chưa nhận diện được bài làm. Vui lòng kiểm tra lại ảnh hoặc kết nối mạng.');
    }
  }

  SolvedProblemResult _getMockResultBySubject(String subject) {
    switch (subject) {
      case 'Vật Lý':
        return SolvedProblemResult(
          title: 'Định luật Bảo toàn Động lượng',
          subject: 'Vật Lý',
          extractedEquation: r'\vec{P}_{trước} = \vec{P}_{sau} \implies m_1 v_1 = (m_1 + m_2) v',
          errorStep: 2,
          errorExplanation:
              r'Tại Bước 2, bài làm đã tính thiếu hướng véctơ vận tốc ban đầu v_1 (chạy ngược chiều chọn làm chiều dương) nên bị sai dấu âm.',
          hintLevel1: 'Gợi ý 1: Hãy chọn chiều dương là chiều chuyển động ban đầu của vật 1.',
          hintLevel2: r'Gợi ý 2: Chiếu lên chiều dương: m_1 v_1 - m_2 v_2 = (m_1 + m_2) v.',
          fullSolution: r'''
**Lời giải chi tiết từng bước:**
1. Chọn chiều dương là chiều chuyển động ban đầu của vật 1.
2. Áp dụng định luật bảo toàn động lượng:
   m_1 v_1 - m_2 v_2 = (m_1 + m_2) v
3. Suy ra vận tốc sau va chạm mềm:
   v = (m_1 v_1 - m_2 v_2) / (m_1 + m_2) = (2 * 5 - 1 * 3) / (2 + 1) = 2.33 m/s
''',
          similarProblem: r'Hai xe va chạm mềm: m_1 = 3kg (v_1 = 4m/s), m_2 = 2kg (v_2 = 2m/s ngược chiều). Tính v?',
        );

      case 'Hóa Học':
        return SolvedProblemResult(
          title: 'Cân bằng Phản ứng Oxy hóa - Khử',
          subject: 'Hóa Học',
          extractedEquation: r'Fe + HNO_3 \rightarrow Fe(NO_3)_3 + NO + H_2O',
          errorStep: 3,
          errorExplanation:
              r'Tại Bước 3, hệ số của HNO_3 bị ghi nhầm là 3 thay vì 4. Cần cộng cả gốc NO_3^- trong muối Fe(NO_3)_3 và khí NO.',
          hintLevel1: 'Gợi ý 1: Đếm tổng số nguyên tử Nitơ ở vế phải (3 ở muối + 1 ở khí NO = 4).',
          hintLevel2: r'Gợi ý 2: Hệ số của HNO_3 phải bằng tổng số nguyên tử Nitơ ở vế phải.',
          fullSolution: r'''
**Lời giải chi tiết từng bước:**
1. Xác định số oxy hóa: Fe^0 -> Fe^+3 + 3e, N^+5 + 3e -> N^+2.
2. Cân bằng electron: 1 Fe nhường 3e, 1 N nhận 3e.
3. Cân bằng phân tử:
   Fe + 4HNO_3 -> Fe(NO_3)_3 + NO + 2H_2O
''',
          similarProblem: r'Cân bằng phản ứng: Cu + HNO_3 \rightarrow Cu(NO_3)_2 + NO_2 + H_2O',
        );

      case 'Tiếng Anh':
        return SolvedProblemResult(
          title: 'Ngữ pháp Thì Hiện tại Hoàn thành (Present Perfect)',
          subject: 'Tiếng Anh',
          extractedEquation: r'She (live) in Hanoi since 2020 \rightarrow She lived in Hanoi since 2020.',
          errorStep: 1,
          errorExplanation:
              'Tại Bước 1, bài làm sử dụng thì Quá khứ đơn (lived). Vì câu có trạng từ nhận biết "since 2020", phải chia thì Hiện tại hoàn thành (has lived).',
          hintLevel1: 'Gợi ý 1: Trạng từ "since + mốc thời gian" là dấu hiệu của thì Hiện tại hoàn thành (Present Perfect).',
          hintLevel2: 'Gợi ý 2: Cấu trúc chia: Subject + has/have + V3/ed.',
          fullSolution: r'''
**Lời giải chi tiết từng bước:**
1. Nhận biết từ chìa khóa: "since 2020" -> Hành động bắt đầu trong quá khứ và vẫn tiếp diễn đến hiện tại.
2. Áp dụng công thức: Chủ ngữ "She" đi với trợ động từ "has" + V3 "lived".
3. Đáp án chính xác: **She has lived in Hanoi since 2020.**
''',
          similarProblem: r'Chia động từ trong ngoặc: They (know) each other for 5 years.',
        );

      case 'Toán học':
      default:
        return SolvedProblemResult(
          title: 'Tích phân từng phần & Đạo hàm',
          subject: 'Toán học',
          extractedEquation: r'\int_{0}^{\pi} x \cdot \sin(x) \, dx',
          errorStep: 2,
          errorExplanation:
              r'Tại Bước 2, bạn đã áp dụng công thức Tích phân từng phần nhưng quên đổi dấu khi tính cận -pi * cos(pi).',
          hintLevel1: r'Gợi ý 1: Nhớ rằng cos(pi) = -1. Hãy kiểm tra lại dấu âm!',
          hintLevel2: r'Gợi ý 2: Ta có [-x cos(x)]_{0}^{\pi} = -\pi(-1) - 0 = \pi.',
          fullSolution: r'''
**Lời giải chi tiết từng bước:**
1. Đặt u = x => du = dx.
2. Đặt dv = sin(x)dx => v = -cos(x).
3. Tích phân từng phần:
   ∫_{0}^{\pi} x sin(x) dx = [-x cos(x)]_{0}^{\pi} + ∫_{0}^{\pi} cos(x) dx = \pi + 0 = \pi
''',
          similarProblem: r'Tính tích phân: \int_{0}^{\frac{\pi}{2}} x \cdot \cos(x) \, dx',
        );
    }
  }
}
