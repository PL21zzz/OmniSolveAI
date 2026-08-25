import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omni_solve_ai/app/theme/app_theme.dart';
import 'package:omni_solve_ai/app/theme/theme_provider.dart';
import 'package:omni_solve_ai/features/auth/presentation/login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin Tài khoản'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 90),
        child: Column(
          children: [
            // User Avatar with edit button (matching reference UI)
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: primaryColor.withValues(alpha: 0.2),
                    child: const Icon(Icons.person, size: 46, color: AppColors.primary),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: primaryColor,
                      child: const Icon(Icons.edit, size: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Phong Lang',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.g_mobiledata_rounded, color: Colors.green, size: 20),
                  SizedBox(width: 2),
                  Text(
                    'Đã liên kết Google Auth & Firestore',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Profile Fields Form (Matching reference UI input boxes)
            _buildInputField('Họ và tên', 'Phong Lang', Icons.person_outline, isDark),
            const SizedBox(height: 10),
            _buildInputField('Email Google', 'phonglang.dev@gmail.com', Icons.email_outlined, isDark),
            const SizedBox(height: 10),
            _buildInputField('Số điện thoại', '+84 988 363 8799', Icons.phone_outlined, isDark),
            const SizedBox(height: 20),

            // Theme & Preferences Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                ),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Chế độ Tối (Dark Mode)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: const Text('Tối ưu cho việc học tập ban đêm', style: TextStyle(fontSize: 11)),
                    value: themeMode == ThemeMode.dark,
                    activeColor: primaryColor,
                    onChanged: (val) {
                      ref.read(themeModeProvider.notifier).toggleTheme();
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Đồng bộ Cloud Firestore', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: const Text('Tự động lưu bài tập & Flashcard lên mây', style: TextStyle(fontSize: 11)),
                    value: true,
                    activeColor: primaryColor,
                    onChanged: (val) {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Login / Register Button & Signout Button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    icon: const Icon(Icons.login_rounded, size: 18),
                    label: const Text('Đăng nhập / Đăng ký'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã đăng xuất tài khoản')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Đăng xuất', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String initialValue, IconData icon, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey),
              const SizedBox(width: 10),
              Text(
                initialValue,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
