import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'models/music_item.dart';
import '../utils/colors.dart';

class MusicPlayerScreen extends StatefulWidget {
  final MusicItem item; // Di HomeScreen dipanggil pakai 'item: item'
  const MusicPlayerScreen({super.key, required this.item});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  Artboard? _riveArtboard;
  RiveAnimationController? _controller;

  bool isPlaying = false;
  String currentAnimation = 'Idle';

  final List<String> animationStyles = ['Idle', 'Flying'];

  void _onRiveInit(Artboard artboard) {
    _riveArtboard = artboard;
    _controller = SimpleAnimation(currentAnimation);
    _riveArtboard!.addController(_controller!);
  }

  void _changeDashAnimation(String animationName) {
    if (_riveArtboard == null || _controller == null) return;

    _riveArtboard!.removeController(_controller!);
    _controller = SimpleAnimation(animationName);
    _riveArtboard!.addController(_controller!);

    setState(() {
      currentAnimation = animationName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QColors.background,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.expand_more,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  "DASH PLAYER",
                  style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                const Icon(Icons.favorite_border, color: Colors.white),
              ],
            ),
          ),

          Expanded(
            flex: 3,
            child: RiveAnimation.asset(
              'assets/rive/dash_music.riv',
              onInit: _onRiveInit,
              fit: BoxFit.contain,
              placeHolder: const Center(child: CircularProgressIndicator()),
            ),
          ),

          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.black.withValues(
                  alpha: 0.4,
                ), // Perbaikan deprecated
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    widget.item.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.item.artist,
                    style: const TextStyle(fontSize: 16, color: Colors.white54),
                  ),
                  const SizedBox(height: 30),

                  _buildAnimationStyleChips(),
                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.skip_previous,
                        size: 45,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 30),
                      FloatingActionButton(
                        backgroundColor: QColors.primaryPurple,
                        onPressed: () {
                          setState(() {
                            isPlaying = !isPlaying;
                            if (isPlaying) {
                              _changeDashAnimation('Flying');
                            } else {
                              _changeDashAnimation('Idle');
                            }
                          });
                        },
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 30),
                      const Icon(
                        Icons.skip_next,
                        size: 45,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimationStyleChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: animationStyles.map((styleName) {
          bool isSelected = currentAnimation == styleName;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ChoiceChip(
              label: Text(styleName),
              selected: isSelected,
              selectedColor: QColors.primaryPurple,
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: Colors.white.withValues(
                alpha: 0.1,
              ), // Perbaikan deprecated
              onSelected: (selected) {
                if (selected) {
                  _changeDashAnimation(styleName);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
