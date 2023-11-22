import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InvestHeader extends StatelessWidget {
  final String title;
  final void Function() seeAll;
  const InvestHeader({required this.title, required this.seeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Color(0xff1D3354),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            SvgPicture.asset(
              "images/Info.svg",
              height: 20,
            )
          ],
        ),
        GestureDetector(
          onTap: seeAll,
          child: Row(
            children: [
              Text(
                "See all",
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: "Inter",
                ),
              ),
              SizedBox(
                width: 5,
              ),
              SvgPicture.asset(
                "images/direction_right.svg",
                height: 13,
              )
            ],
          ),
        )
      ],
    );
  }
}
