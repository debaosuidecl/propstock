import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/user_wallet_transaction.dart';

class WalletSingleTransaction extends StatelessWidget {
  final UserWalletTransaction uwt;
  const WalletSingleTransaction({super.key, required this.uwt});
  String capitalizeFirstLetter(String word) {
    if (word.isEmpty) {
      return word; // Return the original string if it's empty
    }
    return word[0].toUpperCase() + word.substring(1);
  }

  String millisecondDateToTimeFormat(int createdAt) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(createdAt);
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat formatter =
        NumberFormat.currency(locale: 'en_US', symbol: "${uwt.currency} ");
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: uwt.amount > 0
          ? SvgPicture.asset("images/uptrans.svg")
          : SvgPicture.asset("images/downtrans.svg"),
      title: Text(
        "${capitalizeFirstLetter(uwt.title)}",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontFamily: "Inter",
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color(0xff222222),
        ),
      ),
      subtitle: Text(
        millisecondDateToTimeFormat(uwt.createdAt),
        style: TextStyle(
          fontFamily: "Inter",
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Color(0xff222222),
        ),
      ),
      trailing: Text(
        "${uwt.amount < 0 ? "-" : "+"} ${formatter.format(uwt.amount)}",
        style: TextStyle(
          color: Color(0xff222222),
          fontWeight: FontWeight.w600,
          fontFamily: "Inter",
          fontSize: 14,
        ),
      ),
    );
  }
}
