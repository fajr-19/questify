import 'package:flutter/material.dart';
import 'upload_screen.dart';

class CreateMenuScreen extends StatelessWidget {
  const CreateMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                // SUDAH DIPERBAIKI: Path sesuai standar Flutter
                image: const AssetImage('assets/images/gitar_bg.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          // 2. MENU MELAYANG
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                // Warna Ungu Sesuai UI Questify
                color: const Color(0xFFBB86FC).withOpacity(0.9),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.upload_file,
                    text: "Upload",
                    textColor: Colors.red.shade900,
                    iconColor: Colors.red.shade900,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UploadScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(color: Colors.black26),
                  _buildMenuItem(
                    context,
                    icon: Icons.music_note,
                    text: "Playlist",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.group_add,
                    text: "Collaborative Playlist",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.donut_large,
                    text: "Blend",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color textColor = Colors.black87,
    Color iconColor = Colors.black87,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 15),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
