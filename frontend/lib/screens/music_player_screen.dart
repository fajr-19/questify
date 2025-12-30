import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:frontend/screens/models/music_item.dart';

class LyricLine {
  final Duration timestamp;
  final String text;
  LyricLine(this.timestamp, this.text);
}

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
  late int currentIndex;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  // Controller untuk lirik otomatis
  final ScrollController _lyricsScrollController = ScrollController();
  List<LyricLine> _lyrics = [];
  int _currentLyricIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _audioPlayer = AudioPlayer();

    // Listener Posisi Musik (Ini yang membuat lirik otomatis jalan)
    _audioPlayer.onPositionChanged.listen((p) {
      if (mounted) {
        setState(() {
          position = p;
        });
        _syncLyrics(p); // Memanggil fungsi sinkronisasi
      }
    });

    _audioPlayer.onDurationChanged.listen((d) {
      if (mounted) setState(() => duration = d);
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => isPlaying = state == PlayerState.playing);
    });

    _initPlayer();
  }

  void _initPlayer() async {
    final song = widget.playlist[currentIndex];

    // Parsing data lirik dari MongoDB
    if (song.lyrics != null) {
      _lyrics = song.lyrics!
          .map(
            (item) => LyricLine(
              Duration(seconds: (item['time'] ?? 0).toInt()),
              item['text'] ?? "",
            ),
          )
          .toList();
    }

    await _audioPlayer.play(UrlSource(song.audioUrl!));
  }

  // LOGIKA UTAMA: Sinkronisasi Lirik Otomatis
  void _syncLyrics(Duration currentPos) {
    for (int i = 0; i < _lyrics.length; i++) {
      // Jika detik lagu sudah melewati atau sama dengan detik di data lirik
      if (currentPos >= _lyrics[i].timestamp) {
        if (_currentLyricIndex != i) {
          setState(() {
            _currentLyricIndex = i;
          });
          _animateLyricsScroll(i); // Scroll otomatis lirik ke tengah
        }
      }
    }
  }

  void _animateLyricsScroll(int index) {
    if (_lyricsScrollController.hasClients) {
      // Menghitung posisi agar lirik aktif selalu di tengah kotak
      double offset = (index * 60.0) - 80.0;
      _lyricsScrollController.animateTo(
        offset < 0 ? 0 : offset,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _lyricsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final song = widget.playlist[currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Bagian Atas: Animasi Rive
          Expanded(
            flex: 3,
            child: RiveAnimation.asset(
              'assets/rive/dash_music.riv',
              fit: BoxFit.contain,
            ),
          ),

          // Bagian Tengah: Judul & Slider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  song.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  song.artist,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Slider(
                  value: position.inSeconds.toDouble(),
                  max: duration.inSeconds.toDouble() > 0
                      ? duration.inSeconds.toDouble()
                      : 1.0,
                  onChanged: (v) =>
                      _audioPlayer.seek(Duration(seconds: v.toInt())),
                ),
              ],
            ),
          ),

          // Bagian Bawah: LIST LIRIK OTOMATIS
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
                controller: _lyricsScrollController,
                itemCount: _lyrics.length,
                padding: EdgeInsets.symmetric(
                  vertical: 100,
                ), // Agar lirik bisa scroll ke tengah
                itemBuilder: (context, index) {
                  bool isCurrent = index == _currentLyricIndex;
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    child: Text(
                      _lyrics[index].text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isCurrent ? Colors.white : Colors.white24,
                        fontSize: isCurrent ? 22 : 18,
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Tombol Kontrol
          _buildControls(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.skip_previous, color: Colors.white, size: 40),
          onPressed: () {},
        ),
        SizedBox(width: 20),
        GestureDetector(
          onTap: () => isPlaying ? _audioPlayer.pause() : _audioPlayer.resume(),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30,
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.black,
              size: 40,
            ),
          ),
        ),
        SizedBox(width: 20),
        IconButton(
          icon: Icon(Icons.skip_next, color: Colors.white, size: 40),
          onPressed: () {},
        ),
      ],
    );
  }
}
