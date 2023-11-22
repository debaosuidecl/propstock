import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';

class NumberChanger extends StatelessWidget {
  int number = 1;
  void Function() increase;
  void Function() decrease;

  NumberChanger({
    super.key,
    required this.number,
    required this.increase,
    required this.decrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 100,
      height: 50,
      padding: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: MyColors.fieldDefault,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            10,
          ),
        ),
      ),
      child: Row(children: [
        SizedBox(
          width: 10,
        ),
        GestureDetector(
            onTap: decrease, child: SvgPicture.asset("images/Minus.svg")),
        SizedBox(
          width: 10,
        ),
        Text("$number"),
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: increase,
          child: Icon(
            Icons.add,
            color: MyColors.neutralblack,
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ]),
    );
  }
}
