import 'package:flutter/material.dart';
import '../widgets/greeting_section.dart';
import '../widgets/filter_chips.dart';
import '../widgets/hero_recommendation.dart';
import '../widgets/horizontal_section.dart';
import '../models/dummy_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const CircleAvatar(radius: 18, backgroundImage: AssetImage('assets/avatar.png')),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
                  ],
                ),
              ),

              const GreetingSection(),
              const FilterChipsWidget(),
              const HeroRecommendation(),

              HorizontalSection(
                title: "Based on your choice",
                items: DummyData.recommended,
              ),

              HorizontalSection(
                title: "Popular today",
                items: DummyData.popular,
              ),

              HorizontalSection(
                title: "Trending podcasts",
                items: DummyData.podcasts,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
