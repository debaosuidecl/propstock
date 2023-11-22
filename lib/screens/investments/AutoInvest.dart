import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_investment.dart';

class AutoInvest extends StatelessWidget {
  final UserInvestment? investment;
  final bool activeAutoInvest;
  final void Function(bool)? changeAutoInvest;
  const AutoInvest({
    required this.investment,
    required this.activeAutoInvest,
    required this.changeAutoInvest,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Auto-Invest",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: "Inter",
                color: MyColors.neutralblack,
              ),
            ),
            CupertinoSwitch(
              // overrides the default green color of the track
              activeColor: MyColors.primary,
              // color of the round icon, which moves from right to left
              thumbColor: !activeAutoInvest ? Colors.white : MyColors.primary,
              // when the switch is off
              trackColor: Color(0xffeeeeee),
              // boolean variable value
              value: activeAutoInvest,
              // changes the state of the switch
              onChanged: changeAutoInvest,
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Text(
            "Automatically re-invest in this property once the maturity date has been reached",
            style: TextStyle(
              color: MyColors.neutralGrey,
            ))
      ],
    );
  }
}
