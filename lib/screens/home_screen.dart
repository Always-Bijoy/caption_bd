import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../core/app_colors.dart';
import '../models/caption_item.dart';
import '../providers/app_providers.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/glass_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _contextController = TextEditingController();
  int _navIndex = 0;

  @override
  void dispose() {
    _contextController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      ref.read(selectedImageProvider.notifier).state = File(file.path);
      if (mounted) context.push('/workspace');
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedPlatform = ref.watch(selectedPlatformProvider);
    final selectedImage = ref.watch(selectedImageProvider);
    final recentCaptions = ref.watch(recentCaptionsProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.backgroundGradient,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Status bar spacer + header
                  SliverToBoxAdapter(
                    child: SafeArea(
                      bottom: false,
                      child: _HomeHeader(),
                    ),
                  ),

                  // Hero text
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Authentic\nCaptions',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.15,
                              shadows: [
                                Shadow(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 500.ms)
                              .slideX(begin: -0.1, end: 0),
                          const SizedBox(height: 6),
                          Text(
                            'AI-powered, human-sounding social copy.',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 100.ms, duration: 400.ms),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Upload card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _UploadCard(
                        pickedImage: selectedImage,
                        onTap: _pickImage,
                      )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 500.ms)
                          .slideY(begin: 0.1, end: 0),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 28)),

                  // Quick Start platforms
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'QUICK START',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.5,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 120,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            children: [
                              _PlatformButton(
                                label: 'Instagram',
                                icon: Icons.photo_camera_rounded,
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFFFDC80),
                                    Color(0xFFF56040),
                                    Color(0xFFE1306C),
                                  ],
                                ),
                                shadowColor: const Color(0xFFA1204C),
                                isSelected: selectedPlatform == SocialPlatform.instagram,
                                onTap: () => ref.read(selectedPlatformProvider.notifier).state =
                                    SocialPlatform.instagram,
                              ),
                              const SizedBox(width: 14),
                              _PlatformButton(
                                label: 'TikTok',
                                icon: Icons.music_note_rounded,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF111111), Color(0xFF333333)],
                                ),
                                shadowColor: const Color(0xFF333333),
                                isSelected: selectedPlatform == SocialPlatform.tiktok,
                                onTap: () => ref.read(selectedPlatformProvider.notifier).state =
                                    SocialPlatform.tiktok,
                              ),
                              const SizedBox(width: 14),
                              _PlatformButton(
                                label: 'LinkedIn',
                                icon: Icons.work_rounded,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF0077B5), Color(0xFF00A0DC)],
                                ),
                                shadowColor: const Color(0xFF004B73),
                                isSelected: selectedPlatform == SocialPlatform.linkedin,
                                onTap: () => ref.read(selectedPlatformProvider.notifier).state =
                                    SocialPlatform.linkedin,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 400.ms),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 28)),

                  // Context input
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MANUAL DETAILS',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.5,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _ContextInput(controller: _contextController),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 350.ms, duration: 400.ms),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Generate button
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _GenerateMagicButton(
                        onTap: () => context.push('/workspace'),
                      )
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 400.ms)
                          .slideY(begin: 0.15, end: 0),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 28)),

                  // Recent creations
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'RECENT CREATIONS',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.5,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'View History',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 12)),

                  SliverList.separated(
                    itemCount: recentCaptions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _RecentCaptionCard(item: recentCaptions[i])
                            .animate(delay: Duration(milliseconds: 50 * i))
                            .fadeIn(duration: 400.ms)
                            .slideX(begin: 0.05, end: 0),
                      );
                    },
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 140)),
                ],
              ),
            ),
            AppBottomNav(
              currentIndex: _navIndex,
              onTap: (i) => setState(() => _navIndex = i),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 4)),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.accentPurple,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'CaptionBD',
            style: GoogleFonts.beVietnamPro(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
              shadows: [
                Shadow(
                  color: Colors.white.withValues(alpha: 0.3),
                  blurRadius: 15,
                ),
              ],
            ),
          ),
          const Spacer(),
          GlassCard(
            borderRadius: 9999,
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.person_rounded, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }
}

// ─── Upload card ──────────────────────────────────────────────────────────────

class _UploadCard extends StatelessWidget {
  final File? pickedImage;
  final VoidCallback onTap;
  const _UploadCard({this.pickedImage, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        borderRadius: 28,
        borderColor: Colors.white.withValues(alpha: 0.4),
        child: Stack(
          children: [
            // Decorative blur blob
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.white, Color(0xB3FFFFFF)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 6)),
                          ],
                        ),
                        child: pickedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.file(pickedImage!, fit: BoxFit.cover),
                              )
                            : const Icon(
                                Icons.add_photo_alternate_rounded,
                                size: 44,
                                color: AppColors.accentPurple,
                              ),
                      ),
                      Positioned(
                        bottom: -6,
                        right: -6,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade400,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.accentPurple,
                              width: 3,
                            ),
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Upload Your Story',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tap to pick from gallery',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cloud_upload_rounded, color: AppColors.accentPurple, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Select Media',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accentPurple,
                          ),
                        ),
                      ],
                    ),
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

// ─── Platform button ──────────────────────────────────────────────────────────

class _PlatformButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Gradient gradient;
  final Color shadowColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlatformButton({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.shadowColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withValues(alpha: isSelected ? 0.7 : 0.5),
              blurRadius: 0,
              offset: Offset(0, isSelected ? 3 : 6),
            ),
          ],
          border: isSelected
              ? Border.all(color: Colors.white.withValues(alpha: 0.6), width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 36),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Context input ────────────────────────────────────────────────────────────

class _ContextInput extends ConsumerWidget {
  final TextEditingController controller;
  const _ContextInput({required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCard(
      borderRadius: 20,
      child: Stack(
        children: [
          TextField(
            controller: controller,
            maxLines: 3,
            style: GoogleFonts.beVietnamPro(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Tell us about the vibe of this post...',
              hintStyle: GoogleFonts.beVietnamPro(
                color: Colors.white.withValues(alpha: 0.5),
                fontWeight: FontWeight.w400,
              ),
              contentPadding: const EdgeInsets.fromLTRB(20, 18, 100, 18),
              border: InputBorder.none,
            ),
            onChanged: (v) => ref.read(contextTextProvider.notifier).state = v,
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_note_rounded, size: 13, color: Colors.white.withValues(alpha: 0.9)),
                  const SizedBox(width: 4),
                  Text(
                    'Context Mode',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Generate Magic button ────────────────────────────────────────────────────

class _GenerateMagicButton extends StatelessWidget {
  final VoidCallback onTap;
  const _GenerateMagicButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 62,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.4),
              blurRadius: 40,
              offset: const Offset(0, 10),
              spreadRadius: -10,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_fix_high_rounded, color: AppColors.accentPurple, size: 26),
            const SizedBox(width: 10),
            Text(
              'Generate Magic',
              style: GoogleFonts.beVietnamPro(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.accentPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Recent caption card ──────────────────────────────────────────────────────

class _RecentCaptionCard extends StatelessWidget {
  final CaptionItem item;
  const _RecentCaptionCard({required this.item});

  String get _timeAgo {
    final diff = DateTime.now().difference(item.createdAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 18,
      borderColor: Colors.white.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                width: 54,
                height: 54,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 54,
                  height: 54,
                  color: Colors.white12,
                  child: const Icon(Icons.image_rounded, color: Colors.white38),
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 54,
                  height: 54,
                  color: Colors.white12,
                  child: const Icon(Icons.broken_image_rounded, color: Colors.white38),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.platform} • $_timeAgo',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.4)),
          ],
        ),
      ),
    );
  }
}
