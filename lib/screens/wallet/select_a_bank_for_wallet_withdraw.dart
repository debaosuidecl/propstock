import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_bank_account.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/providers/investments.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/screens/bank_account/add_bank_account.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class SelectBankForWalletWithdraw extends StatefulWidget {
  @override
  State<SelectBankForWalletWithdraw> createState() =>
      _SelectBankForWalletWithdrawState();
}

class _SelectBankForWalletWithdrawState
    extends State<SelectBankForWalletWithdraw> {
  UserInvestment? investment;
  bool loading = true;
  double amountToWithdraw = 0;

  List<UserBankAccount> _bankAccounts = [];

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

    _fetchUserBanks();
  }

  Future<void> _fetchUserBanks() async {
    try {
      List<UserBankAccount> bankAccounts =
          await Provider.of<PaymentProvider>(context, listen: false)
              .fetchAccounts();
      print(bankAccounts);
      setState(() {
        _bankAccounts = bankAccounts;
      });
    } catch (e) {
      showErrorDialog(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                            Navigator.pop(context, "withdraw_page_1");
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: MyColors.neutralblack,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            "Select a Bank",
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
                    Expanded(
                      flex: 2,
                      child: ListView.builder(
                          itemCount: _bankAccounts.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            UserBankAccount userBankAccount =
                                _bankAccounts[index];
                            return GestureDetector(
                              onTap: () {
                                Provider.of<InvestmentsProvider>(context,
                                        listen: false)
                                    .setSelectedUserBankAccount(
                                        userBankAccount);

                                Navigator.pop(context, "wallet_pin_withdraw");
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(userBankAccount.bank.name),
                                    subtitle: Text(
                                      userBankAccount.accountName,
                                    ),
                                  ),
                                  Divider(
                                    color: Color(0xffbbbbbb),
                                  )
                                ],
                              ),
                            );
                          }),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.pop(context, "select_a_bank");
                          Navigator.pushNamed(context, AddBankAccount.id)
                              .then((val) {
                            _fetchUserBanks();
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "+ Add a new bank",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Inter",
                                color: MyColors.primary,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xffbbbbbb),
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ]),
            ),
          );
  }
}
