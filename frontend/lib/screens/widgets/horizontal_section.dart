import 'package:flutter/material.dart';
import '../models/music_item.dart'; // Pastikan path import benar

class HorizontalSection extends StatelessWidget {
  final String title;
  final List<MusicItem> items;
  final Function(MusicItem) onTap;

  const HorizontalSection({
    super.key,
    required this.title,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors
                  .white, // Menggunakan putih agar cocok dengan tema gelap
            ),
          ),
        ),
        SizedBox(
          height: 220, // Tinggi ditambah agar tidak terpotong
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            physics:
                const BouncingScrollPhysics(), // Efek scroll yang lebih smooth
            itemBuilder: (context, i) {
              final item = items[i];
              return GestureDetector(
                onTap: () => onTap(item),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // COVER ALBUM
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item.coverUrl ??
                              'https://via.placeholder.com/150', // Perbaikan di sini
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 150,
                            width: 150,
                            color: Colors.white10,
                            child: const Icon(
                              Icons.music_note,
                              color: Colors.white54,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // JUDUL LAGU
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // NAMA ARTIS
                      Text(
                        item.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
