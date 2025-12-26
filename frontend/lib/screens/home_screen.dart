import 'package:flutter/material.dart';
import '../api_service.dart';
import 'models/music_item.dart';
import 'widgets/greeting_section.dart';
import 'widgets/filter_chips.dart';
import 'widgets/hero_recommendation.dart';
import 'widgets/horizontal_section.dart';
import 'widgets/profile_side_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int navIndex = 0;
  bool loading = true;

  // List data untuk menampung hasil dari API
  List<MusicItem> mlRecommendations = [];
  List<MusicItem> popularArtists = [];

  @override
  void initState() {
    super.initState();
    _loadHome(); // Panggil data saat pertama kali aplikasi dibuka
  }

  // Fungsi utama untuk mengambil semua data dari backend
  Future<void> _loadHome() async {
    setState(() => loading = true);
    try {
      // Mengambil data ML dan Artis Populer secara bersamaan (Parallel)
      final results = await Future.wait([
        ApiService.fetchMLRecommendations(), // Pastikan fungsi ini ada di api_service.dart
        ApiService.fetchPopularArtists(),
      ]);

      setState(() {
        mlRecommendations = results[0];
        popularArtists = results[1];
        loading = false;
      });
    } catch (e) {
      print("Error load home: $e");
      setState(() => loading = false);
    }
  }

  // Fungsi ini akan dipicu ketika salah satu kotak musik/artis diklik
  void _playMusic(MusicItem item) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.play_circle_fill, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Memutar: ${item.title} - ${item.artist}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF5D5755),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Fungsi untuk membuka sidebar profil dari kanan
  void _openProfilePanel() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Profile",
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim, ___) => Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75, // 75% lebar layar
          height: MediaQuery.of(context).size.height,
          child: const ProfileSidePanel(),
        ),
      ),
      transitionBuilder: (context, anim, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna dasar sesuai desain mockup
      backgroundColor: const Color(0xFFF9F1F1),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navIndex,
        onTap: (i) => setState(() => navIndex = i),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.reorder), label: 'Library'),
          BottomNavigationBarItem(
            icon: Icon(Icons.headphones_outlined),
            label: 'Premium',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Create',
          ),
        ],
      ),

      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadHome,
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  children: [
                    // Bagian Header (Foto Profil & Greeting)
                    GreetingSection(onProfileTap: _openProfilePanel),

                    const SizedBox(height: 10),

                    // Barisan Filter (All, Music, Podcast, dll)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: FilterChipsWidget(
                        onChanged: (selectedFilter) {
                          print("Filter dipilih: $selectedFilter");
                        },
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Banner Utama (Hero)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: HeroRecommendation(),
                    ),

                    // SECTION 1: Top Picks / Artis Populer
                    if (popularArtists.isNotEmpty)
                      HorizontalSection(
                        title: "Top Picks",
                        items: popularArtists,
                        onTap: _playMusic, // Kirim fungsi play
                      ),

                    // SECTION 2: Rekomendasi Machine Learning
                    if (mlRecommendations.isNotEmpty)
                      HorizontalSection(
                        title: "Recommended for you (ML)",
                        items: mlRecommendations,
                        onTap: _playMusic, // Kirim fungsi play
                      ),

                    // Tambahan spasi di bawah agar tidak terpotong navbar
                    const SizedBox(height: 40),
                  ],
                ),
              ),
      ),
    );
  }
}
