import 'package:flutter/material.dart';
import 'package:omni_solve_ai/app/theme/app_theme.dart';
import 'package:omni_solve_ai/features/scanner/data/gemini_service.dart';
import 'package:omni_solve_ai/shared/widgets/math_view.dart';

class SolutionDetailScreen extends StatefulWidget {
  final SolvedProblemResult result;

  const SolutionDetailScreen({super.key, required this.result});

  @override
  State<SolutionDetailScreen> createState() => _SolutionDetailScreenState();
}

class _SolutionDetailScreenState extends State<SolutionDetailScreen> {
  int _activeHintLevel = 0; // 0: None, 1: Hint 1, 2: Hint 2, 3: Full Solution

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isCorrect = widget.result.isCorrect;
    final isMismatch = widget.result.isSubjectMismatch;

    return Scaffold(
      appBar: AppBar(
        title: Text('Kết Quả AI Chấm Bài ${widget.result.subject}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã lưu bài làm vào Firestore!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject Mismatch Warning Banner (If Selected Subject != Uploaded Image Subject)
            if (isMismatch) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade900.withValues(alpha: isDark ? 0.3 : 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.shade700, width: 1.5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '⚠️ Môn Học Không Khớp!',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.amber),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Bạn đang chọn danh mục "${widget.result.subject}" nhưng ảnh bài làm thuộc môn "${widget.result.detectedSubject.isNotEmpty ? widget.result.detectedSubject : "khác"}". Vui lòng chọn đúng danh mục môn để AI chấm bài chính xác nhất!',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // AI Score & Evaluation Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (isCorrect ? Colors.green : AppColors.error).withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: (isCorrect ? Colors.green : AppColors.error).withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: isCorrect ? Colors.green : AppColors.error,
                    child: Text(
                      '${widget.result.score}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              isCorrect ? 'Chúc mừng! Bài làm ĐÚNG 🎉' : 'Phát hiện lỗi sai ở Bước ${widget.result.errorStep}',
                              style: TextStyle(
                                color: isCorrect ? Colors.green : AppColors.error,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.result.errorExplanation,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Extracted Formula / Content Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nội dung trích xuất từ bài làm:',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  MathView(
                    tex: widget.result.extractedEquation,
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Socratic Hint Progression Buttons
            Text('Gợi ý gia sư AI Socratic', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildHintButton(
                    level: 1,
                    label: 'Gợi ý 1',
                    icon: Icons.lightbulb_outline,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildHintButton(
                    level: 2,
                    label: 'Gợi ý 2',
                    icon: Icons.psychology_outlined,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildHintButton(
                    level: 3,
                    label: 'Lời giải',
                    icon: Icons.check_circle_outline,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Display Active Hint Content
            if (_activeHintLevel > 0) _buildHintDisplayCard(isDark, primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHintButton({
    required int level,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _activeHintLevel >= level;

    return OutlinedButton.icon(
      onPressed: () {
        setState(() {
          _activeHintLevel = level;
        });
      },
      icon: Icon(icon, size: 16, color: isSelected ? Colors.white : color),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? color : Colors.transparent,
        foregroundColor: isSelected ? Colors.white : color,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _buildHintDisplayCard(bool isDark, Color primaryColor) {
    String content = '';
    String title = '';

    if (_activeHintLevel == 1) {
      title = 'Gợi ý 1';
      content = widget.result.hintLevel1;
    } else if (_activeHintLevel == 2) {
      title = 'Gợi ý 2';
      content = widget.result.hintLevel2;
    } else if (_activeHintLevel == 3) {
      title = 'Lời giải hoàn chỉnh';
      content = widget.result.fullSolution;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}
