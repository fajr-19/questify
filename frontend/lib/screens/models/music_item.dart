class MusicItem {
  final String id;
  final String title;
  final String artist;
  final String imageUrl; // Pastikan namanya imageUrl
  final String? audioUrl;

  MusicItem({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
    this.audioUrl,
  });

  factory MusicItem.fromJson(Map<String, dynamic> json) {
    return MusicItem(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Unknown Title',
      artist: json['artist'] ?? 'Unknown Artist',
      imageUrl:
          json['imageUrl'] ?? 'https://placehold.co/200x200/png?text=Music',
      audioUrl: json['audioUrl'],
    );
  }
}
