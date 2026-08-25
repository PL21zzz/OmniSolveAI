import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omni_solve_ai/app/theme/app_theme.dart';
import 'package:omni_solve_ai/features/auth/presentation/profile_screen.dart';
import 'package:omni_solve_ai/features/home/presentation/home_screen.dart';
import 'package:omni_solve_ai/features/scanner/presentation/scanner_screen.dart';
import 'package:omni_solve_ai/features/ai_chat/presentation/chat_screen.dart';
import 'package:omni_solve_ai/features/flashcards/presentation/flashcards_screen.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class MainWrapper extends ConsumerWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final activeUser = ref.watch(activeUserModelProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isLoginViewActive = currentIndex == 4 && activeUser == null;

    final screens = const [
      HomeScreen(),
      ScannerScreen(),
      ChatScreen(),
      FlashcardsScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: isLoginViewActive
          ? null
          : SafeArea(
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _NavItem(
                        index: 0,
                        currentIndex: currentIndex,
                        icon: Icons.home_rounded,
                        label: 'Trang chủ',
                        onTap: () => ref.read(navigationIndexProvider.notifier).state = 0,
                      ),
                    ),
                    Expanded(
                      child: _NavItem(
                        index: 1,
                        currentIndex: currentIndex,
                        icon: Icons.document_scanner_rounded,
                        label: 'Chẩn đoán',
                        onTap: () => ref.read(navigationIndexProvider.notifier).state = 1,
                      ),
                    ),
                    Expanded(
                      child: _NavItem(
                        index: 2,
                        currentIndex: currentIndex,
                        icon: Icons.auto_awesome_rounded,
                        label: 'AI Tutor',
                        onTap: () => ref.read(navigationIndexProvider.notifier).state = 2,
                      ),
                    ),
                    Expanded(
                      child: _NavItem(
                        index: 3,
                        currentIndex: currentIndex,
                        icon: Icons.style_rounded,
                        label: 'Flashcard',
                        onTap: () => ref.read(navigationIndexProvider.notifier).state = 3,
                      ),
                    ),
                    Expanded(
                      child: _NavItem(
                        index: 4,
                        currentIndex: currentIndex,
                        icon: Icons.person_rounded,
                        label: 'Tài khoản',
                        onTap: () => ref.read(navigationIndexProvider.notifier).state = 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
        decoration: isSelected
            ? BoxDecoration(
                color: primaryColor.withValues(alpha: isDark ? 0.2 : 0.12),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? primaryColor
                  : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? primaryColor
                      : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
