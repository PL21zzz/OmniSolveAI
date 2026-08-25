import 'package:flutter/material.dart';
import 'package:omni_solve_ai/app/theme/app_theme.dart';

class FlashcardItem {
  final String question;
  final String answer;
  final String subject;

  FlashcardItem({
    required this.question,
    required this.answer,
    required this.subject,
  });
}

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  int _currentCardIndex = 0;
  bool _isFlipped = false;

  final List<FlashcardItem> _userFlashcards = [
    FlashcardItem(
      question: "Từ vựng 'Smart' nghĩa là gì?",
      answer: "Thông minh, lanh lợi, hoặc ăn mặc chỉn chu lịch sự.",
      subject: "Tiếng Anh",
    ),
    FlashcardItem(
      question: "Công thức tích phân từng phần (Integration by Parts)?",
      answer: r"∫ u dv = uv - ∫ v du",
      subject: "Toán học",
    ),
    FlashcardItem(
      question: "Định luật II Newton phát biểu như thế nào?",
      answer: r"Véctơ Gia tốc cùng hướng với véctơ Lực tổng hợp: F⃗ = m • a⃗",
      subject: "Vật Lý",
    ),
    FlashcardItem(
      question: "Phương trình trạng thái khí lý tưởng?",
      answer: r"P • V = n • R • T",
      subject: "Hóa Học",
    ),
  ];

  void _nextCard() {
    if (_userFlashcards.isEmpty) return;
    setState(() {
      _isFlipped = false;
      _currentCardIndex = (_currentCardIndex + 1) % _userFlashcards.length;
    });
  }

  void _showAddCardDialog() {
    final questionController = TextEditingController();
    final answerController = TextEditingController();
    String selectedSubject = 'Tiếng Anh';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Thêm thẻ Flashcard Anki mới'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Môn học:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    DropdownButton<String>(
                      value: selectedSubject,
                      isExpanded: true,
                      items: ['Toán học', 'Vật Lý', 'Hóa Học', 'Tiếng Anh']
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedSubject = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: questionController,
                      decoration: const InputDecoration(
                        labelText: 'Mặt trước (Câu hỏi / Từ vựng)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: answerController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Mặt sau (Đáp án / Định nghĩa)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final q = questionController.text.trim();
                    final a = answerController.text.trim();
                    if (q.isNotEmpty && a.isNotEmpty) {
                      setState(() {
                        _userFlashcards.add(
                          FlashcardItem(question: q, answer: a, subject: selectedSubject),
                        );
                        _currentCardIndex = _userFlashcards.length - 1;
                        _isFlipped = false;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Đã thêm thẻ mới vào môn $selectedSubject!')),
                      );
                    }
                  },
                  child: const Text('Thêm thẻ'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final card = _userFlashcards.isNotEmpty ? _userFlashcards[_currentCardIndex] : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bộ thẻ Anki Flashcard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'Thêm thẻ Flashcard mới',
            onPressed: _showAddCardDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 90),
        child: Column(
          children: [
            // Top Bar with Add Button & Card Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thẻ ${_userFlashcards.isEmpty ? 0 : _currentCardIndex + 1} / ${_userFlashcards.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (card != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      card.subject,
                      style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _userFlashcards.isEmpty ? 0 : (_currentCardIndex + 1) / _userFlashcards.length,
                minHeight: 6,
                backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightCardBorder,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
            const SizedBox(height: 16),

            // Interactive Flip Card
            Expanded(
              child: card == null
                  ? const Center(child: Text('Chưa có thẻ nào. Bấm nút + để tạo thẻ mới!'))
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          _isFlipped = !_isFlipped;
                        });
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
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
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: _isFlipped
                                ? primaryColor.withValues(alpha: isDark ? 0.2 : 0.1)
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
                                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
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
                                size: 40,
                                color: _isFlipped ? primaryColor : Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _isFlipped ? 'MẶT SAU (ĐÁP ÁN / NGHĨA)' : 'MẶT TRƯỚC (CÂU HỎI / TỪ VỰNG)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                _isFlipped ? card.answer : card.question,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Chạm vào thẻ để lật mặt bài 🔄',
                                style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 16),

            // Add New Flashcard Quick Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showAddCardDialog,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('+ Thêm thẻ Flashcard tự chọn mới'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Assessment Ratings (Spaced Repetition Feedback)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextCard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withValues(alpha: 0.2),
                      foregroundColor: Colors.redAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text('🔴 Chưa thuộc', style: TextStyle(fontSize: 11)),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextCard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.withValues(alpha: 0.2),
                      foregroundColor: Colors.amber[800],
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text('🟡 Khá thuộc', style: TextStyle(fontSize: 11)),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextCard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.withValues(alpha: 0.2),
                      foregroundColor: Colors.green,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text('🟢 Thuộc lòng', style: TextStyle(fontSize: 11)),
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
