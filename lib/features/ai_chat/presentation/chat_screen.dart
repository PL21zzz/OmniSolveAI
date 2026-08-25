import 'package:flutter/material.dart';
import 'package:omni_solve_ai/app/theme/app_theme.dart';
import 'package:omni_solve_ai/features/scanner/data/gemini_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          'Chào bạn! Tôi là Gia sư Gemini AI 🤖. Tôi hỗ trợ giải đáp 4 môn: Toán học, Vật Lý, Hóa Học và Tiếng Anh. Hãy đặt câu hỏi bất kỳ cho tôi nhé!',
      isUser: false,
    ),
  ];

  String _selectedSubject = 'Toán học';
  bool _isTyping = false;

  final List<String> _subjects = ['Toán học', 'Vật Lý', 'Hóa Học', 'Tiếng Anh'];

  Future<void> _sendMessage([String? customText]) async {
    final text = customText ?? _controller.text.trim();
    if (text.isEmpty) return;

    if (customText == null) {
      _controller.clear();
    }

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isTyping = true;
    });

    try {
      final service = GeminiService();
      final aiReply = await service.askAiTutor(
        query: text,
        subject: _selectedSubject,
      );

      if (!mounted) return;

      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(text: aiReply, isUser: false));
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: 'Gia sư AI bị gián đoạn kết nối. Vui lòng kiểm tra lại mạng.',
          isUser: false,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: primaryColor.withValues(alpha: 0.2),
              child: Icon(Icons.auto_awesome, color: primaryColor, size: 18),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gia sư AI 24/7 (4 Môn)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Text('Toán • Lý • Hóa • Tiếng Anh', style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 4-Subject Selector Bar
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _subjects.length,
              itemBuilder: (context, index) {
                final subject = _subjects[index];
                final isSelected = subject == _selectedSubject;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(subject),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedSubject = subject;
                      });
                    },
                    selectedColor: primaryColor.withValues(alpha: 0.2),
                    checkmarkColor: primaryColor,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? primaryColor
                          : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),

          // Chat Messages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildBubble(message, isDark, primaryColor);
              },
            ),
          ),

          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'Gia sư Gemini AI đang soạn câu trả lời...',
                    style: TextStyle(fontSize: 12, color: primaryColor, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),

          // Quick Action Prompt Chips
          Container(
            height: 42,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildQuickPromptChip('📐 Công thức tích phân từng phần?', primaryColor),
                _buildQuickPromptChip('🇬🇧 Smart nghĩa là gì?', primaryColor),
                _buildQuickPromptChip('🧪 Phản ứng oxy hóa khử là gì?', primaryColor),
              ],
            ),
          ),

          // Chat Input Field
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Hỏi gia sư AI về môn $_selectedSubject...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: primaryColor,
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(ChatMessage message, bool isDark, Color primaryColor) {
    final align = message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bg = message.isUser
        ? primaryColor
        : (isDark ? AppColors.darkSurface : AppColors.lightSurface);
    final textStyle = TextStyle(
      color: message.isUser
          ? Colors.white
          : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      fontSize: 13.5,
      height: 1.4,
    );

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: const BoxConstraints(maxWidth: 300),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: Radius.circular(message.isUser ? 20 : 4),
              bottomRight: Radius.circular(message.isUser ? 4 : 20),
            ),
            border: message.isUser
                ? null
                : Border.all(
                    color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                  ),
          ),
          child: Text(message.text, style: textStyle),
        ),
      ],
    );
  }

  Widget _buildQuickPromptChip(String prompt, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(prompt, style: const TextStyle(fontSize: 11)),
        onPressed: () => _sendMessage(prompt),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
