class CaptionItem {
  final String id;
  final String caption;
  final String platform;
  final String imageUrl;
  final DateTime createdAt;

  const CaptionItem({
    required this.id,
    required this.caption,
    required this.platform,
    required this.imageUrl,
    required this.createdAt,
  });

  static List<CaptionItem> sampleData = [
    CaptionItem(
      id: '1',
      caption: 'Golden hour magic in the city...',
      platform: 'Instagram',
      imageUrl:
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    CaptionItem(
      id: '2',
      caption: 'Nothing beats Monday morning vibes...',
      platform: 'TikTok',
      imageUrl:
          'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=200',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    CaptionItem(
      id: '3',
      caption: 'Excited to share my latest project! 🚀',
      platform: 'LinkedIn',
      imageUrl:
          'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=200',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];
}
