class MusicItem {
  final String id;
  final String title;
  final String image;
  final String type;

  MusicItem({
    required this.id,
    required this.title,
    required this.image,
    required this.type,
  });

  factory MusicItem.fromJson(Map<String, dynamic> json) {
    return MusicItem(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      type: json['type'],
    );
  }
}
