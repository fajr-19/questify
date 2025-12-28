import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:frontend/screens/models/music_item.dart';

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

  StateMachineController? _riveController;
  SMIInput<bool>? _isFlying;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _audioPlayer = AudioPlayer();

    // Listener Durasi & Posisi (Audioplayers 6.5.1)
    _audioPlayer.onDurationChanged.listen((d) {
      if (mounted) setState(() => duration = d);
    });

    _audioPlayer.onPositionChanged.listen((p) {
      if (mounted) setState(() => position = p);
    });

    // Listener Status Play/Pause
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
          _isFlying?.value = isPlaying;
        });
      }
    });

    // Otomatis pindah lagu jika selesai
    _audioPlayer.onPlayerComplete.listen((event) => _nextSong());

    _playHybrid();
  }

  Future<void> _playHybrid() async {
    final song = widget.playlist[currentIndex];
    setState(() {
      isLoading = true;
      position = Duration.zero;
      duration = Duration.zero;
    });

    try {
      await _audioPlayer.stop();

      // Tips: Mencari dengan format Artist - Title agar lebih akurat
      var search = await _yt.search.search("${song.artist} ${song.title}");

      if (search.isNotEmpty) {
        var video = search.first;
        var manifest = await _yt.videos.streamsClient.getManifest(video.id);

        // Mengambil bitrate tertinggi untuk kualitas suara jernih
        var audioStream = manifest.audioOnly.withHighestBitrate();

        await _audioPlayer.play(UrlSource(audioStream.url.toString()));
      }
    } catch (e) {
      debugPrint("Error playing music: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memutar lagu: ${song.title}")),
      );
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

  String _formatDuration(Duration d) {
    String minutes = d.inMinutes.toString().padLeft(2, '0');
    String seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _yt.close();
    _riveController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final song = widget.playlist[currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark mode ala Spotify
      appBar: AppBar(
        title: const Text(
          "NOW PLAYING",
          style: TextStyle(fontSize: 14, letterSpacing: 2),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Bagian Animasi Rive
          Expanded(
            flex: 4,
            child: Center(
              child: SizedBox(
                width: 300,
                child: RiveAnimation.asset(
                  'assets/rive/dash_music.riv',
                  fit: BoxFit.contain,
                  onInit: (artboard) {
                    final controller = StateMachineController.fromArtboard(
                      artboard,
                      'State Machine 1',
                    );
                    if (controller != null) {
                      artboard.addController(controller);
                      _riveController = controller;
                      _isFlying = controller.findInput<bool>('isPlay');
                      _isFlying?.value = isPlaying;
                    }
                  },
                ),
              ),
            ),
          ),

          // Bagian Info Lagu & Slider
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Text(
                    song.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    song.artist,
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                  ),

                  const SizedBox(height: 30),

                  // Slider Durasi
                  if (isLoading)
                    const LinearProgressIndicator(color: Colors.purpleAccent)
                  else
                    Column(
                      children: [
                        Slider(
                          min: 0,
                          max: duration.inSeconds.toDouble() > 0
                              ? duration.inSeconds.toDouble()
                              : 1.0,
                          value: position.inSeconds.toDouble().clamp(
                            0,
                            duration.inSeconds.toDouble() > 0
                                ? duration.inSeconds.toDouble()
                                : 1.0,
                          ),
                          activeColor: Colors.purpleAccent,
                          inactiveColor: Colors.white10,
                          onChanged: (value) async {
                            await _audioPlayer.seek(
                              Duration(seconds: value.toInt()),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(position),
                                style: const TextStyle(color: Colors.white54),
                              ),
                              Text(
                                _formatDuration(duration),
                                style: const TextStyle(color: Colors.white54),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 20),

                  // Kontrol Playback
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.skip_previous,
                          size: 45,
                          color: Colors.white,
                        ),
                        onPressed: _prevSong,
                      ),
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 40,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            if (isPlaying) {
                              _audioPlayer.pause();
                            } else {
                              _audioPlayer.resume();
                            }
                          },
                        ),
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
            ),
          ),
        ],
      ),
    );
  }
}
