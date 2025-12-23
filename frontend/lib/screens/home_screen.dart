import 'package:flutter/material.dart';
import 'widgets/greeting_section.dart';
import 'widgets/filter_chips.dart';
import 'widgets/hero_banner.dart';
import 'widgets/horizontal_list.dart';
import 'models/dummy_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            GreetingSection(),
            FilterChipsWidget(),
            HeroBanner(),

            HorizontalList(
              title: "Recommended for you",
              items: DummyData.recommended,
            ),

            HorizontalList(
              title: "Popular Artists",
              items: DummyData.popular,
            ),

            HorizontalList(
              title: "Trending Podcasts",
              items: DummyData.podcasts,
            ),
          ],
        ),
      ),
    );
  }
}
