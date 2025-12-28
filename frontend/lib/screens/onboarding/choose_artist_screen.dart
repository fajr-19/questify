import 'package:flutter/material.dart';
import '../../utils/transitions.dart';
import 'choose_podcast_screen.dart';
import '../../utils/colors.dart';

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
  final List<String> selected = [];

  final artists = [
    {
      "n": "Tulus",
      "i":
          "https://www.wowkeren.com/display/images/photo/2022/03/04/00415147.jpg",
    },
    {
      "n": "Hindia",
      "i":
          "https://asset.kompas.com/crops/O_S5r1G7Q7uI5f0Y_8_yTzS8-6k=/0x0:1000x667/750x500/data/photo/2023/06/16/648be48e89f8d.jpg",
    },
    {
      "n": "Nadin Amizah",
      "i": "https://i.scdn.co/image/ab6761610000e5ebf8c7b8c734005c28905e94b2",
    },
    {
      "n": "Juicy Luicy",
      "i": "https://api.duniamesin.com/uploads/juicy_luicy_662f913d31.jpg",
    },
    {
      "n": "Pamungkas",
      "i":
          "https://asset.kompas.com/crops/v9N-j6k3A6A0v-l_f3P_mO9G2o0=/0x0:0x0/750x500/data/photo/2022/06/15/62a9c3792070e.jpg",
    },
    {
      "n": ".Feast",
      "i": "https://images.bisnis.com/posts/2022/05/20/1535123/feast.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QColors.background,
      appBar: AppBar(
        backgroundColor: QColors.background,
        elevation: 0,
        bottom: onboardingStepProgress(0.8),
        title: const Text(
          "Pilih 3 Artis",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: artists.length,
              itemBuilder: (ctx, i) {
                final isSel = selected.contains(artists[i]['n']);
                return GestureDetector(
                  onTap: () => setState(
                    () => isSel
                        ? selected.remove(artists[i]['n'])
                        : selected.add(artists[i]['n']!),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: isSel
                            ? QColors.primaryPurple
                            : Colors.transparent,
                        child: CircleAvatar(
                          radius: 44,
                          backgroundColor: QColors.surface,
                          backgroundImage: NetworkImage(artists[i]['i']!),
                          onBackgroundImageError: (_, __) =>
                              debugPrint("Error image"),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        artists[i]['n']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
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
            child: buildNextBtn(
              active: selected.length >= 3,
              onTap: () => Navigator.of(context).push(
                createRoute(
                  ChoosePodcastScreen(
                    dob: widget.dob,
                    gender: widget.gender,
                    name: widget.name,
                    artists: selected,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
