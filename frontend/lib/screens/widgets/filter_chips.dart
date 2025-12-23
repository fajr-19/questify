import 'package:flutter/material.dart';

class FilterChipsWidget extends StatefulWidget {
  const FilterChipsWidget({super.key});

  @override
  State<FilterChipsWidget> createState() => _FilterChipsWidgetState();
}

class _FilterChipsWidgetState extends State<FilterChipsWidget> {
  int selectedIndex = 0;
  final filters = ['All', 'Music', 'Podcast', 'Artist', 'Playlist'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final selected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filters[index]),
              selected: selected,
              onSelected: (_) {
                setState(() => selectedIndex = index);
              },
              selectedColor: Colors.deepPurple,
              labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
            ),
          );
        },
      ),
    );
  }
}
