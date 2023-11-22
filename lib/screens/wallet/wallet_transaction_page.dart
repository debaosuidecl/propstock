import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_wallet_transaction.dart';
import 'package:propstock/models/wallet.dart';
import 'package:propstock/providers/portfolio.dart';
import 'package:propstock/screens/wallet/wallet_transactions.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class WalletTransactionPage extends StatefulWidget {
  static const id = "wallet_transaction_page";
  const WalletTransactionPage({super.key});

  @override
  State<WalletTransactionPage> createState() => _WalletTransactionPageState();
}

class _WalletTransactionPageState extends State<WalletTransactionPage> {
  bool _error = false;
  bool _loading = true;
  int page = 0;
  int limit = 5;
  bool showLoadMore = true;
  List<UserWalletTransaction> _userWalletTransactions = [];
  Wallet? _wallet;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getWalletData();
  }

  Future<void> _getWalletData() async {
    try {
      setState(() {
        _loading = true;
        _error = false;
      });
      List<UserWalletTransaction> res =
          await Provider.of<PortfolioProvider>(context, listen: false)
              .fetchWalletTransaction(limit, page);

      if (res.length < 5) {
        setState(() {
          showLoadMore = false;
        });
      }
      List<UserWalletTransaction> walletTransactions = res;

      setState(() {
        _userWalletTransactions = _userWalletTransactions + walletTransactions;
      });
    } catch (e) {
      showErrorDialog(e.toString(), context);
      setState(() {
        _error = true;
      });
    } finally {
      setState(() {
        _loading = false;
        _error = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String currency =
        ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: MyColors.neutralblack,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Transactions (${currency})",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: MyColors.secondary,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            WalletTransactions(
              transactions: _userWalletTransactions,
              hideloadmore: !showLoadMore,
              loadMoreHandler: () {
                setState(() {
                  page = page + 1;
                });
                _getWalletData();
              },
            ),
            // GestureDetector(
            //   onTap: () {
            //     // load more
            //     setState(() {
            //       page = page + 1;
            //     });
            //   },
            //   child: Text("Load more"),
            // )
          ],
        ),
      ),
    );
  }
}
