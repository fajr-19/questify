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

  // Mendefinisikan class dengan prefix 'rive.' secara eksplisit
  StateMachineController? _riveController;
  SMIInput<bool>? _isFlying;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _audioPlayer = AudioPlayer();

    _audioPlayer.onDurationChanged.listen((d) => setState(() => duration = d));
    _audioPlayer.onPositionChanged.listen((p) => setState(() => position = p));
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
          _isFlying?.value = isPlaying;
        });
      }
    });

    _playHybrid();
  }

  Future<void> _playHybrid() async {
    final song = widget.playlist[currentIndex];
    setState(() => isLoading = true);

    try {
      await _audioPlayer.stop();
      var search = await _yt.search.search(
        "${song.artist} ${song.title} audio",
      );
      if (search.isNotEmpty) {
        var manifest = await _yt.videos.streamsClient.getManifest(
          search.first.id,
        );
        var url = manifest.audioOnly.withHighestBitrate().url;
        await _audioPlayer.play(UrlSource(url.toString()));
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : RiveAnimation.asset(
                      'assets/rive/dash_music.riv',
                      onInit: (artboard) {
                        // Mencari controller dengan State Machine di Rive 0.14.0
                        final controller =
                            rive.StateMachineController.fromArtboard(
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
            const SizedBox(height: 20),
            Text(
              widget.playlist[currentIndex].title,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            IconButton(
              iconSize: 64,
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: () =>
                  isPlaying ? _audioPlayer.pause() : _audioPlayer.resume(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _yt.close();
    _riveController?.dispose();
    super.dispose();
  }
}
