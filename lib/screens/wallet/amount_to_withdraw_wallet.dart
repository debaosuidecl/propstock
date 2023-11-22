import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/profit_rev_profile_investment.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/models/wallet.dart';
import 'package:propstock/providers/investments.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/providers/portfolio.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class AmountToWithDrawWallet extends StatefulWidget {
  @override
  State<AmountToWithDrawWallet> createState() => _AmountToWithDrawWalletState();
}

class _AmountToWithDrawWalletState extends State<AmountToWithDrawWallet> {
  UserInvestment? investment;
  bool loading = true;
  FocusNode _focusNode = FocusNode();
  ProfitRevProfileInvestment? _profitRevProfile;
  TextEditingController _controller = TextEditingController();
  Wallet? _wallet;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initWithdraw();
  }

  void _initWithdraw() {
    _wallet =
        Provider.of<PortfolioProvider>(context, listen: false).selectedWallet;
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
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
              color: Colors.white,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      "Amount to withdraw",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Enter the amount you wish to withdraw from your wallet.",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Inter",
                          color: MyColors.neutral,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                        label: Text('Enter amount (${_wallet!.currency}) '),
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
                        text: "Cash Out",
                        disabled: _controller.text.isEmpty,
                        onPressed: () async {
                          if (_controller.text.isEmpty) {
                            showErrorDialog(
                                "An amount must be entered", context);
                            return;
                          }
                          try {
                            double parsedAmount =
                                double.parse(_controller.text);
                            // await Future.delayed(Duration(seconds: 1));
                            // print(AmountToWithDrawWallet);
                            // return;
                            Provider.of<PaymentProvider>(context, listen: false)
                                .setWithdrawPayment(parsedAmount);
                            Navigator.pop(context, "select_a_bank");
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
