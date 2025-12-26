import 'package:flutter/material.dart';

class LevelUpScreen extends StatelessWidget {
  const LevelUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header XP & Diamond
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statChip(Icons.bolt, "1250 XP", Colors.orange),
                  // PERBAIKAN: Icons.diamond menggantikan Icons.gem
                  _statChip(Icons.diamond, "45 Diamonds", Colors.blue),
                ],
              ),
            ),

            const Text(
              "Leaderboard",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    "Daily Quest",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _questTile("Watch 3 Podcast", 0.6, "2/3"),
                  _questTile("Listen 3 Music", 1.0, "3/3", isDone: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _questTile(
    String title,
    double progress,
    String trailing, {
    bool isDone = false,
  }) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          // Custom warna agar sesuai tema
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
        ),
        trailing: isDone
            ? const Icon(Icons.check_circle, color: Colors.green)
            : Text(trailing),
      ),
    );
  }

  Widget _statChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        // PERBAIKAN: withValues menggantikan withOpacity
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
