import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_colors.dart';
import '../providers/app_providers.dart';
import '../widgets/app_bottom_nav.dart';

class GeneratingScreen extends ConsumerStatefulWidget {
  const GeneratingScreen({super.key});

  @override
  ConsumerState<GeneratingScreen> createState() => _GeneratingScreenState();
}

class _GeneratingScreenState extends ConsumerState<GeneratingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _spinController;
  late final AnimationController _progressController;
  late Timer _navigationTimer;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..forward();

    _progressController.addListener(() {
      ref.read(generationProgressProvider.notifier).state =
          _progressController.value;
    });

    _navigationTimer = Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        ref.read(generationStatusProvider.notifier).state =
            GenerationStatus.success;
        context.go('/success');
      }
    });
  }

  @override
  void dispose() {
    _spinController.dispose();
    _progressController.dispose();
    _navigationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(generationProgressProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.generatingBgGradient,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  // Header (dimmed)
                  SafeArea(
                    bottom: false,
                    child: Opacity(
                      opacity: 0.4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Generate',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.more_horiz_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Main loading card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 340),
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 50,
                            offset: const Offset(0, 25),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Circular loader with magic icon
                          SizedBox(
                            width: 180,
                            height: 180,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Spinning ring
                                AnimatedBuilder(
                                  animation: _spinController,
                                  builder: (_, __) {
                                    return Transform.rotate(
                                      angle: _spinController.value * 2 * math.pi,
                                      child: CustomPaint(
                                        size: const Size(180, 180),
                                        painter: _SpinnerPainter(),
                                      ),
                                    );
                                  },
                                ),
                                // Floating particles
                                ..._buildParticles(),
                                // Center icon
                                _MagicIcon()
                                    .animate(
                                        onPlay: (c) => c.repeat(reverse: true))
                                    .scaleXY(
                                      begin: 1.0,
                                      end: 1.05,
                                      duration: 1500.ms,
                                      curve: Curves.easeInOut,
                                    ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 36),
                          // Adding human touch text
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                const LinearGradient(
                              colors: [
                                Colors.white,
                                AppColors.secondary,
                                Colors.white,
                              ],
                            ).createShader(bounds),
                            child: Text(
                              'Adding human touch...',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                          )
                              .animate(onPlay: (c) => c.repeat(reverse: true))
                              .shimmer(duration: 2.seconds),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.secondary,
                                  shape: BoxShape.circle,
                                ),
                              )
                                  .animate(
                                      onPlay: (c) => c.repeat())
                                  .scaleXY(
                                    duration: 600.ms,
                                    begin: 1,
                                    end: 1.5,
                                    curve: Curves.easeOut,
                                  )
                                  .then()
                                  .scaleXY(end: 1, duration: 600.ms),
                              const SizedBox(width: 8),
                              Text(
                                'CRAFTING YOUR VIBE',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white60,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          // Progress bar
                          Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.white.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      height: 8,
                                      width: (MediaQuery.sizeOf(context).width -
                                              128) *
                                          progress,
                                      constraints: BoxConstraints(
                                        maxWidth: MediaQuery.sizeOf(context).width - 128,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            AppColors.secondary,
                                            AppColors.primary,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.secondary
                                                .withValues(alpha: 0.5),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 12,
                                  color: Colors.white54,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .scale(begin: const Offset(0.9, 0.9)),

                  const Spacer(),
                ],
              ),
            ),

            // Bottom nav (dimmed)
            Opacity(
              opacity: 0.3,
              child: IgnorePointer(
                child: AppBottomNav(currentIndex: 1, isDark: true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildParticles() {
    final particles = [
      _Particle(color: Colors.pink.shade300, size: 8, top: 0.25, left: 0.2),
      _Particle(color: Colors.yellow.shade300, size: 5, top: 0.3, right: 0.2),
      _Particle(color: Colors.cyan.shade300, size: 8, bottom: 0.2, right: 0.28),
      _Particle(color: Colors.purple.shade300, size: 6, top: 0.5, left: 0.1),
    ];
    return particles.map((p) {
      return Positioned(
        top: p.top != null ? 180 * p.top! : null,
        bottom: p.bottom != null ? 180 * p.bottom! : null,
        left: p.left != null ? 180 * p.left! : null,
        right: p.right != null ? 180 * p.right! : null,
        child: Container(
          width: p.size,
          height: p.size,
          decoration: BoxDecoration(
            color: p.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: p.color.withValues(alpha: 0.8), blurRadius: 8),
            ],
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scaleXY(
              begin: 0.8,
              end: 1.3,
              duration: Duration(milliseconds: 800 + (p.size * 100).toInt()),
              curve: Curves.easeInOut,
            ),
      );
    }).toList();
  }
}

class _Particle {
  final Color color;
  final double size;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const _Particle({
    required this.color,
    required this.size,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });
}

class _MagicIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          Icons.auto_fix_high_rounded,
          size: 72,
          color: Colors.white.withValues(alpha: 0.9),
          shadows: [
            Shadow(
              color: Colors.white.withValues(alpha: 0.8),
              blurRadius: 20,
            ),
          ],
        ),
        Positioned(
          top: -12,
          right: -12,
          child: const Icon(
            Icons.auto_awesome_rounded,
            size: 28,
            color: Colors.yellow,
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .rotate(begin: -0.1, end: 0.1, duration: 800.ms),
        ),
        Positioned(
          bottom: -6,
          left: -16,
          child: const Icon(
            Icons.electric_bolt_rounded,
            size: 22,
            color: AppColors.secondary,
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: 0, end: -5, duration: 700.ms),
        ),
      ],
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2 - 2,
      paint,
    );

    final activePaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.secondary, Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromLTWH(2, 2, size.width - 4, size.height - 4),
      -math.pi / 2,
      math.pi * 1.5,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(_SpinnerPainter oldDelegate) => false;
}
