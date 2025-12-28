class MusicItem {
  final String id;
  final String title;
  final String artist;
  final String? coverUrl;
  final String? audioUrl;
  final String? lyrics;
  final String? description;

  MusicItem({
    required this.id,
    required this.title,
    required this.artist,
    this.coverUrl,
    this.audioUrl,
    this.lyrics,
    this.description,
  });

  factory MusicItem.fromJson(Map<String, dynamic> json) {
    return MusicItem(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? 'Unknown Title',
      artist: json['artist'] ?? 'Unknown Artist',
      coverUrl: json['thumbnail'] ?? json['coverUrl'],
      audioUrl: json['audioUrl'],
      lyrics: json['lyrics'],
      description: json['description'],
    );
  }
}
