import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../core/app_colors.dart';
import '../providers/app_providers.dart';

class WorkspaceScreen extends ConsumerStatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  ConsumerState<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends ConsumerState<WorkspaceScreen> {
  late final TextEditingController _captionController;
  int _navIndex = 1;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController(
      text: ref.read(generatedCaptionProvider),
    );
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _copyCaption() async {
    await Clipboard.setData(
      ClipboardData(text: _captionController.text),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Caption copied!',
            style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _shareCaption() async {
    await Share.share(_captionController.text, subject: 'My CaptionBD caption');
  }

  void _humanize() {
    context.push('/generating');
  }

  @override
  Widget build(BuildContext context) {
    final selectedImage = ref.watch(selectedImageProvider);
    final selectedPlatform = ref.watch(selectedPlatformProvider);
    final selectedTags = ref.watch(selectedTagsProvider);
    final tone = ref.watch(toneSliderProvider);
    final vibe = ref.watch(vibeSliderProvider);
    final caption = ref.watch(generatedCaptionProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF5F5), Color(0xFFF0F4FF), Color(0xFFF5FFF9)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // App bar
                  SliverToBoxAdapter(
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Row(
                          children: [
                            _LightCircleButton(
                              icon: Icons.arrow_back_ios_new_rounded,
                              onTap: () => context.pop(),
                            ),
                            const Spacer(),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFF1E293B), Color(0xFF64748B)],
                              ).createShader(bounds),
                              child: Text(
                                'Workspace',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Spacer(),
                            _LightCircleButton(
                              icon: Icons.more_horiz_rounded,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Image preview card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                      child: _ImagePreviewCard(
                        image: selectedImage,
                        platform: selectedPlatform?.label ?? 'Instagram',
                      )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.08, end: 0),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 20)),

                  // Context tags
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'CONTEXT TAGS',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              color: AppColors.textSlate400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 42,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: allContextTags.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                            itemBuilder: (context, i) {
                              final tag = allContextTags[i];
                              final isSelected = selectedTags.contains(tag);
                              return _TagChip(
                                label: tag,
                                isSelected: isSelected,
                                index: i,
                                onTap: () {
                                  final tags = Set<String>.from(selectedTags);
                                  if (isSelected) {
                                    tags.remove(tag);
                                  } else {
                                    tags.add(tag);
                                  }
                                  ref.read(selectedTagsProvider.notifier).state = tags;
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 20)),

                  // Generated caption
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _CaptionCard(
                        controller: _captionController,
                        onCopy: _copyCaption,
                        onShare: _shareCaption,
                        onChanged: (v) =>
                            ref.read(generatedCaptionProvider.notifier).state = v,
                        captionText: caption,
                      )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 400.ms),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Tone balance slider
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _ToneSlider(
                        leftLabel: 'Casual',
                        rightLabel: 'Formal',
                        centerLabel: 'TONE BALANCE',
                        value: tone,
                        activeColor: AppColors.primary,
                        onChanged: (v) =>
                            ref.read(toneSliderProvider.notifier).state = v,
                      )
                          .animate()
                          .fadeIn(delay: 300.ms, duration: 400.ms),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Vibe level slider
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _ToneSlider(
                        leftLabel: 'Witty',
                        rightLabel: 'Serious',
                        centerLabel: 'VIBE LEVEL',
                        value: vibe,
                        activeColor: AppColors.secondary,
                        onChanged: (v) =>
                            ref.read(vibeSliderProvider.notifier).state = v,
                      )
                          .animate()
                          .fadeIn(delay: 350.ms, duration: 400.ms),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 28)),

                  // Humanize button
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _HumanizeButton(onTap: _humanize)
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 400.ms)
                          .slideY(begin: 0.1, end: 0),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
            ),
            _WorkspaceBottomNav(
              currentIndex: _navIndex,
              onTap: (i) => setState(() => _navIndex = i),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Image preview card ───────────────────────────────────────────────────────

class _ImagePreviewCard extends StatelessWidget {
  final File? image;
  final String platform;
  const _ImagePreviewCard({this.image, required this.platform});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE2D1C3).withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: image != null
                    ? Image.file(image!, fit: BoxFit.cover)
                    : Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFF9CE34), Color(0xFFEE2A7B), Color(0xFF6228D7)],
                          ),
                        ),
                        child: const Icon(Icons.photo_rounded, color: Colors.white, size: 32),
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SELECTED VIBE',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: AppColors.primary.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Summer Magic',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSlate800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    image != null ? 'your_photo.jpg' : 'beach_sunset_vibe.jpg',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      color: AppColors.textSlate500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _ColorDot(color: Colors.pink.shade300),
                      const SizedBox(width: 4),
                      _ColorDot(color: Colors.orange.shade300),
                      const SizedBox(width: 4),
                      _ColorDot(color: Colors.blue.shade300),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  const _ColorDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// ─── Tag chip ─────────────────────────────────────────────────────────────────

const _tagGradients = [
  [Color(0xFF60A5FA), Color(0xFF22D3EE)],
  [Color(0xFF818CF8), Color(0xFFA78BFA)],
  [Color(0xFFFB923C), Color(0xFFFACC15)],
  [Color(0xFFF472B6), Color(0xFFFB7185)],
  [Color(0xFF34D399), Color(0xFF2DD4BF)],
  [Color(0xFF60A5FA), Color(0xFF818CF8)],
  [Color(0xFF86EFAC), Color(0xFF34D399)],
  [Color(0xFFF9A8D4), Color(0xFFF472B6)],
];

class _TagChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final int index;
  final VoidCallback onTap;
  const _TagChip({
    required this.label,
    required this.isSelected,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = _tagGradients[index % _tagGradients.length];
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: gradient)
              : null,
          color: isSelected ? null : Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(
            color: isSelected
                ? gradient.first.withValues(alpha: 0.3)
                : Colors.grey.shade200,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: gradient.last.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.beVietnamPro(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSlate500,
          ),
        ),
      ),
    );
  }
}

// ─── Caption card ─────────────────────────────────────────────────────────────

class _CaptionCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final ValueChanged<String> onChanged;
  final String captionText;

  const _CaptionCard({
    required this.controller,
    required this.onCopy,
    required this.onShare,
    required this.onChanged,
    required this.captionText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Glow border
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.1),
                  AppColors.secondary.withValues(alpha: 0.1),
                ],
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.12),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'GENERATED CAPTION',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: AppColors.textSlate400,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9999),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        'PERSONALIZED',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  maxLines: null,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSlate800,
                    height: 1.6,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: onChanged,
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    _IconActionButton(
                      icon: Icons.content_copy_rounded,
                      onTap: onCopy,
                    ),
                    const SizedBox(width: 8),
                    _IconActionButton(
                      icon: Icons.share_rounded,
                      onTap: onShare,
                    ),
                    const Spacer(),
                    Text(
                      '${captionText.length} characters',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        color: AppColors.textSlate400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _IconActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Icon(icon, size: 18, color: AppColors.textSlate400),
      ),
    );
  }
}

// ─── Tone / Vibe slider ───────────────────────────────────────────────────────

class _ToneSlider extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final String centerLabel;
  final double value;
  final Color activeColor;
  final ValueChanged<double> onChanged;

  const _ToneSlider({
    required this.leftLabel,
    required this.rightLabel,
    required this.centerLabel,
    required this.value,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leftLabel.toUpperCase(),
                style: GoogleFonts.beVietnamPro(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSlate400,
                  letterSpacing: 1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9999),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 4),
                  ],
                ),
                child: Text(
                  centerLabel,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSlate800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                rightLabel.toUpperCase(),
                style: GoogleFonts.beVietnamPro(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSlate400,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: activeColor,
              inactiveTrackColor: const Color(0x0D000000),
              thumbColor: Colors.white,
              overlayColor: activeColor.withValues(alpha: 0.15),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
              trackHeight: 8,
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 22),
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 100,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Humanize button ──────────────────────────────────────────────────────────

class _HumanizeButton extends StatelessWidget {
  final VoidCallback onTap;
  const _HumanizeButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 62,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B6B).withValues(alpha: 0.5),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.auto_fix_high_rounded, color: Colors.white, size: 26),
                const SizedBox(width: 10),
                Text(
                  'Humanize Content',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline_rounded, size: 14, color: AppColors.textSlate400),
            const SizedBox(width: 6),
            Text(
              'POLISHING FOR NATURAL-SOUNDING FLOW',
              style: GoogleFonts.beVietnamPro(
                fontSize: 10,
                color: AppColors.textSlate400,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Light circle button ──────────────────────────────────────────────────────

class _LightCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _LightCircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.grey.withValues(alpha: 0.15), blurRadius: 8),
          ],
        ),
        child: Icon(icon, color: AppColors.textSlate800, size: 18),
      ),
    );
  }
}

// ─── Workspace bottom nav ─────────────────────────────────────────────────────

class _WorkspaceBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  const _WorkspaceBottomNav({required this.currentIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        border: Border(
          top: BorderSide(color: Colors.grey.shade100),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => onTap?.call(0),
                child: Icon(
                  Icons.home_rounded,
                  size: 28,
                  color: currentIndex == 0 ? AppColors.primary : Colors.grey.shade300,
                ),
              ),
              GestureDetector(
                onTap: () => onTap?.call(1),
                child: Icon(
                  Icons.edit_square,
                  size: 28,
                  color: currentIndex == 1 ? AppColors.primary : Colors.grey.shade300,
                ),
              ),
              GestureDetector(
                onTap: () => onTap?.call(2),
                child: Icon(
                  Icons.history_rounded,
                  size: 28,
                  color: currentIndex == 2 ? AppColors.primary : Colors.grey.shade300,
                ),
              ),
              GestureDetector(
                onTap: () => onTap?.call(3),
                child: Icon(
                  Icons.person_rounded,
                  size: 28,
                  color: currentIndex == 3 ? AppColors.primary : Colors.grey.shade300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
