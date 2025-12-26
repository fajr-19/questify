import 'package:flutter/material.dart';
import '../../api_service.dart';
import 'start_screen.dart';

class ChoosePodcastScreen extends StatefulWidget {
  const ChoosePodcastScreen({super.key});

  @override
  State<ChoosePodcastScreen> createState() => _ChoosePodcastScreenState();
}

class _ChoosePodcastScreenState extends State<ChoosePodcastScreen> {
  final podcasts = [
    'Tech',
    'Business',
    'Health',
    'Design',
    'Education',
    'Comedy',
    'Music News',
    'Self Improvement',
  ];
  final selected = <String>[];
  bool isSaving = false;

  // Fungsi untuk menyimpan preferensi podcast
  Future<void> _handleDone() async {
    setState(() => isSaving = true);

    // Kirim data podcast ke backend (bisa kosong jika user tidak pilih)
    await ApiService.updateOnboardingData({'favorite_podcasts': selected});

    if (!mounted) return;
    setState(() => isSaving = false);

    // Pindah ke halaman Start/Success
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const StartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose podcasts'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Dapatkan rekomendasi podcast berdasarkan minatmu (opsional).",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: podcasts.length,
              itemBuilder: (context, index) {
                final p = podcasts[index];
                final isSelected = selected.contains(p);
                return ListTile(
                  title: Text(
                    p,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? Colors.deepPurple : Colors.black,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.deepPurple)
                      : const Icon(Icons.add_circle_outline),
                  onTap: () {
                    setState(() {
                      isSelected ? selected.remove(p) : selected.add(p);
                    });
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : _handleDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.black, // Berbeda warna agar terlihat kontras
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Done', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
