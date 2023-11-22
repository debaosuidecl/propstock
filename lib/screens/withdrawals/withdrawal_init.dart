import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/providers/investments.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class WithdrawalInit extends StatefulWidget {
  const WithdrawalInit({super.key});

  @override
  State<WithdrawalInit> createState() => _WithdrawalInitState();
}

class _WithdrawalInitState extends State<WithdrawalInit> {
  @override
  Widget build(BuildContext context) {
    final UserInvestment? investment =
        Provider.of<InvestmentsProvider>(context, listen: false)
            .selectedInvestment;
    return Container(
      height: 350,
      child: Column(children: [
        SizedBox(
          height: 40,
        ),
        Text(
          "Withdraw investment",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: "Inter",
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Container(
          width: MediaQuery.of(context).size.width * .8,
          child: Text(
            "You are about to withdraw your investment. This will include your capital and returns of investment",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: "Inter",
              color: MyColors.neutral,
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
          child: PropStockButton(
              text: "Continue",
              disabled: false,
              onPressed: () {
                Navigator.pop(
                    context,
                    investment!.maturityDate >
                            DateTime.now().millisecondsSinceEpoch
                        ? "amount_to_withdraw"
                        : "amount_to_withdraw_mature");
              }),
        )
      ]),
    );
  }
}
