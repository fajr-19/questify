import 'package:flutter/material.dart';
import 'widgets/greeting_section.dart';
import 'widgets/filter_chips.dart';
import 'widgets/hero_recommendation.dart';
import 'widgets/horizontal_section.dart';
import 'models/music_item.dart';
import '../api_service.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String filter = 'all';
  late Future<List<MusicItem>> future;

  @override
  void initState() {
    super.initState();
    future = ApiService.fetchHome(filter);
  }

  void onFilter(String f) {
    setState(() {
      filter = f;
      future = ApiService.fetchHome(filter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (i) {
          if (i == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          }
        },
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const GreetingSection(),
            FilterChipsWidget(onChanged: onFilter),

            FutureBuilder(
              future: future,
              builder: (_, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return HorizontalSection(
                  title: 'Recommended',
                  items: snap.data!,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
