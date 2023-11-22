import 'package:flutter/material.dart';

class DirectionImageSlider extends StatelessWidget {
  Icon icon;
  DirectionImageSlider({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(.3),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1)),
        child: icon);
  }
}
