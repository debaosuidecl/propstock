import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_wallet_transaction.dart';
import 'package:propstock/models/wallet.dart';
import 'package:propstock/providers/portfolio.dart';
import 'package:propstock/screens/wallet/TopUpViaInvestments.dart';
import 'package:propstock/screens/wallet/amount_to_withdraw_wallet.dart';
import 'package:propstock/screens/wallet/select_a_bank_for_wallet_withdraw.dart';
import 'package:propstock/screens/wallet/success_topup_asset.dart';
import 'package:propstock/screens/wallet/switch_cards.dart';
import 'package:propstock/screens/wallet/top_up_page_1.dart';
import 'package:propstock/screens/wallet/top_up_page_2.dart';
import 'package:propstock/screens/wallet/top_up_via_asset_confirmation.dart';
import 'package:propstock/screens/wallet/top_up_via_ussd.dart';
import 'package:propstock/screens/wallet/wallet_card.dart';
import 'package:propstock/screens/wallet/wallet_pin_top_up.dart';
import 'package:propstock/screens/wallet/wallet_transaction_page.dart';
import 'package:propstock/screens/wallet/wallet_transactions.dart';
import 'package:propstock/screens/wallet/walllet_pin_withdraw.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class WalletPage extends StatefulWidget {
  static const id = "wallet_page";
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  // String _flagUrl = "";
  bool _error = false;
  bool _loading = true;
  List<UserWalletTransaction> _userWalletTransactions = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Wallet? _wallet;
  String topupkey = "top_up_page_1";

  Map<String, dynamic> walletPages = {
    "top_up_page_1": TopUpPage1(),
    "top_up_page_2": TopUpPage2(),
    "switch_cards": SwitchCards(),
    "wallet_pin_top_up": WalletPinTopUp(),
    "top_up_via_investments": TopUpViaInvestments(),
    "top_up_via_asset_confirmation": TopUpViaAssetConfirmation(),
    "success_topup_assets": SuccessTopUpAsset(),
    "top_up_via_ussd": TopUpViaUSSD(),
    "withdraw_page_1": AmountToWithDrawWallet(),
    "select_a_bank": SelectBankForWalletWithdraw(),
    "wallet_pin_withdraw": WalletPinWithdraw(),
  };

  Future<void> _showTopUpSheet(BuildContext context) async {
    Provider.of<PortfolioProvider>(context, listen: false).setWallet(_wallet);
    final resultOfModal = await showModalBottomSheet(
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      context: context,
      builder: (BuildContext ctx) {
        return walletPages[topupkey];
      },
    );

    if (resultOfModal != null && resultOfModal != "success") {
      setState(() {
        topupkey = resultOfModal;
      });

      await _showTopUpSheet(context);
    } else {
      if (resultOfModal == "success") {
        _getWalletData();
      }
      setState(() {
        topupkey = "top_up_page_1";
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // _getWalletData("NGN");
    _getWalletData();
  }

  Future<void> _getWalletData() async {
    try {
      setState(() {
        _loading = true;
        _error = false;
      });
      dynamic res = await Future.wait([
        Provider.of<PortfolioProvider>(context, listen: false).fetchWallet(),
        Provider.of<PortfolioProvider>(context, listen: false)
            .fetchWalletTransaction(5, 0),
      ]);

      Wallet wallet = res[0];
      List<UserWalletTransaction> walletTransactions = res[1];

      setState(() {
        _wallet = wallet;
        _userWalletTransactions = walletTransactions;
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
    return Scaffold(
      appBar: !Navigator.canPop(context)
          ? null
          : AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: MyColors.primaryDark,
                  )),
            ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text("wallet"),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Wallet",
                style: TextStyle(
                  color: MyColors.secondary,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              if (_loading) LinearProgressIndicator(),

              if (_error)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Text(
                        "An Error as occured while loading wallet",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _getWalletData();
                      },
                      child: Icon(
                        Icons.refresh,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              if (!_loading && !_error)
                Column(
                  children: [
                    WalletCard(
                      wallet: _wallet,
                      topupHandler: () {
                        _showTopUpSheet(context);
                      },
                      withdrawHandler: () {
                        setState(() {
                          topupkey = "withdraw_page_1";
                        });
                        _showTopUpSheet(context);
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Transactions",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: MyColors.secondary,
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, WalletTransactionPage.id,
                                  arguments: _wallet!.currency);
                            },
                            child: const Text(
                              "View all",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff5E6D85),
                                fontWeight: FontWeight.w400,
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              if (!_loading)
                WalletTransactions(transactions: _userWalletTransactions)
            ],
          ),
        ),
      ),
    );
  }
}
