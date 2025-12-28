import 'package:flutter/material.dart';
import '../../utils/transitions.dart';
import '../../api_service.dart';
import '../../storage_service.dart';
import 'loading_transition_screen.dart';
import '../../utils/colors.dart';

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
  final List<Map<String, String>> podcasts = [
    {"n": "Podkesmas", "i": "https://placehold.co/200x200/png?text=Podkesmas"},
    {"n": "Agak Laen", "i": "https://placehold.co/200x200/png?text=Agak+Laen"},
    {"n": "Deddy C", "i": "https://placehold.co/200x200/png?text=Deddy"},
    {"n": "The Onsu", "i": "https://placehold.co/200x200/png?text=The+Onsu"},
  ];
  final List<String> selectedP = [];
  bool isLoading = false;

  void _finish() async {
    setState(() => isLoading = true);

    final response = await ApiService.updateOnboardingData({
      "full_name": widget.name,
      "date_of_birth": widget.dob.toIso8601String().split('T')[0], // YYYY-MM-DD
      "gender": widget.gender,
      "favorite_artists": widget.artists,
      "favorite_podcasts": selectedP,
    });

    if (mounted) {
      if (response == true) {
        // PENTING: Tandai onboarding selesai di lokal storage
        await StorageService.setOnboardingDone();

        setState(() => isLoading = false);

        Navigator.of(context).pushAndRemoveUntil(
          createRoute(const LoadingTransitionScreen()),
          (route) => false,
        );
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Gagal menyimpan data, silakan periksa koneksi Anda.",
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QColors.background,
      appBar: AppBar(
        backgroundColor: QColors.background,
        elevation: 0,
        bottom: onboardingStepProgress(1.0),
        title: const Text(
          "Pilih Podcast",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Pilih podcast yang kamu sukai",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
              ),
              itemCount: podcasts.length,
              itemBuilder: (ctx, i) {
                final name = podcasts[i]['n']!;
                final isSel = selectedP.contains(name);
                return GestureDetector(
                  onTap: () => setState(
                    () => isSel ? selectedP.remove(name) : selectedP.add(name),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 46,
                            backgroundColor: isSel
                                ? QColors.primaryPurple
                                : Colors.grey.shade900,
                            child: CircleAvatar(
                              radius: 42,
                              backgroundImage: NetworkImage(podcasts[i]['i']!),
                            ),
                          ),
                          if (isSel)
                            const Positioned(
                              right: 0,
                              bottom: 0,
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: QColors.primaryPurple,
                                child: Icon(
                                  Icons.check,
                                  color: Colors.black,
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSel ? QColors.primaryPurple : Colors.white,
                          fontSize: 12,
                          fontWeight: isSel
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 50),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: QColors.primaryPurple,
                    ),
                  )
                : buildNextBtn(
                    active: selectedP.isNotEmpty,
                    onTap: _finish,
                    text: "Mulai Mendengarkan",
                  ),
          ),
        ],
      ),
    );
  }
}
