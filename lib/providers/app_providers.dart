import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/caption_item.dart';

// ─── Onboarding ───────────────────────────────────────────────────────────────

final onboardingPageProvider = StateProvider<int>((ref) => 0);

// ─── Home ─────────────────────────────────────────────────────────────────────

enum SocialPlatform { instagram, tiktok, linkedin }

extension SocialPlatformExt on SocialPlatform {
  String get label {
    switch (this) {
      case SocialPlatform.instagram:
        return 'Instagram';
      case SocialPlatform.tiktok:
        return 'TikTok';
      case SocialPlatform.linkedin:
        return 'LinkedIn';
    }
  }
}

final selectedPlatformProvider = StateProvider<SocialPlatform?>(
  (ref) => null,
);

final contextTextProvider = StateProvider<String>((ref) => '');

final selectedImageProvider = StateProvider<File?>((_) => null);

final recentCaptionsProvider = StateProvider<List<CaptionItem>>(
  (ref) => CaptionItem.sampleData,
);

// ─── Workspace ────────────────────────────────────────────────────────────────

final generatedCaptionProvider = StateProvider<String>(
  (ref) =>
      'Nothing beats the sound of waves and the warmth of the sun. Just pure coastal magic today. 🌊✨ #SummerVibes #BeachDay',
);

final toneSliderProvider = StateProvider<double>((ref) => 35.0);
final vibeSliderProvider = StateProvider<double>((ref) => 75.0);

// ─── Generation state ─────────────────────────────────────────────────────────

enum GenerationStatus { idle, generating, success, error }

final generationStatusProvider = StateProvider<GenerationStatus>(
  (ref) => GenerationStatus.idle,
);

final generationProgressProvider = StateProvider<double>((ref) => 0.0);

// ─── Selected context tags ────────────────────────────────────────────────────

const List<String> allContextTags = [
  'At the beach',
  'Monday blues',
  'Golden Hour',
  'Travel',
  'Summer',
  'City vibes',
  'Nature',
  'Food',
];

final selectedTagsProvider = StateProvider<Set<String>>(
  (ref) => {'At the beach'},
);
