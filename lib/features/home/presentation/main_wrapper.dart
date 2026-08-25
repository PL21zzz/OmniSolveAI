import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omni_solve_ai/app/theme/app_theme.dart';
import 'package:omni_solve_ai/features/home/presentation/home_screen.dart';
import 'package:omni_solve_ai/features/scanner/presentation/scanner_screen.dart';
import 'package:omni_solve_ai/features/ai_chat/presentation/chat_screen.dart';
import 'package:omni_solve_ai/features/flashcards/presentation/flashcards_screen.dart';
import 'package:omni_solve_ai/features/auth/presentation/profile_screen.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class MainWrapper extends ConsumerWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screens = const [
      HomeScreen(),
      ScannerScreen(),
      ChatScreen(),
      FlashcardsScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        height: 72,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(36),
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              index: 0,
              currentIndex: currentIndex,
              icon: Icons.home_rounded,
              label: 'Trang chủ',
              onTap: () => ref.read(navigationIndexProvider.notifier).state = 0,
            ),
            _NavItem(
              index: 1,
              currentIndex: currentIndex,
              icon: Icons.document_scanner_rounded,
              label: 'Chẩn đoán',
              onTap: () => ref.read(navigationIndexProvider.notifier).state = 1,
            ),
            _NavItem(
              index: 2,
              currentIndex: currentIndex,
              icon: Icons.auto_awesome_rounded,
              label: 'AI Tutor',
              onTap: () => ref.read(navigationIndexProvider.notifier).state = 2,
            ),
            _NavItem(
              index: 3,
              currentIndex: currentIndex,
              icon: Icons.style_rounded,
              label: 'Flashcard',
              onTap: () => ref.read(navigationIndexProvider.notifier).state = 3,
            ),
            _NavItem(
              index: 4,
              currentIndex: currentIndex,
              icon: Icons.person_rounded,
              label: 'Tài khoản',
              onTap: () => ref.read(navigationIndexProvider.notifier).state = 4,
            ),
          ],
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
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: primaryColor.withOpacity(isDark ? 0.2 : 0.12),
                borderRadius: BorderRadius.circular(24),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? primaryColor
                  : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? primaryColor
                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
