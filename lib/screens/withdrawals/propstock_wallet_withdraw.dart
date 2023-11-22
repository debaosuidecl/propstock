// PropstockWalletWithdraw
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/providers/investments.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/screens/dashboard.dart';
import 'package:propstock/screens/investment_portfolio/investment_portolio_sub_screen.dart';
import 'package:propstock/screens/investments/investements.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class PropstockWalletWithdraw extends StatefulWidget {
  @override
  State<PropstockWalletWithdraw> createState() =>
      _PropstockWalletWithdrawState();
}

class _PropstockWalletWithdrawState extends State<PropstockWalletWithdraw> {
  UserInvestment? investment;
  bool loading = true;
  bool processing = false;
  FocusNode _focusNode = FocusNode();
  TextEditingController _controller = TextEditingController();
  double amountToWithdraw = 0;
  bool _success = false;
  double amountToWithdrawDisplay = 0;

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
      if (investment!.maturityDate > DateTime.now().millisecondsSinceEpoch) {
        amountToWithdrawDisplay = amountToWithdraw - 0.025 * amountToWithdraw;
      } else {
        amountToWithdrawDisplay = amountToWithdraw;
      }
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
              height: _success ? 600 : 300,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _success
                  ? Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Text(
                            "Withdrawal Successful",
                            style: TextStyle(
                              color: MyColors.secondary,
                              fontFamily: "Inter",
                              fontSize: 26,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Image(
                            image: AssetImage("images/successcircle.png"),
                            height: 150,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            "You just cashed out!",
                            style: TextStyle(
                              color: MyColors.neutralGrey,
                              fontFamily: "Inter",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColors.primary,
                                  elevation: 0,
                                ),
                                onPressed: () async {
                                  // _showBottomSheet(context);
                                  print("going to investments");
                                  // Navigator.pop(context);

                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    Investments
                                        .id, // The route name to navigate to
                                    ModalRoute.withName(Dashboard
                                        .id), // Stop when reaching ScreenA
                                  );
                                },
                                child: Text(
                                  "Done",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )),
                          )
                        ],
                      ),
                    )
                  : Column(
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
                                  Navigator.pop(context, "withdrawal_address");
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: MyColors.neutralblack,
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  "Propstock Wallet",
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
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "You are about to withdraw your ${formatter.format(amountToWithdrawDisplay)} into your propstock wallet",
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
                          if (processing) LinearProgressIndicator(),
                          const SizedBox(
                            height: 20,
                          ),
                          PropStockButton(
                              text: "Cash out",
                              disabled: false,
                              onPressed: () async {
                                Provider.of<PaymentProvider>(context,
                                        listen: false)
                                    .setSelectedBank(null);

                                setState(() {
                                  processing = true;
                                });

                                try {
                                  await Provider.of<PaymentProvider>(context,
                                          listen: false)
                                      .setInvestmentWithdrawalRequestToWallet(
                                          amountToWithdraw, investment);

                                  setState(() {
                                    _success = true;
                                  });
                                } catch (e) {
                                  showErrorDialog(e.toString(), context);
                                } finally {
                                  setState(() {
                                    processing = false;
                                  });
                                }

                                // Navigator.pop(context, "withdrawal_address");
                              })
                        ]),
            ),
          );
  }
}
