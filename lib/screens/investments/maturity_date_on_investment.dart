import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_investment.dart';

class MaturityDateOnInvestment extends StatelessWidget {
  final UserInvestment? investment;
  const MaturityDateOnInvestment({super.key, required this.investment});

  @override
  Widget build(BuildContext context) {
    final String mdateProperty = DateFormat('dd MMMM, yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(investment!.maturityDate));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Maturity date",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: "Inter",
            )),
        SizedBox(
          height: 25,
        ),
        Wrap(
          children: [
            Text(
              "Maturity date for this investment is ",
              style: TextStyle(
                color: MyColors.neutralGrey,
                fontSize: 14,
                fontFamily: "Inter",
              ),
            ),
            Text(
              mdateProperty,
              style: TextStyle(
                color: MyColors.primary,
                fontSize: 14,
                fontFamily: "Inter",
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "Withdrawal before this date will attract a 2.5% breaking fee",
          style: TextStyle(
            color: MyColors.neutralGrey,
            fontSize: 14,
            fontFamily: "Inter",
          ),
        ),
      ],
    );
  }
}
