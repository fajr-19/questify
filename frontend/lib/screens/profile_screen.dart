import 'package:flutter/material.dart';
import '../api_service.dart';
import 'landing_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String name;
  final String photo;

  const ProfileScreen({super.key, required this.name, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          ListTile(
            leading: CircleAvatar(
              radius: 26,
              backgroundImage: NetworkImage(photo),
            ),
            title: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: const Text(
              'Free Account',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const Divider(color: Colors.white12),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text(
              'Settings',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await ApiService.logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LandingScreen()),
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
