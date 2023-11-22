import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_investment.dart';

class UserInvestActions extends StatelessWidget {
  final UserInvestment? investment;
  final void Function()? sellaction;
  final void Function()? giftaction;
  final void Function()? withdrawaction;
  const UserInvestActions(
      {super.key,
      required this.investment,
      this.sellaction,
      this.giftaction,
      this.withdrawaction});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primary,
                  elevation: 0,
                ),
                onPressed: sellaction,
                child: Text(
                  "Sell",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[100],
                  elevation: 0,
                ),
                onPressed: withdrawaction,
                child: Text(
                  "Withdraw",
                  style: TextStyle(
                    color: MyColors.primary,
                    fontFamily: "Inter",
                  ),
                ),
              ),
            ))
          ],
        ),
        Container(
          margin: EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: MyColors.primary),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: ElevatedButton(
            onPressed: giftaction,
            child: Text(
              "Gift a friend",
              style: TextStyle(color: MyColors.primary),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
        )
      ],
    );
  }
}
