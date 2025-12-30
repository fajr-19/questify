class MusicItem {
  final String id;
  final String title;
  final String artist;
  final String? coverUrl;
  final String? audioUrl;
  final List<dynamic>? lyrics;
  final String type; // Tambahkan ini

  MusicItem({
    required this.id,
    required this.title,
    required this.artist,
    this.coverUrl,
    this.audioUrl,
    this.lyrics,
    required this.type,
  });

  factory MusicItem.fromJson(Map<String, dynamic> json) {
    return MusicItem(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      coverUrl: json['thumbnail'],
      audioUrl: json['audioUrl'],
      lyrics: json['lyrics'] is List ? json['lyrics'] : null,
      type: json['type'] ?? 'music',
    );
  }
}
