class MusicItem {
  final String id;
  final String title;
  final String imageUrl;
  final String artist;

  MusicItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.artist,
  });

  factory MusicItem.fromJson(Map<String, dynamic> json) {
    return MusicItem(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      artist: json['artist'] ?? '',
    );
  }
}
