import 'package:flutter/material.dart';
import '../api_service.dart';
import 'landing_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: ListView(
        children: [
          const SizedBox(height: 24),

          // USER HEADER
          const ListTile(
            leading: CircleAvatar(
              radius: 26,
              child: Icon(Icons.person, size: 28),
            ),
            title: Text('Fajar', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Free Account'),
          ),

          const Divider(),

          // SETTINGS
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
          ),

          // ADD ACCOUNT
          ListTile(
            leading: const Icon(Icons.switch_account),
            title: const Text('Add another account'),
            onTap: () {},
          ),

          // LOGOUT
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
