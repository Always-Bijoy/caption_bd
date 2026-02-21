import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette
  static const Color primary = Color(0xFFFF2D55);
  static const Color accentPurple = Color(0xFF8E2DE2);
  static const Color accentPink = Color(0xFFF000B8);
  static const Color accentIndigo = Color(0xFF4F46E5);

  // Gradient stops
  static const List<Color> backgroundGradient = [
    Color(0xFF4F46E5),
    Color(0xFF8E2DE2),
    Color(0xFFF000B8),
  ];

  // Workspace (light) background
  static const List<Color> workspaceBgGradient = [
    Color(0xFFFFF5F5),
    Color(0xFFF0F4FF),
    Color(0xFFF5FFF9),
  ];

  // Generating screen background
  static const List<Color> generatingBgGradient = [
    Color(0xFF4C1D95),
    Color(0xFF831843),
  ];

  // Onboarding screen 1 background
  static const Color onboarding1BgStart = Color(0xFF3B2B8C);
  static const Color onboarding1BgEnd = Color(0xFF221019);

  // Onboarding screen 3 background
  static const Color onboarding3TealBg = Color(0xFF0F4C5C);
  static const Color onboarding3DarkBg = Color(0xFF22101C);

  // Glass colors
  static const Color glassBg = Color(0x26FFFFFF); // 15% white
  static const Color glassBorder = Color(0x4DFFFFFF); // 30% white

  // Nav bar
  static const Color navBg = Color(0xB20F1115); // 70% dark

  // Secondary accent
  static const Color secondary = Color(0xFF4ECDC4);

  // Text
  static const Color textWhite = Colors.white;
  static const Color textWhite60 = Color(0x99FFFFFF);
  static const Color textSlate800 = Color(0xFF1E293B);
  static const Color textSlate500 = Color(0xFF64748B);
  static const Color textSlate400 = Color(0xFF94A3B8);

  // Platform colors
  static const Color instagramStart = Color(0xFFFFDC80);
  static const Color instagramMid = Color(0xFFF56040);
  static const Color instagramEnd = Color(0xFFE1306C);
  static const Color tiktokBg = Color(0xFF000000);
  static const Color linkedinBg = Color(0xFF0077B5);

  // Onboarding primary (slide 1 & 3)
  static const Color onboardingPrimary = Color(0xFFEE2B8C);
}
