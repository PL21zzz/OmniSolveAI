import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omni_solve_ai/app/theme/app_theme.dart';
import 'package:omni_solve_ai/app/theme/theme_provider.dart';
import 'package:omni_solve_ai/features/auth/data/auth_repository.dart';
import 'package:omni_solve_ai/features/auth/presentation/login_screen.dart';

final activeUserModelProvider = StateProvider<UserModel?>((ref) => null);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeUser = ref.watch(activeUserModelProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    // If user is NOT logged in, display Login / Register Screen directly
    if (activeUser == null) {
      return const LoginScreen();
    }

    // If user IS logged in, display their real account information
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin Tài khoản'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 90),
        child: Column(
          children: [
            // User Avatar
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: primaryColor.withValues(alpha: 0.2),
                    backgroundImage: activeUser.photoUrl != null ? NetworkImage(activeUser.photoUrl!) : null,
                    child: activeUser.photoUrl == null
                        ? const Icon(Icons.person, size: 46, color: AppColors.primary)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: primaryColor,
                      child: const Icon(Icons.check, size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              activeUser.displayName.isNotEmpty ? activeUser.displayName : 'Người dùng OmniSolve',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  Icon(Icons.verified_user_rounded, color: Colors.green, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Đã đăng nhập Firebase',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Profile Information Cards (Real Data)
            _buildInputField('Họ và tên', activeUser.displayName, Icons.person_outline, isDark),
            const SizedBox(height: 10),
            _buildInputField('Email', activeUser.email, Icons.email_outlined, isDark),
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
            const SizedBox(height: 20),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(authRepositoryProvider).signOut();
                  ref.read(activeUserModelProvider.notifier).state = null;
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã đăng xuất tài khoản')),
                    );
                  }
                },
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 18),
                label: const Text('Đăng xuất tài khoản', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String value, IconData icon, bool isDark) {
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
              Expanded(
                child: Text(
                  value.isNotEmpty ? value : 'Chưa cập nhật',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
