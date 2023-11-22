import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/providers/investments.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class AmountToWithdrawB extends StatefulWidget {
  @override
  State<AmountToWithdrawB> createState() => _AmountToWithdrawBState();
}

class _AmountToWithdrawBState extends State<AmountToWithdrawB> {
  UserInvestment? investment;
  bool loading = true;
  FocusNode _focusNode = FocusNode();
  TextEditingController _controller = TextEditingController();
  double amountToWithdraw = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      investment = Provider.of<InvestmentsProvider>(context, listen: false)
          .selectedInvestment;

      amountToWithdraw =
          Provider.of<InvestmentsProvider>(context, listen: false)
              .amountToWithdraw;
      if (investment!.maturityDate > DateTime.now().millisecondsSinceEpoch) {
        //if not mature

        amountToWithdraw = amountToWithdraw - 0.025 * amountToWithdraw;
      }
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat.currency(
        locale: 'en_US', symbol: "${investment!.property.currency} ");

    // print(investment!.coInvestAmount);

    return loading
        ? CircularProgressIndicator()
        : GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              height: 300,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.c,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context, "amount_to_withdraw");
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: MyColors.neutralblack,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            "Amount to withdraw",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Inter",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        formatter.format(amountToWithdraw),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Inter",
                          color: MyColors.neutralblack,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Total amount to withdraw including penalty fee",
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
                    PropStockButton(
                        text: "Continue",
                        disabled: false,
                        onPressed: () {
                          Navigator.pop(context, "withdrawal_address");
                        })
                  ]),
            ),
          );
  }
}
