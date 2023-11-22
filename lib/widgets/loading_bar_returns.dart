import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/widgets/dotted_line_painter.dart';

class LoadingBar extends StatelessWidget {
  final double fraction;
  const LoadingBar({super.key, required this.fraction});

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
                width: MediaQuery.of(context).size.width,
                height: 6,
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
                width: MediaQuery.of(context).size.width * fraction,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      15,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                left: MediaQuery.of(context).size.width * fraction * .95,
                top: -6,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: MyColors.primary,
                    shape: BoxShape.circle,
                  ),
                )),
            Positioned(
              left: MediaQuery.of(context).size.width * fraction * .9,
              top: -80,
              child: Column(
                children: [
                  Text("Current"),
                  Text("${(fraction * 100).toStringAsFixed(2)}%"),
                  CustomPaint(
                    size: Size(1.0, 50.0), // Adjust the size as needed
                    painter: DottedLinePainter(),
                  ),
                ],
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * fraction * .45,
              top: 10,
              child: Column(
                children: [
                  CustomPaint(
                    size: Size(1.0, 50.0), // Adjust the size as needed
                    painter: DottedLinePainter(),
                  ),
                  Text("Historical Ave"),
                  Text("${(fraction / 2 * 100).toStringAsFixed(2)}%"),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
