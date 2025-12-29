class MusicItem {
  final String id;
  final String title;
  final String artist;
  final String? coverUrl;
  final String? audioUrl;
  final String? youtubeId; // Tambahkan ini
  final String? description;

  MusicItem({
    required this.id,
    required this.title,
    required this.artist,
    this.coverUrl,
    this.audioUrl,
    this.youtubeId,
    this.description,
  });

  factory MusicItem.fromJson(Map<String, dynamic> json) {
    return MusicItem(
      // Mengatasi perbedaan id dari MongoDB (_id) atau iTunes (id)
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title'] ?? json['trackName'] ?? 'Unknown Title',
      artist: json['artist'] ?? json['artistName'] ?? 'Unknown Artist',
      coverUrl: json['thumbnail'] ?? json['coverUrl'] ?? json['artworkUrl100'],
      audioUrl: json['audioUrl'] ?? json['previewUrl'],
      youtubeId: json['youtubeId'], // Mapping youtubeId dari backend
      description: json['description'] ?? json['collectionName'],
    );
  }
}
