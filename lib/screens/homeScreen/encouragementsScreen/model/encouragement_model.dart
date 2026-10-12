class EncouragementModel {
  final String title;
  final String subtitle;
  final String imagePath;
  final String categoryTag;
  final String contentText;

  EncouragementModel({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.categoryTag = 'ENCOURAGEMENTS',
    this.contentText = '''Heavenly Father, I come to You with open hands and a grateful heart. Today I surrender my plans, my worries, and my fears into Your care.

Lead me in Your wisdom. Quiet the noise within me, and let Your peace be the first thing I hear. Help me to trust that You are good, that You are near, and that You are working in every detail of my life.

Shape my words, guide my steps, and fill my heart with Your love so that I may be a light to others.

In Jesus' name, Amen.''',
  });
}
