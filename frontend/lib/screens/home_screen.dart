import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api_service.dart';
import '../utils/colors.dart';
import 'models/music_item.dart';
import 'widgets/filter_chips.dart';
import 'widgets/hero_recommendation.dart';
import 'widgets/horizontal_section.dart';
import 'widgets/profile_side_panel.dart';
import 'music_player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int navIndex = 0;
  bool loading = true;
  Map<String, dynamic> userProfile = {};
  List<MusicItem> mlRecommendations = [];
  List<MusicItem> popularArtists = [];

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _loadHomeData();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 2.0, end: 12.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _loadHomeData() async {
    if (!mounted) return;
    setState(() => loading = true);
    try {
      final results = await Future.wait([
        ApiService.fetchProfile(),
        ApiService.fetchMLRecommendations(),
        ApiService.fetchPopularArtists(),
      ]);

      if (mounted) {
        setState(() {
          userProfile = results[0] as Map<String, dynamic>;
          mlRecommendations = results[1] as List<MusicItem>;
          popularArtists = results[2] as List<MusicItem>;
          loading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading home data: $e");
      if (mounted) setState(() => loading = false);
    }
  }

  void _openProfilePanel(String name, String photo) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Profile",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim, ___) => Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: ProfileSidePanel(
            displayName: name,
            photoUrl: photo,
            xp: userProfile['xp'] ?? 0,
            level: userProfile['level'] ?? 1,
          ),
        ),
      ),
      transitionBuilder: (context, anim, __, child) => SlideTransition(
        position: Tween(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
        child: child,
      ),
    );
  }

  void _playMusic(MusicItem item) {
    // 1. Tambah XP (Gamifikasi)
    ApiService.addXP(10);

    // 2. Navigasi ke Player
    // PERBAIKAN: Parameter diganti menjadi 'item' sesuai konstruktor MusicPlayerScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MusicPlayerScreen(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String displayName =
        userProfile['name'] ?? user?.displayName ?? "User";
    final String photoUrl =
        userProfile['avatar'] ??
        user?.photoURL ??
        "https://ui-avatars.com/api/?name=$displayName&background=BB86FC&color=fff";

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: QColors.background,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navIndex,
        onTap: (i) => setState(() => navIndex = i),
        selectedItemColor: QColors.primaryPurple,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.workspace_premium),
            label: 'Premium',
          ),
        ],
      ),
      body: SafeArea(
        child: loading
            ? const Center(
                child: CircularProgressIndicator(color: QColors.primaryPurple),
              )
            : RefreshIndicator(
                onRefresh: _loadHomeData,
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Selamat Pagi,",
                                    style: TextStyle(
                                      color: QColors.textSub,
                                      fontSize: 16,
                                    ),
                                  ),
                                  AnimatedBuilder(
                                    animation: _glowAnimation,
                                    builder: (context, child) {
                                      return ShaderMask(
                                        shaderCallback: (bounds) =>
                                            const LinearGradient(
                                              colors: [
                                                Colors.white,
                                                QColors.primaryPurple,
                                              ],
                                            ).createShader(bounds),
                                        child: Text(
                                          displayName,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenWidth * 0.08,
                                            fontWeight: FontWeight.w900,
                                            shadows: [
                                              Shadow(
                                                blurRadius:
                                                    _glowAnimation.value,
                                                color: QColors.primaryPurple
                                                    .withValues(
                                                      alpha: 0.8,
                                                    ), // Perbaikan: withValues
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () =>
                                    _openProfilePanel(displayName, photoUrl),
                                child: Container(
                                  padding: const EdgeInsets.all(2.5),
                                  decoration: const BoxDecoration(
                                    color: QColors.primaryPurple,
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    radius: 28,
                                    backgroundImage: NetworkImage(photoUrl),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildMissionBanner(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: FilterChipsWidget(
                        onChanged: (val) {
                          // Filter logic
                        },
                      ),
                    ),

                    const SizedBox(height: 25),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: HeroRecommendation(),
                    ),
                    const SizedBox(height: 35),

                    _buildSectionHeader("Hanya Untukmu"),
                    const SizedBox(height: 12),
                    if (mlRecommendations.isNotEmpty)
                      HorizontalSection(
                        title: "",
                        items: mlRecommendations,
                        onTap: (item) => _playMusic(item),
                      ),

                    const SizedBox(height: 20),

                    if (popularArtists.isNotEmpty)
                      HorizontalSection(
                        title: "Artis Populer",
                        items: popularArtists,
                        onTap: (item) {
                          // Detail artis logic
                        },
                      ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          color: QColors.primaryPurple,
          fontSize: 22,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildMissionBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: QColors.primaryPurple,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: QColors.primaryPurple.withValues(
              alpha: 0.4,
            ), // Perbaikan: withValues
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              image: const DecorationImage(
                image: AssetImage('assets/images/mission_icon.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              "Listen Here To a Maximum of 3 Podcasts To Level Up",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
