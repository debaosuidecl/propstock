import 'package:flutter/material.dart';

class TinyCircle extends StatelessWidget {
  Color color;

  TinyCircle({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      margin: EdgeInsets.all(3),
    );
  }
}
