import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:frontend/screens/models/music_item.dart';
import 'music_player_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final YoutubeExplode _yt = YoutubeExplode();
  List<MusicItem> _results = [];
  bool _isSearching = false;

  // Fungsi untuk mencari lagu asli dari YouTube
  Future<void> _searchMusic(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    try {
      // Mencari video berdasarkan query
      var searchList = await _yt.search.search(query);

      setState(() {
        _results = searchList.map((video) {
          return MusicItem(
            id: video.id.value,
            title: video.title,
            artist: video.author,
            coverUrl: video
                .thumbnails
                .mediumResUrl, // Mengambil thumbnail asli YouTube
            description: video.description,
          );
        }).toList();
      });
    } catch (e) {
      debugPrint("Error searching: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal mencari lagu, periksa koneksi internet."),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _yt.close(); // Penting untuk menutup client agar tidak memory leak
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: TextField(
          controller: _controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Cari lagu atau artis...",
            hintStyle: const TextStyle(color: Colors.white54),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: Colors.white54),
              onPressed: () => _controller.clear(),
            ),
          ),
          onSubmitted: _searchMusic,
        ),
      ),
      body: _isSearching
          ? const Center(
              child: CircularProgressIndicator(color: Colors.purpleAccent),
            )
          : _results.isEmpty
          ? const Center(
              child: Text(
                "Cari lagu favoritmu di YouTube",
                style: TextStyle(color: Colors.white54),
              ),
            )
          : ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final item = _results[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.coverUrl ?? "",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.music_note, color: Colors.purple),
                    ),
                  ),
                  title: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    item.artist,
                    style: const TextStyle(color: Colors.white54),
                  ),
                  onTap: () {
                    // Kirim hasil pencarian sebagai playlist agar bisa skip ke lagu berikutnya
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MusicPlayerScreen(
                          playlist: _results,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
