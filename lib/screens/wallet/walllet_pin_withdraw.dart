import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_bank_account.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/providers/investments.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class WalletPinWithdraw extends StatefulWidget {
  WalletPinWithdraw({
    super.key,
  });

  @override
  State<WalletPinWithdraw> createState() => _WalletPinWithdrawState();
}

class _WalletPinWithdrawState extends State<WalletPinWithdraw> {
  // Property? _property;
  bool loading = false;
  bool _success = false;
  UserInvestment? _userInvestment;
  UserBankAccount? _userBankAccount;
  double _amountToWithdraw = 0.0;
  FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initPinManagement();
  }

  void _initPinManagement() {
    _userBankAccount = Provider.of<InvestmentsProvider>(context, listen: false)
        .selectedBankAccount;
    _amountToWithdraw =
        Provider.of<PaymentProvider>(context, listen: false).withdrawpayment;
    setState(() {});
  }

  TextEditingController _pinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 67,
      height: 77,
      padding: const EdgeInsets.only(bottom: 15),
      textStyle: TextStyle(
          fontSize: 25,
          color: Colors.black,
          fontWeight: FontWeight.w300,
          fontFamily: "Inter"),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffbbbbbb))),
        color: Colors.transparent,
        // borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border(bottom: BorderSide(color: Color(0xff222222))),
      // borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border(bottom: BorderSide(color: Color(0xff222222))),
        // color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration
          ?.copyWith(border: Border(bottom: BorderSide(color: Colors.red))),
      // color: Color.fromRGBO(234, 239, 243, 1),
    );
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      // Calculate available screen height
      double screenHeight = constraints.maxHeight;

      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            height: _focusNode.hasFocus
                ? screenHeight
                : MediaQuery.of(context).size.height * .7,
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
                                print("going to wallet");
                                Navigator.pop(context, "success");
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
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context, "select_a_bank");
                            },
                            child: Icon(
                              Icons.arrow_back_ios_new_outlined,
                              color: MyColors.neutralGrey,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            "Input your PIN",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: MyColors.secondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                fontFamily: "Inter"),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Enter your four digit transaction PIN to complete this transaction",
                        style: TextStyle(
                          color: MyColors.neutralGrey,
                          fontSize: 16,
                          fontFamily: "Inter",
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Pinput(
                          onChanged: (String val) {},
                          focusNode: _focusNode,
                          defaultPinTheme: defaultPinTheme,
                          obscureText: true,
                          controller: _pinController,
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          errorPinTheme: errorPinTheme,
                          length: 4,
                          pinputAutovalidateMode:
                              PinputAutovalidateMode.onSubmit,
                          showCursor: true,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      if (loading) LinearProgressIndicator(),
                      SizedBox(
                        height: 30,
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
                              try {
                                setState(() {
                                  loading = true;
                                });
                                await Provider.of<PaymentProvider>(context,
                                        listen: false)
                                    .withdrawFromWalletToBankAccount(
                                        _pinController.text,
                                        _userBankAccount,
                                        _amountToWithdraw);
                                Provider.of<PaymentProvider>(context,
                                        listen: false)
                                    .setSelectedBank(null);

                                setState(() {
                                  _success = true;
                                });
                              } catch (e) {
                                showErrorDialog(e.toString(), context);
                              } finally {
                                setState(() {
                                  loading = false;
                                });
                              }
                            },
                            child: Text(
                              "Cash out",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )),
                      )
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
