import 'package:flutter/material.dart';
import 'start_screen.dart';

class ChoosePodcastScreen extends StatefulWidget {
  const ChoosePodcastScreen({super.key});

  @override
  State<ChoosePodcastScreen> createState() => _ChoosePodcastScreenState();
}

class _ChoosePodcastScreenState extends State<ChoosePodcastScreen> {
  final podcasts = ['Tech', 'Business', 'Health', 'Design'];
  final selected = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose podcasts')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: podcasts.map((p) {
                final isSelected = selected.contains(p);
                return ListTile(
                  title: Text(p),
                  trailing:
                      isSelected ? const Icon(Icons.check) : const SizedBox(),
                  onTap: () {
                    setState(() {
                      isSelected ? selected.remove(p) : selected.add(p);
                    });
                  },
                );
              }).toList(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StartScreen(),
                  ),
                );
              },
              child: const Text('Done'),
            ),
          )
        ],
      ),
    );
  }
}
