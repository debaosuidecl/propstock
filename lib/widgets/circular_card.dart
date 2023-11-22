import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';

class CircularCard extends StatelessWidget {
  final String title;
  final bool selected;

  const CircularCard({
    super.key,
    required this.title,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 96,
      height: 40,
      padding: const EdgeInsets.symmetric(
        vertical: 13,
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        color: selected ? MyColors.primary : const Color(0xffE0EAF6),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text(
        title,
        style:
            TextStyle(color: selected ? Colors.white : const Color(0xff5E6D85)),
      ),
    );
  }
}
