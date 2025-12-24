import 'package:flutter/material.dart';

class FilterChipsWidget extends StatefulWidget {
  final Function(String) onChanged;
  const FilterChipsWidget({super.key, required this.onChanged});

  @override
  State<FilterChipsWidget> createState() => _FilterChipsWidgetState();
}

class _FilterChipsWidgetState extends State<FilterChipsWidget> {
  int selected = 0;
  final filters = ['all', 'music', 'podcast', 'artist', 'playlist'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (_, i) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filters[i].toUpperCase()),
              selected: selected == i,
              onSelected: (_) {
                setState(() => selected = i);
                widget.onChanged(filters[i]);
              },
            ),
          );
        },
      ),
    );
  }
}
