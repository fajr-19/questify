import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:frontend/screens/models/music_item.dart';
import 'package:frontend/api_service.dart';

class MusicPlayerScreen extends StatefulWidget {
  final List<MusicItem> playlist;
  final int initialIndex;

  const MusicPlayerScreen({
    super.key,
    required this.playlist,
    required this.initialIndex,
  });

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late AudioPlayer _audioPlayer;
  final YoutubeExplode _yt = YoutubeExplode();
  late int currentIndex;
  bool isPlaying = false;
  bool isLoading = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _audioPlayer = AudioPlayer();

    _audioPlayer.onDurationChanged.listen((d) => setState(() => duration = d));
    _audioPlayer.onPositionChanged.listen((p) => setState(() => position = p));
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => isPlaying = state == PlayerState.playing);
    });

    _audioPlayer.onPlayerComplete.listen((event) => _nextSong());
    _playHybrid();
  }

  Future<void> _playHybrid() async {
    final song = widget.playlist[currentIndex];
    setState(() {
      isLoading = true;
      position = Duration.zero;
    });

    try {
      await _audioPlayer.stop();
      String? streamUrl;

      // 1. Cek Cache Backend
      if (song.youtubeId != null && song.youtubeId!.isNotEmpty) {
        var manifest = await _yt.videos.streamsClient.getManifest(
          song.youtubeId,
        );
        streamUrl = manifest.audioOnly.withHighestBitrate().url.toString();
      }
      // 2. Search YouTube jika tidak ada cache
      else {
        var search = await _yt.search.search("${song.artist} ${song.title}");
        if (search.isNotEmpty) {
          var video = search.first;
          var manifest = await _yt.videos.streamsClient.getManifest(video.id);
          streamUrl = manifest.audioOnly.withHighestBitrate().url.toString();
          // Simpan ke backend agar next time cepat
          ApiService.cacheYoutubeId(song.id, video.id.value);
        }
      }

      if (streamUrl != null) {
        await _audioPlayer.play(UrlSource(streamUrl));
      } else if (song.audioUrl != null) {
        await _audioPlayer.play(UrlSource(song.audioUrl!));
      }
    } catch (e) {
      debugPrint("Playback Error: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _nextSong() {
    setState(() => currentIndex = (currentIndex + 1) % widget.playlist.length);
    _playHybrid();
  }

  void _prevSong() {
    setState(
      () => currentIndex =
          (currentIndex - 1 + widget.playlist.length) % widget.playlist.length,
    );
    _playHybrid();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _yt.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final song = widget.playlist[currentIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Cover Art
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(song.coverUrl ?? ""),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            song.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            song.artist,
            style: const TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 30),
          if (isLoading)
            const CircularProgressIndicator(color: Colors.purpleAccent),
          Slider(
            value: position.inSeconds.toDouble(),
            max: duration.inSeconds.toDouble() > 0
                ? duration.inSeconds.toDouble()
                : 1.0,
            onChanged: (v) => _audioPlayer.seek(Duration(seconds: v.toInt())),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.skip_previous,
                  size: 45,
                  color: Colors.white,
                ),
                onPressed: _prevSong,
              ),
              IconButton(
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  size: 70,
                  color: Colors.white,
                ),
                onPressed: () =>
                    isPlaying ? _audioPlayer.pause() : _audioPlayer.resume(),
              ),
              IconButton(
                icon: const Icon(
                  Icons.skip_next,
                  size: 45,
                  color: Colors.white,
                ),
                onPressed: _nextSong,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
