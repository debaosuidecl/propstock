import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/bank.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_bank_account.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/screens/bank_account/bank_list_modal.dart';
import 'package:propstock/screens/investments/investment_details.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class ConfirmBankAccount extends StatefulWidget {
  static const id = "confirm_bank_account";
  const ConfirmBankAccount({super.key});

  @override
  State<ConfirmBankAccount> createState() => _ConfirmBankAccountState();
}

class _ConfirmBankAccountState extends State<ConfirmBankAccount> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _controller = TextEditingController();
  String _accountNumber = "";
  bool _loading = false;

  Future<void> _showSuccessModal(BuildContext context) async {
    final Bank? res = await showModalBottomSheet(
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: context,
      builder: (BuildContext ctx) {
        return Container(
          height: 350,
          child: Column(children: [
            SizedBox(
              height: 40,
            ),
            Text(
              "Bank Save Successful!",
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
                child: SvgPicture.asset("images/success_circle.svg")),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
              child: PropStockButton(
                  text: "Done",
                  disabled: false,
                  onPressed: () {
                    // Navigator.popUntil(context, (route) {
                    //   return route.settings.name == InvestmentDetails.id;
                    // });
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }),
            )
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserBankAccount bankAccount =
        ModalRoute.of(context)!.settings.arguments as UserBankAccount;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * .9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: SvgPicture.asset(
                                  "images/back_arrow.svg",
                                  height: 32,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Confirm Account",
                            style: TextStyle(
                              color: MyColors.secondary,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Confirm your bank account and make sure all the details below are correct.",
                            style: TextStyle(
                              color: MyColors.neutral,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            bankAccount.accountName,
                            style: TextStyle(
                              color: MyColors.primaryDark,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (_loading)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: LinearProgressIndicator(),
                          ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            bankAccount.bank.name,
                            style: TextStyle(
                              color: MyColors.neutral,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: PropStockButton(
                      disabled: false,
                      onPressed: () async {
                        // _showSuccessModal(context);
                        setState(() {
                          _loading = true;
                        });
                        try {
                          await Provider.of<PaymentProvider>(context,
                                  listen: false)
                              .saveUserBankAccount(bankAccount);
                          _showSuccessModal(context);
                        } catch (e) {
                          showErrorDialog(e.toString(), context);
                        } finally {
                          setState(() {
                            _loading = false;
                          });
                        }
                      },
                      text: "Continue",
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
