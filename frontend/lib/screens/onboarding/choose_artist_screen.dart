import 'package:flutter/material.dart';
import '../../utils/transitions.dart';
import 'choose_podcast_screen.dart';

class ChooseArtistScreen extends StatefulWidget {
  final DateTime dob;
  final String gender;
  final String name;

  const ChooseArtistScreen({
    super.key,
    required this.dob,
    required this.gender,
    required this.name,
  });

  @override
  State<ChooseArtistScreen> createState() => _ChooseArtistScreenState();
}

class _ChooseArtistScreenState extends State<ChooseArtistScreen> {
  final List<String> selectedArtists = [];
  // ... list artists sama seperti sebelumnya ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottom: onboardingStepProgress(0.8),
        title: const Text("Pilih 3 Artis"),
      ),
      body: Column(
        children: [
          // ... GridView Artis ...
          const Spacer(),
          ElevatedButton(
            onPressed: selectedArtists.length < 3
                ? null
                : () {
                    Navigator.of(context).push(
                      createRoute(
                        ChoosePodcastScreen(
                          dob: widget.dob,
                          gender: widget.gender,
                          name: widget.name,
                          artists: selectedArtists,
                        ),
                      ),
                    );
                  },
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }
}
