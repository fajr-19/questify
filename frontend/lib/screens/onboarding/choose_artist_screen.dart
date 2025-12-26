import 'package:flutter/material.dart';
import '../../api_service.dart';
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
    'Ed Sheeran',
    'NIKI',
    'Tulus',
  ];
  final selected = <String>[];
  bool isSaving = false;

  Future<void> _handleNext() async {
    setState(() => isSaving = true);
    // KIRIM KE BACKEND: Agar ML punya data awal lagu apa yang harus disarankan
    await ApiService.updateOnboardingData({'favorite_artists': selected});

    if (!mounted) return;
    setState(() => isSaving = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ChoosePodcastScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Minimal 3 Artis')),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: artists.length,
              itemBuilder: (context, i) {
                final a = artists[i];
                final isSel = selected.contains(a);
                return FilterChip(
                  label: Text(a),
                  selected: isSel,
                  onSelected: (v) =>
                      setState(() => v ? selected.add(a) : selected.remove(a)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: (selected.length >= 3 && !isSaving)
                  ? _handleNext
                  : null,
              child: Text(isSaving ? 'Menyimpan...' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }
}
