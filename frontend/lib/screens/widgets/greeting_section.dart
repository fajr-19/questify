import 'package:flutter/material.dart';

class GreetingSection extends StatelessWidget {
  final VoidCallback onProfileTap;

  const GreetingSection({super.key, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good Evening",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text("Fajar 👋", style: TextStyle(color: Colors.grey)),
            ],
          ),

          GestureDetector(
            onTap: onProfileTap,
            child: const CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
            ),
          ),
        ],
      ),
    );
  }
}
