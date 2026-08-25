import 'package:flutter/material.dart';
import 'package:omni_solve_ai/app/theme/app_theme.dart';

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  int _currentCardIndex = 0;
  bool _isFlipped = false;

  final List<Map<String, String>> _flashcards = [
    {
      'question': 'Công thức tích phân từng phần (Integration by Parts) là gì?',
      'answer': r'\int u \, dv = uv - \int v \, du',
      'subject': 'Giải tích',
    },
    {
      'question': 'Định luật II Newton phát biểu như thế nào?',
      'answer': r'\vec{F} = m \cdot \vec{a}',
      'subject': 'Vật lý',
    },
    {
      'question': 'Phương trình trạng thái khí lý tưởng?',
      'answer': r'P \cdot V = n \cdot R \cdot T',
      'subject': 'Hóa học',
    },
  ];

  void _nextCard() {
    setState(() {
      _isFlipped = false;
      _currentCardIndex = (_currentCardIndex + 1) % _flashcards.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final card = _flashcards[_currentCardIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bộ thẻ Ôn tập Flashcard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('AI đang tự động tạo bộ Flashcard mới từ bài tập lỗi...')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thẻ ${_currentCardIndex + 1} / ${_flashcards.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    card['subject']!,
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (_currentCardIndex + 1) / _flashcards.length,
                minHeight: 8,
                backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightCardBorder,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
            const SizedBox(height: 30),

            // Interactive Flip Card
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isFlipped = !_isFlipped;
                  });
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    final rotate = Tween(begin: 3.14, end: 0.0).animate(animation);
                    return AnimatedBuilder(
                      animation: rotate,
                      child: child,
                      builder: (context, child) {
                        return Transform(
                          transform: Matrix4.rotationY(rotate.value),
                          alignment: Alignment.center,
                          child: child,
                        );
                      },
                    );
                  },
                  child: Container(
                    key: ValueKey(_isFlipped),
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _isFlipped
                          ? primaryColor.withOpacity(isDark ? 0.2 : 0.1)
                          : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _isFlipped
                            ? primaryColor
                            : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isFlipped ? Icons.check_circle_outline : Icons.help_outline_rounded,
                          size: 48,
                          color: _isFlipped ? primaryColor : Colors.grey,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _isFlipped ? 'ĐÁP ÁN KHÁI NIỆM' : 'CÂU HỎI BÀI TẬP',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isFlipped ? card['answer']! : card['question']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Chạm vào thẻ để lật mặt bài',
                          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Assessment Ratings (Spaced Repetition Feedback)
            Text(
              'Đánh giá mức độ ghi nhớ:',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextCard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withOpacity(0.2),
                      foregroundColor: Colors.redAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('🔴 Chưa thuộc'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextCard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.withOpacity(0.2),
                      foregroundColor: Colors.amber[800],
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('🟡 Khá thuộc'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextCard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.withOpacity(0.2),
                      foregroundColor: Colors.green,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('🟢 Thuộc lòng'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
