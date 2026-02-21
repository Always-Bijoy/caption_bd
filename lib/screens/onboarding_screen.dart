import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_colors.dart';
import '../providers/app_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    final page = ref.read(onboardingPageProvider);
    if (page < 2) {
      ref.read(onboardingPageProvider.notifier).state = page + 1;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = ref.watch(onboardingPageProvider);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (i) =>
            ref.read(onboardingPageProvider.notifier).state = i,
        children: [
          _NaturalVoicePage(onNext: _next, page: page),
          _ToneControlPage(onNext: _next, page: page),
          _ReadyToPostPage(onNext: _next, page: page),
        ],
      ),
    );
  }
}

// ─── Slide 1: Ditch the Robot Speak ──────────────────────────────────────────

class _NaturalVoicePage extends StatelessWidget {
  final VoidCallback onNext;
  final int page;
  const _NaturalVoicePage({required this.onNext, required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.6, -0.7),
          radius: 1.5,
          colors: [
            AppColors.onboarding1BgStart,
            AppColors.onboarding1BgEnd,
          ],
        ),
      ),
      child: Stack(
        children: [
          // BG blobs
          Positioned(
            top: -80,
            left: -80,
            child: _Blob(color: AppColors.onboardingPrimary.withValues(alpha: 0.1), size: 300),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: _Blob(color: Colors.blue.withValues(alpha: 0.1), size: 300),
          ),
          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                // Illustration
                _PhoneMockupWithBubbles(),
                const Spacer(),
                // Text content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Ditch the\n',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 38,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.15,
                                letterSpacing: -0.5,
                              ),
                            ),
                            TextSpan(
                              text: 'Robot Speak',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 38,
                                fontWeight: FontWeight.w800,
                                color: AppColors.onboardingPrimary,
                                height: 1.15,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 16),
                      Text(
                        'Tired of captions that sound like a computer? CaptionBD creates natural, witty, and human-sounding captions.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                          height: 1.6,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 500.ms),
                      const SizedBox(height: 32),
                      _PageDots(current: page, total: 3),
                      const SizedBox(height: 32),
                      _GlowButton(label: 'Next', onTap: onNext),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Slide 2: Tone Control ────────────────────────────────────────────────────

class _ToneControlPage extends StatelessWidget {
  final VoidCallback onNext;
  final int page;
  const _ToneControlPage({required this.onNext, required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: _Blob(color: AppColors.accentPurple.withValues(alpha: 0.2), size: 250),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: _Blob(color: AppColors.primary.withValues(alpha: 0.15), size: 220),
          ),
          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                _ToneIllustration(),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Text(
                        'Control Your',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.15,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 200.ms),
                      Text(
                        'Tone & Vibe',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: AppColors.accentPurple,
                          height: 1.15,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 300.ms),
                      const SizedBox(height: 16),
                      Text(
                        'Slide between casual & formal, witty & serious. Full control over how your captions sound.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 16,
                          color: Colors.white70,
                          height: 1.6,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 400.ms),
                      const SizedBox(height: 32),
                      _PageDots(current: page, total: 3),
                      const SizedBox(height: 32),
                      _GlowButton(label: 'Next', onTap: onNext, color: AppColors.accentPurple),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Slide 3: Ready to Post ───────────────────────────────────────────────────

class _ReadyToPostPage extends StatelessWidget {
  final VoidCallback onNext;
  final int page;
  const _ReadyToPostPage({required this.onNext, required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.onboarding3TealBg,
            AppColors.onboarding3DarkBg,
            Color(0x3384CC16),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: -80,
            right: -80,
            child: _Blob(color: AppColors.onboardingPrimary.withValues(alpha: 0.1), size: 320),
          ),
          Positioned(
            top: -80,
            left: -80,
            child: _Blob(color: AppColors.onboarding3TealBg.withValues(alpha: 0.3), size: 280),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      _CircleButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () {},
                      ),
                      const Spacer(),
                      Text(
                        'STEP 3 OF 3',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: Colors.white60,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                const Spacer(),
                _SocialPlatformGrid()
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(begin: const Offset(0.9, 0.9)),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Text(
                        'Ready to Post?',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 200.ms),
                      const SizedBox(height: 12),
                      Text(
                        'Generate, copy, and grow your audience naturally.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 16,
                          color: Colors.white70,
                          height: 1.6,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 300.ms),
                      const SizedBox(height: 32),
                      _StartCreatingButton(onTap: onNext),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: onNext,
                        child: Text(
                          'Maybe later',
                          style: GoogleFonts.beVietnamPro(
                            color: Colors.white54,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _PageDots(current: page, total: 3),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared onboarding components ─────────────────────────────────────────────

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  final int current;
  final int total;
  const _PageDots({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.onboardingPrimary
                : AppColors.onboardingPrimary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _GlowButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;
  const _GlowButton({required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final btnColor = color ?? AppColors.onboardingPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(9999),
          boxShadow: [
            BoxShadow(
              color: btnColor.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.beVietnamPro(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 500.ms, duration: 400.ms)
        .slideY(begin: 0.3, end: 0);
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

// ─── Illustration widgets ─────────────────────────────────────────────────────

class _PhoneMockupWithBubbles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.onboardingPrimary.withValues(alpha: 0.2),
            ),
          ),
          // Phone
          Container(
            width: 110,
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFF334155), width: 5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 30,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: List.generate(
                      4,
                      (i) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        height: 6,
                        width: i % 2 == 0 ? double.infinity : 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF475569),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bubbles
          Positioned(
            top: 20,
            right: 10,
            child: _Bubble(text: 'So natural!', icon: Icons.auto_awesome_rounded, color: AppColors.onboardingPrimary),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            child: _Bubble(text: 'Not a robot...', icon: Icons.chat_bubble_outline_rounded, color: Colors.lightBlueAccent),
          ),
          Positioned(
            top: 100,
            left: 10,
            child: _EmojiPill(emoji: '😄', color: Colors.purple.shade300),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.85, 0.85));
  }
}

class _Bubble extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  const _Bubble({required this.text, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.beVietnamPro(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmojiPill extends StatelessWidget {
  final String emoji;
  final Color color;
  const _EmojiPill({required this.emoji, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.2),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 18)),
    );
  }
}

class _ToneIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          _MockSliderCard(
            leftLabel: 'Casual 😎',
            rightLabel: 'Formal 🎩',
            value: 0.35,
            color: AppColors.accentPurple,
          )
              .animate()
              .fadeIn(delay: 100.ms)
              .slideX(begin: -0.3, end: 0),
          const SizedBox(height: 16),
          _MockSliderCard(
            leftLabel: 'Witty 😏',
            rightLabel: 'Serious 🧐',
            value: 0.75,
            color: AppColors.secondary,
          )
              .animate()
              .fadeIn(delay: 200.ms)
              .slideX(begin: 0.3, end: 0),
          const SizedBox(height: 16),
          _MockCaptionCard()
              .animate()
              .fadeIn(delay: 300.ms),
        ],
      ),
    );
  }
}

class _MockSliderCard extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final double value;
  final Color color;
  const _MockSliderCard({
    required this.leftLabel,
    required this.rightLabel,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(leftLabel, style: GoogleFonts.beVietnamPro(fontSize: 11, color: Colors.white60)),
              Text(rightLabel, style: GoogleFonts.beVietnamPro(fontSize: 11, color: Colors.white60)),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: value,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Positioned(
                left: value * (MediaQuery.sizeOf(context).width - 120) - 12,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MockCaptionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_fix_high_rounded, color: AppColors.secondary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Vibes are immaculate rn ngl 🌊',
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.content_copy_rounded, color: Colors.white38, size: 18),
        ],
      ),
    );
  }
}

class _SocialPlatformGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          // Floating caption chip
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(bottom: 8, left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.onboardingPrimary,
                borderRadius: BorderRadius.circular(9999),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.onboardingPrimary.withValues(alpha: 0.4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Text(
                '"No filter needed"',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: 0, end: -6, duration: 1800.ms, curve: Curves.easeInOut),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
            children: [
              _PlatformCard(
                icon: Icons.photo_camera_rounded,
                label: 'Instagram',
                gradient: const LinearGradient(
                  colors: [Color(0xFFF9CE34), Color(0xFFEE2A7B), Color(0xFF6228D7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              Transform.translate(
                offset: const Offset(0, 16),
                child: _PlatformCard(
                  icon: Icons.music_note_rounded,
                  label: 'TikTok',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF111111), Color(0xFF333333)],
                  ),
                ),
              ),
              _PlatformCard(
                icon: Icons.work_rounded,
                label: 'LinkedIn',
                gradient: const LinearGradient(
                  colors: [Color(0xFF0077B5), Color(0xFF00A0DC)],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, 16),
                child: _PlatformCard(
                  icon: Icons.auto_awesome_rounded,
                  label: 'CaptionBD',
                  gradient: LinearGradient(
                    colors: [
                      AppColors.onboardingPrimary,
                      AppColors.onboardingPrimary.withValues(alpha: 0.6),
                    ],
                  ),
                  hasPrimaryBorder: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlatformCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Gradient gradient;
  final bool hasPrimaryBorder;
  const _PlatformCard({
    required this.icon,
    required this.label,
    required this.gradient,
    this.hasPrimaryBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasPrimaryBorder
              ? AppColors.onboardingPrimary.withValues(alpha: 0.4)
              : Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 10,
              color: hasPrimaryBorder
                  ? AppColors.onboardingPrimary
                  : Colors.white70,
              fontWeight: hasPrimaryBorder ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _StartCreatingButton extends StatelessWidget {
  final VoidCallback onTap;
  const _StartCreatingButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Glow ring
          Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9999),
              gradient: const LinearGradient(
                colors: [
                  AppColors.onboardingPrimary,
                  Color(0xFF84CC16),
                  AppColors.onboarding3TealBg,
                ],
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(9999),
              ),
              height: 58,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Start Creating',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.bolt_rounded, color: Colors.white, size: 22),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 400.ms)
        .scale(begin: const Offset(0.9, 0.9));
  }
}
