import 'package:flutter/material.dart';
import '../../api_service.dart';
import '../../utils/transitions.dart';
import '../home_screen.dart';

class ChoosePodcastScreen extends StatefulWidget {
  final DateTime dob;
  final String gender;
  final String name;
  final List<String> artists;

  const ChoosePodcastScreen({
    super.key,
    required this.dob,
    required this.gender,
    required this.name,
    required this.artists,
  });

  @override
  State<ChoosePodcastScreen> createState() => _ChoosePodcastScreenState();
}

class _ChoosePodcastScreenState extends State<ChoosePodcastScreen> {
  final List<String> podcasts = [
    "Podkesmas",
    "Agak Laen",
    "Deddy Corbuzier",
    "The Onsu",
  ];
  final List<String> selectedPodcasts = [];
  bool isLoading = false;

  Future<void> _finishOnboarding() async {
    setState(() => isLoading = true);

    // Data lengkap untuk dikirim ke backend
    final data = {
      "full_name": widget.name,
      "date_of_birth": widget.dob.toIso8601String(),
      "gender": widget.gender,
      "favorite_artists": widget.artists,
      "favorite_podcasts": selectedPodcasts,
    };

    final success = await ApiService.updateOnboardingData(data);

    if (mounted) {
      setState(() => isLoading = false);
      if (success != null) {
        Navigator.of(
          context,
        ).pushAndRemoveUntil(createRoute(const HomeScreen()), (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menyimpan data, coba lagi.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: onboardingStepProgress(1.0), // Progress 100%
        title: const Text("Pilih Podcast", style: TextStyle(fontSize: 16)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: podcasts.length,
              itemBuilder: (context, index) {
                final p = podcasts[index];
                final isSelected = selectedPodcasts.contains(p);
                return CheckboxListTile(
                  title: Text(p, style: const TextStyle(color: Colors.white)),
                  value: isSelected,
                  activeColor: Colors.green,
                  onChanged: (val) {
                    setState(() {
                      val!
                          ? selectedPodcasts.add(p)
                          : selectedPodcasts.remove(p);
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: ElevatedButton(
              onPressed: isLoading ? null : _finishOnboarding,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(200, 50),
                shape: const StadiumBorder(),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Mulai Mendengarkan",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
