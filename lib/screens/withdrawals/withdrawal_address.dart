import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/providers/investments.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class WithdrawalAddress extends StatefulWidget {
  @override
  State<WithdrawalAddress> createState() => _WithdrawalAddressState();
}

class _WithdrawalAddressState extends State<WithdrawalAddress> {
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
              height: 360,
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
                            Navigator.pop(context, "amount_to_withdraw_b");
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: MyColors.neutralblack,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            "Withdrawal Address",
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
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, "select_a_bank");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Bank Account",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter",
                              color: MyColors.neutralblack,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xffbbbbbb),
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, 'propstock_wallet_withdraw');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Propstock wallet",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter",
                              color: MyColors.neutralblack,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xffbbbbbb),
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(),
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
