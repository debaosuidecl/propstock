import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/models/wallet.dart';
// import 'package:flutter/services.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/providers/property.dart';

import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class DisplayWalletBalance extends StatefulWidget {
  const DisplayWalletBalance({super.key});

  @override
  State<DisplayWalletBalance> createState() => _DisplayWalletBalanceState();
}

class _DisplayWalletBalanceState extends State<DisplayWalletBalance> {
  bool _loading = true;
  // List<CardModel> _cards = [];
  Wallet? _wallet;
  Property? _property;
  int _quantity = 0;
  double _userShare = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initPaymentoptions();
  }

  Future<void> _initPaymentoptions() async {
    try {
      // get user cards

      Wallet wallet = await Provider.of<PaymentProvider>(context, listen: false)
          .fetchUserWallet();
      Property? property =
          Provider.of<PaymentProvider>(context, listen: false).propertyToPay;
      int quantity = Provider.of<PaymentProvider>(context, listen: false)
          .quantityOfProperty;
      double userShareInCoInvestment =
          Provider.of<PropertyProvider>(context, listen: false)
              .userShareInCoInvestment;
      setState(() {
        _wallet = wallet;
        _property = property;
        _quantity = quantity;
        _userShare = userShareInCoInvestment;
        // _cards = Provider.of<PaymentProvider>(context, listen: false).userCards;
      });
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
    if (_loading) {
      return Container(height: 10, child: LinearProgressIndicator());
    }
    NumberFormat formatter =
        NumberFormat.currency(locale: 'en_US', symbol: _wallet!.currency);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 250,
      child: Column(children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context, "restart");
              },
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: MyColors.neutralGrey,
              ),
            ),
            Expanded(
                child: Text(
              "Pay with wallet",
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
          height: 50,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Available Balance: ${formatter.format(_wallet!.amount)}",
              style: TextStyle(
                color: MyColors.neutral,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        if (_userShare <= 0)
          PropStockButton(
              text:
                  "Pay ${formatter.format(_property!.pricePerUnit * _quantity)}",
              disabled:
                  _wallet!.amount - _property!.pricePerUnit * _quantity < 0,
              onPressed: () {
                if (_wallet!.amount - _property!.pricePerUnit * _quantity < 0) {
                  return;
                }

                Navigator.pop(context, 'wallet');
              }),
        if (_userShare > 0)
          PropStockButton(
              text: "Pay ${formatter.format(_userShare)}",
              disabled: _wallet!.amount - _userShare < 0,
              onPressed: () {
                if (_wallet!.amount - _userShare < 0) {
                  return;
                }

                Navigator.pop(context, 'wallet');
              }),
      ]),
    );
  }
}
