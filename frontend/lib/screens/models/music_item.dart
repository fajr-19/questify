class MusicItem {
  final String id;
  final String title;
  final String artist;
  final String image;

  MusicItem({
    required this.id,
    required this.title,
    required this.artist,
    required this.image,
  });

  factory MusicItem.fromJson(Map<String, dynamic> json) {
    return MusicItem(
      id: json['_id']?.toString() ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      image: json['image'] ?? 'https://picsum.photos/200', // fallback aman
    );
  }
}
