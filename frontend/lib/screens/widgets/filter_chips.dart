import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class FilterChipsWidget extends StatefulWidget {
  final Function(String) onChanged;
  const FilterChipsWidget({super.key, required this.onChanged});

  @override
  State<FilterChipsWidget> createState() => _FilterChipsWidgetState();
}

class _FilterChipsWidgetState extends State<FilterChipsWidget> {
  int selected = 0;
  // List filter disesuaikan: All, Music, Podcast, Level UP
  final filters = ['All', 'Music', 'Podcast', 'Level UP'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (_, i) {
          final isSelected = selected == i;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(
                filters[i],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              selectedColor: QColors.primaryPurple,
              backgroundColor: QColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Colors.transparent),
              ),
              showCheckmark: false,
              onSelected: (bool selectedStatus) {
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
