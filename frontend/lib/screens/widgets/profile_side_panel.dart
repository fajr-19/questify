import 'package:flutter/material.dart';
import '../../api_service.dart';
import '../profile_screen.dart';

class ProfileSidePanel extends StatelessWidget {
  final String displayName;
  final String photoUrl;
  final int xp; // Tambahkan ini
  final int level; // Tambahkan ini

  const ProfileSidePanel({
    super.key,
    required this.displayName,
    required this.photoUrl,
    required this.xp, // Tambahkan ini
    required this.level, // Tambahkan ini
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              ListTile(
                leading: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white10,
                  backgroundImage: NetworkImage(photoUrl),
                ),
                title: Text(
                  displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                // Menampilkan Level dan XP di bawah nama
                subtitle: Text(
                  "Level $level • $xp XP",
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(color: Colors.white12, indent: 20, endIndent: 20),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  children: [
                    _item(
                      Icons.person_outline,
                      "Akun Saya",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              name: displayName,
                              photo: photoUrl,
                            ),
                          ),
                        );
                      },
                    ),
                    _item(Icons.directions_run, "Quest Baru"),
                    _item(Icons.notifications_none_outlined, "Pengumuman"),
                    _item(Icons.settings_outlined, "Pengaturan"),
                    const Divider(
                      color: Colors.white12,
                      indent: 20,
                      endIndent: 20,
                    ),
                    _item(
                      Icons.logout_rounded,
                      "Keluar",
                      textColor: Colors.redAccent,
                      onTap: () async {
                        await ApiService.logout();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/',
                            (route) => false,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(
    IconData icon,
    String text, {
    VoidCallback? onTap,
    Color textColor = Colors.white,
  }) {
    return ListTile(
      // Menggunakan .withValues untuk menghindari warning deprecated
      leading: Icon(icon, color: textColor.withValues(alpha: 0.8), size: 22),
      title: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      onTap: onTap ?? () {},
    );
  }
}
