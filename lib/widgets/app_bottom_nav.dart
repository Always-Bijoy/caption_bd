import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final bool isDark;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final navItems = [
      _NavItem(Icons.home_rounded, 'Home'),
      _NavItem(Icons.auto_stories_rounded, 'Drafts'),
      _NavItem(Icons.stars_rounded, 'Styles'),
      _NavItem(Icons.settings_rounded, 'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.navBg : Colors.white.withValues(alpha: 0.85),
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(navItems.length, (i) {
              final item = navItems[i];
              final isSelected = i == currentIndex;
              final color = isDark
                  ? (isSelected ? Colors.white : Colors.white38)
                  : (isSelected ? AppColors.primary : Colors.grey.shade400);
              return GestureDetector(
                onTap: () => onTap?.call(i),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      color: color,
                      size: 26,
                    ),
                    if (isDark) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: color,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}
