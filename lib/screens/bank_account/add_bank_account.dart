import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/bank.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_bank_account.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/screens/bank_account/bank_list_modal.dart';
import 'package:propstock/screens/bank_account/confirm_bank_account.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class AddBankAccount extends StatefulWidget {
  static const id = "add_bank_account";
  const AddBankAccount({super.key});

  @override
  State<AddBankAccount> createState() => _AddBankAccountState();
}

class _AddBankAccountState extends State<AddBankAccount> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _controller = TextEditingController();
  String _accountNumber = "";
  bool _loading = false;

  Future<void> _showWithdrawalSheet(BuildContext context) async {
    final Bank? res = await showModalBottomSheet(
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: context,
      builder: (BuildContext ctx) {
        return BankListModal();
      },
    );

    if (res == null) return;

    try {
      setState(() {
        _loading = true;
      });
      UserBankAccount bankDetails =
          await Provider.of<PaymentProvider>(context, listen: false)
              .verifyBankAccount(res, _controller.text);

      Navigator.pushNamed(context, ConfirmBankAccount.id,
              arguments: bankDetails)
          .then((value) {
        // if (value == "success") {
        print("push already popped back");
        Navigator.pop(context);
        // Navigator.pop(context);
        // }
      });

      print(bankDetails);
    } catch (e) {
      showErrorDialog(e.toString(), context);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          "Add a new bank account",
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
                          "Create a new account for all your withdrawals.",
                          style: TextStyle(
                            color: MyColors.neutral,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          // obscureText: obscuringText,
                          onChanged: (String val) {
                            setState(() {
                              _accountNumber = val;
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            label: Text('Enter account number'),
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
                      )
                    ],
                  )),
                  if (_loading)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20),
                      child: LinearProgressIndicator(),
                    ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: PropStockButton(
                      disabled: _accountNumber.length < 10,
                      onPressed: () {
                        _showWithdrawalSheet(context);
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
