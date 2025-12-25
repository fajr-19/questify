import 'package:flutter/material.dart';
import 'widgets/greeting_section.dart';
import 'widgets/filter_chips.dart';
import 'widgets/hero_recommendation.dart';
import 'widgets/horizontal_section.dart';
import 'widgets/profile_side_panel.dart';
import 'models/music_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int navIndex = 0;

  final List<MusicItem> dummyMusic = List.generate(
  6,
  (i) => MusicItem(
    title: 'Track $i',
    imageUrl: 'https://picsum.photos/200?random=$i',
  ),
);

  void _openProfilePanel() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Profile",
      barrierColor: Colors.black.withValues(alpha: 0.3),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return const Align(
          alignment: Alignment.centerRight,
          child: SizedBox(width: 280, child: ProfileSidePanel()),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navIndex,
        onTap: (i) => setState(() => navIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            GreetingSection(onProfileTap: _openProfilePanel),

            FilterChipsWidget(
              onChanged: (value) {
                // nanti buat filter genre / mood
              },
            ),

            const HeroRecommendation(),

            HorizontalSection(
              title: "Recommended for you",
              items: dummyMusic,
            ),

            HorizontalSection(
              title: "Popular Artists",
              items: dummyMusic,
            ),
          ],
        ),
      ),
    );
  }
}
