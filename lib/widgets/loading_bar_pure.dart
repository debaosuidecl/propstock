import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/widgets/dotted_line_painter.dart';

class LoadingBarPure extends StatelessWidget {
  final double fraction;
  final Color filledColor;
  final double barHeight;
  const LoadingBarPure(
      {super.key,
      required this.fraction,
      required this.filledColor,
      required this.barHeight});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          // fit: StackFit.passthrough,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              child: Container(
                width: 104,
                height: barHeight,
                decoration: const BoxDecoration(
                  color: Color(0xffEBEDF0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      15,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              child: Container(
                width: 104 * fraction,
                height: barHeight,
                decoration: BoxDecoration(
                  color: filledColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
