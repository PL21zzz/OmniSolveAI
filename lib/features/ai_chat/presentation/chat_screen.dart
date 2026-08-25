import 'package:flutter/material.dart';
import 'package:omni_solve_ai/app/theme/app_theme.dart';

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
          'Chào bạn! Tôi là Gia sư AI OmniSolve 🤖. Tôi có thể hỗ trợ bạn học 4 môn trọng tâm: Toán học, Vật Lý, Hóa Học và Tiếng Anh. Bạn cần hỏi gì hôm nay?',
      isUser: false,
    ),
  ];

  String _selectedSubject = 'Tiếng Anh';
  bool _isTyping = false;

  final List<String> _subjects = ['Toán học', 'Vật Lý', 'Hóa Học', 'Tiếng Anh'];

  void _sendMessage([String? customText]) {
    final text = customText ?? _controller.text.trim();
    if (text.isEmpty) return;

    if (customText == null) {
      _controller.clear();
    }

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isTyping = true;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      final aiReply = _generateDomainAwareReply(text, _selectedSubject);
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(text: aiReply, isUser: false));
      });
    });
  }

  String _generateDomainAwareReply(String query, String subject) {
    final lower = query.toLowerCase();

    // Check vocabulary or English dictionary queries
    if (lower.contains('smart') || lower.contains('nghĩa là gì') || lower.contains('dịch') || lower.contains('từ vựng') || subject == 'Tiếng Anh') {
      if (lower.contains('smart')) {
        return '''
📚 **Giải nghĩa từ 'Smart' (Tiếng Anh):**

• **Loại từ:** Tính từ (Adjective)
• **Phát âm:** /smɑːrt/

**Các nghĩa chính:**
1. **Thông minh, nhanh trí:**
   *Ví dụ:* "He is a smart student." (Cậu ấy là một học sinh thông minh).
2. **Lanh lợi, tinh khôn:**
   *Ví dụ:* "Smart phone" (Điện thoại thông minh).
3. **Lịch sự, chỉn chu (Ăn mặc):**
   *Ví dụ:* "You look very smart in that suit!" (Bạn trông rất lịch thiệp trong bộ vest đó).

👉 **Từ đồng nghĩa (Synonyms):** Intelligent, Clever, Bright, Sharp.
''';
      }

      return '''
🇬🇧 **Gia sư Tiếng Anh phản hồi:**

Về thắc mắc "$query":
• **Từ vựng / Cấu trúc:** Được dùng phổ biến trong giao tiếp Tiếng Anh hàng ngày.
• **Ví dụ mẫu:** "Learning English with AI is very efficient and smart."
• **Gợi ý:** Bạn có thể đặt câu thử với từ này và gửi lại để gia sư AI sửa lỗi ngữ pháp giúp bạn nhé!
''';
    }

    if (subject == 'Vật Lý' || lower.contains('lý') || lower.contains('vận tốc') || lower.contains('lực')) {
      return '''
⚡ **Gia sư Vật Lý phản hồi:**

Dựa trên thắc mắc về môn **Vật Lý**:
1. Khái niệm cốt lõi: $query liên quan đến các quy luật động học và bảo toàn năng lượng.
2. Công thức áp dụng: \$F = m \\cdot a\$ hoặc \$P = m \\cdot v\$.
3. Gợi ý: Hãy xác định rõ các đại lượng đã biết và đơn vị chuẩn (SI) trước khi thay số!
''';
    }

    if (subject == 'Hóa Học' || lower.contains('hóa') || lower.contains('phản ứng') || lower.contains('axit')) {
      return '''
🧪 **Gia sư Hóa Học phản hồi:**

Dựa trên câu hỏi về **Hóa Học**:
1. Phương trình phản ứng: Cần chú ý số oxy hóa của các nguyên tố thay đổi trước và sau phản ứng.
2. Mẹo cân bằng: Áp dụng phương pháp thăng bằng electron hoặc đếm nhóm nguyên tử cố định.
''';
    }

    // Default Math response
    return '''
📐 **Gia sư Toán Học phản hồi:**

Về bài toán liên quan đến "$query":
1. Phương pháp giải: Xác định điều kiện xác định của biến số, sau đó biến đổi biểu thức theo công thức lượng giác hoặc tích phân cơ bản.
2. Bạn có muốn gia sư AI hướng dẫn từng bước cụ thể không?
''';
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
                    'Gia sư AI đang tra cứu câu trả lời...',
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
                _buildQuickPromptChip('🇬🇧 Smart nghĩa là gì?', primaryColor),
                _buildQuickPromptChip('💡 Giải thích đơn giản hơn', primaryColor),
                _buildQuickPromptChip('📌 Cho ví dụ thực tế', primaryColor),
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
