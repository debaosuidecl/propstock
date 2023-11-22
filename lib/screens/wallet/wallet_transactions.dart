import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_wallet_transaction.dart';
import 'package:propstock/screens/wallet/transaction.dart';

class WalletTransactions extends StatelessWidget {
  final List<UserWalletTransaction> transactions;
  final bool? hideloadmore;
  final void Function()? loadMoreHandler;
  const WalletTransactions(
      {super.key,
      required this.transactions,
      this.loadMoreHandler,
      this.hideloadmore});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            width: double.infinity,
            child: Text(
              "You have no transactions",
              style: TextStyle(
                fontFamily: "Inter",
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      );
    }
    return Expanded(
      child: ListView.builder(
        itemCount: transactions.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Column(
            children: [
              WalletSingleTransaction(uwt: transactions[index]),
              if (index == transactions.length - 1 &&
                  loadMoreHandler != null &&
                  hideloadmore != true)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: loadMoreHandler,
                    child: Text("Load More",
                        style: TextStyle(
                          color: MyColors.primary,
                        )),
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}
