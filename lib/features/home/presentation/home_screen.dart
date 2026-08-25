import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:omni_solve_ai/app/theme/app_theme.dart';
import 'package:omni_solve_ai/app/theme/theme_provider.dart';
import 'package:omni_solve_ai/features/auth/presentation/profile_screen.dart';
import 'package:omni_solve_ai/features/home/presentation/main_wrapper.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  ImageProvider? _getAvatarImageProvider(String? photoUrl) {
    if (photoUrl != null && photoUrl.isNotEmpty) {
      if (photoUrl.startsWith('data:image')) {
        try {
          final base64Str = photoUrl.split(',').last;
          return MemoryImage(base64Decode(base64Str));
        } catch (_) {
          return null;
        }
      } else {
        return NetworkImage(photoUrl);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final activeUser = ref.watch(activeUserModelProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final userName = activeUser != null && activeUser.displayName.isNotEmpty
        ? activeUser.displayName
        : 'bạn';

    final avatarImage = _getAvatarImageProvider(activeUser?.photoUrl);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: primaryColor.withValues(alpha: 0.2),
              backgroundImage: avatarImage,
              child: avatarImage == null
                  ? const Icon(Icons.person, color: AppColors.primary)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chào $userName! 👋',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    activeUser != null ? 'Hôm nay bạn muốn học gì?' : 'Đăng nhập để đồng bộ tiến độ',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
            icon: Icon(
              themeMode == ThemeMode.dark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
              color: primaryColor,
            ),
            tooltip: 'Đổi chế độ Sáng / Tối',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Streak Banner Card
            _buildStreakCard(context, isDark, primaryColor, activeUser != null),
            const SizedBox(height: 20),

            // Quick Actions Title
            Text(
              'Tính năng học tập AI',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            // Quick Actions Grid
            _buildQuickActions(context, ref, isDark),
            const SizedBox(height: 24),

            // Recent Solved Problems Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bài tập đã chấm điểm',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () => ref.read(navigationIndexProvider.notifier).state = 1,
                  child: const Text('Xem tất cả'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Recent Problems List
            _buildRecentProblemsList(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context, bool isDark, Color primaryColor, bool isLoggedIn) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0D9488), const Color(0xFF1E293B)]
              : [const Color(0xFF0D9488), const Color(0xFF2DD4BF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        isLoggedIn ? 'Chuỗi 7 ngày liên tục 🔥' : 'Tài khoản Khách 👤',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isLoggedIn ? 'Mục tiêu hôm nay: 4/5 bài' : 'Khởi động mục tiêu học tập!',
                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: isLoggedIn ? 0.8 : 0.2,
                    minHeight: 8,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref, bool isDark) {
    final List<Map<String, dynamic>> items = [
      {
        'title': 'AI Chấm Bài & Sửa Bài',
        'subtitle': 'Chụp ảnh bài làm của bạn',
        'icon': Icons.assignment_turned_in_rounded,
        'color': const Color(0xFF0D9488),
        'tab': 1,
      },
      {
        'title': 'Gia sư AI 24/7',
        'subtitle': 'Hỏi đáp mọi môn',
        'icon': Icons.chat_bubble_rounded,
        'color': const Color(0xFF6366F1),
        'tab': 2,
      },
      {
        'title': 'Bộ thẻ Flashcard',
        'subtitle': 'Ôn tập ghi nhớ',
        'icon': Icons.style_rounded,
        'color': const Color(0xFFEC4899),
        'tab': 3,
      },
      {
        'title': 'Thống kê năng lực',
        'subtitle': 'Xem tiến độ học',
        'icon': Icons.bar_chart_rounded,
        'color': const Color(0xFFF59E0B),
        'tab': 4,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final color = item['color'] as Color;

        return InkWell(
          onTap: () {
            ref.read(navigationIndexProvider.notifier).state = item['tab'] as int;
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Icon(item['icon'] as IconData, color: color, size: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  item['title'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  item['subtitle'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: (100 * index).ms).scale(begin: const Offset(0.95, 0.95));
      },
    );
  }

  Widget _buildRecentProblemsList(BuildContext context, bool isDark) {
    final List<Map<String, dynamic>> recentData = [
      {
        'title': 'Hệ phương trình vi phân bậc 2',
        'date': 'Thứ 3, 25 Tháng 8, 2026',
        'subject': 'Giải Tích III',
        'rating': 4.9,
        'status': 'Đã chấm: 9/10 đ',
        'tagColor': const Color(0xFF0D9488),
      },
      {
        'title': 'Định luật bảo toàn động lượng',
        'date': 'Thứ 2, 24 Tháng 8, 2026',
        'subject': 'Vật Lý Đại Cương',
        'rating': 5.0,
        'status': 'Đã chấm: 10/10 đ',
        'tagColor': const Color(0xFF6366F1),
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentData.length,
      itemBuilder: (context, index) {
        final data = recentData[index];
        final tagColor = data['tagColor'] as Color;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: tagColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.assignment_turned_in_rounded, color: tagColor, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['title'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${data['rating']}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '| ${data['date']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _buildChip(data['subject'] as String, tagColor, isDark),
                        _buildChip(data['status'] as String, Colors.green, isDark),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: (200 + index * 100).ms);
      },
    );
  }

  Widget _buildChip(String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.25 : 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
