import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/profit_rev_profile_investment.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/providers/investments.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class AmountToWithdraw extends StatefulWidget {
  @override
  State<AmountToWithdraw> createState() => _AmountToWithdrawState();
}

class _AmountToWithdrawState extends State<AmountToWithdraw> {
  UserInvestment? investment;
  bool loading = true;
  FocusNode _focusNode = FocusNode();
  ProfitRevProfileInvestment? _profitRevProfile;
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserInvestment? inv =
        Provider.of<InvestmentsProvider>(context, listen: false)
            .selectedInvestment;
    _getLatestPropertyPrice();
    setState(() {
      investment = inv;
    });
  }

  Future<void> _getLatestPropertyPrice() async {
    try {
      ProfitRevProfileInvestment profitRevProfile =
          await Provider.of<InvestmentsProvider>(context, listen: false)
              .fetchProfitOnInvestment();

      setState(() {
        _profitRevProfile = profitRevProfile;
      });
    } catch (e) {
      showErrorDialog("failed to get latest property price", context);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat.currency(
        locale: 'en_US', symbol: "${investment!.property.currency} ");
    // double availableToWithdraw = investment!.coInvestors.isNotEmpty
    //     ? investment!.coInvestAmount *
    //             investment!.property.pricePerUnit /
    //             (investment!.pricePerUnitAtPurchase * investment!.quantity) -
    //         investment!.amountWithdrawn
    //     : (investment!.property.pricePerUnit * investment!.quantity) -
    //         investment!.amountWithdrawn;
    if (loading) {
      return LinearProgressIndicator();
    }
    double availableToWithdraw = _profitRevProfile!.notmature == "yes"
        ? _profitRevProfile!.profit
        : _profitRevProfile!.revenue;
    // print(investment!.coInvestAmount);
    print(
        "${investment!.property.pricePerUnit} ${investment!.id} ${investment!.quantity}");

    return loading
        ? CircularProgressIndicator()
        : GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              height: _focusNode.hasFocus
                  ? MediaQuery.of(context).size.height
                  : 400,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Amount to withdraw",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Available to Withdraw: ${formatter.format(availableToWithdraw)}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Inter",
                          color: MyColors.neutral,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (investment!.maturityDate >
                        DateTime.now().millisecondsSinceEpoch)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "A 2.5% penalty fee will be deducted from this amount.",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                            fontFamily: "Inter",
                            color: MyColors.neutral,
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 40,
                    ),
                    if (_profitRevProfile!.notmature == "yes")
                      TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        // obscureText: obscuringText,
                        onChanged: (String val) {
                          // setState(() {
                          //   password = val;
                          // });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          label: Text(
                              'Enter amount (${investment!.property.currency}) '),
                          hintStyle: TextStyle(color: Color(0xffbbbbbb)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xffCBDFF7),
                            ), // Use the hex color
                            borderRadius: BorderRadius.circular(
                                8), // You can adjust the border radius as needed
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 40,
                    ),
                    PropStockButton(
                        text: "Continue",
                        disabled: false,
                        onPressed: () async {
                          if (_profitRevProfile!.notmature == "yes") {
                            if (_profitRevProfile!.profit == 0) {
                              showErrorDialog(
                                  "There is no profit on this property. hence there can be no withdrawal",
                                  context);
                              return;
                            }
                          }
                          if (_controller.text.isEmpty) {
                            showErrorDialog(
                                "An amount must be entered", context);
                            return;
                          }
                          try {
                            double amountToWithdraw =
                                double.parse(_controller.text);
                            if (_profitRevProfile!.notmature != "yes") {
                              amountToWithdraw = _profitRevProfile!.revenue;
                            }

                            if (amountToWithdraw > availableToWithdraw) {
                              showErrorDialog(
                                  "Amount entered is higher than the available amount",
                                  context);
                              return;
                            }
                            Provider.of<InvestmentsProvider>(context,
                                    listen: false)
                                .setAmountToWithdraw(amountToWithdraw);
                            Provider.of<InvestmentsProvider>(context,
                                    listen: false)
                                .setSelectedInvestment(investment);
                            // await Future.delayed(Duration(seconds: 1));
                            // print(amountToWithdraw);
                            // return;
                            Navigator.pop(context, "amount_to_withdraw_b");
                          } catch (e) {
                            print(e);
                            showErrorDialog("Wrong input", context);
                          }
                        })
                  ]),
            ),
          );
  }
}
