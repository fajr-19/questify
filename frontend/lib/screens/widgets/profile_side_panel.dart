import 'package:flutter/material.dart';
import '../../api_service.dart';

class ProfileSidePanel extends StatelessWidget {
  const ProfileSidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // HEADER
            ListTile(
              leading: const CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=3',
                ),
              ),
              title: const Text(
                "Fajar",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("View profile"),
              onTap: () {
                // TODO: navigate to profile detail
              },
            ),

            const Divider(),

            _item(Icons.settings, "Settings"),
            _item(Icons.person_add, "Add Account"),
            _item(
              Icons.logout,
              "Logout",
              onTap: () async {
                await ApiService.logout();
                Navigator.popUntil(context, (r) => r.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, String text, {VoidCallback? onTap}) {
    return ListTile(leading: Icon(icon), title: Text(text), onTap: onTap);
  }
}
