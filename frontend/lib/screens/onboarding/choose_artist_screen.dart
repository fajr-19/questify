import 'package:flutter/material.dart';
import 'choose_podcast_screen.dart';

class ChooseArtistScreen extends StatefulWidget {
  const ChooseArtistScreen({super.key});

  @override
  State<ChooseArtistScreen> createState() => _ChooseArtistScreenState();
}

class _ChooseArtistScreenState extends State<ChooseArtistScreen> {
  final artists = [
    'Taylor Swift',
    'Coldplay',
    'Adele',
    'Drake',
    'Billie Eilish',
    'Ed Sheeran'
  ];

  final selected = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose at least 3 artists')),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              children: artists.map((a) {
                final isSelected = selected.contains(a);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected ? selected.remove(a) : selected.add(a);
                    });
                  },
                  child: Card(
                    color: isSelected
                        ? Colors.deepPurple.shade100
                        : Colors.white,
                    child: Center(child: Text(a)),
                  ),
                );
              }).toList(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: selected.length >= 3
                  ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChoosePodcastScreen(),
                        ),
                      );
                    }
                  : null,
              child: const Text('Next'),
            ),
          )
        ],
      ),
    );
  }
}
