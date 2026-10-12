class VerseItemModel {
  final String id;
  final String categoryTag;
  final String verseText;
  final String verseReference;
  final String imagePath;

  VerseItemModel({
    required this.id,
    this.categoryTag = 'VERSE OF THE DAY',
    required this.verseText,
    required this.verseReference,
    required this.imagePath,
  });
}
