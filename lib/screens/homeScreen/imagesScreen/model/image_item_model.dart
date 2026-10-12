class ImageItemModel {
  final String id;
  final String title;
  final String categoryTag;
  final String imagePath;
  final String quoteText;

  ImageItemModel({
    required this.id,
    required this.title,
    required this.categoryTag,
    required this.imagePath,
    this.quoteText = 'The Lord is near to all who call on Him.',
  });
}
