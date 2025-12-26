import 'package:flutter/material.dart';
import '../../api_service.dart';

class ProfileSidePanel extends StatelessWidget {
  const ProfileSidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF5D5755),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<Map<String, dynamic>>(
            future: ApiService.fetchProfile(),
            builder: (context, snapshot) {
              final profile = snapshot.data;
              final String name = profile?['name'] ?? 'User';

              return Column(
                children: [
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white30,
                      child: Text(
                        "S",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: const Text(
                      "View profile",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const Divider(
                    color: Colors.white24,
                    indent: 15,
                    endIndent: 15,
                    thickness: 1,
                  ),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      children: [
                        _item(
                          Icons.add,
                          "Add Account",
                          onTap: () => print("Add Account clicked"),
                        ),
                        _item(
                          Icons.directions_run,
                          "New Quest",
                          onTap: () => print("New Quest clicked"),
                        ),
                        _item(
                          Icons.announcement_outlined,
                          "Announcement",
                          onTap: () => print("Announcement clicked"),
                        ),
                        _item(
                          Icons.settings_outlined,
                          "Settings",
                          onTap: () => print("Settings clicked"),
                        ),
                        _item(
                          Icons.logout_rounded,
                          "Log Out",
                          onTap: () async {
                            await ApiService.logout();
                            if (context.mounted) {
                              Navigator.popUntil(context, (r) => r.isFirst);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _item(IconData icon, String text, {VoidCallback? onTap}) {
    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.white24,
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
