import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/models/wallet.dart';
import 'package:propstock/providers/investments.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/providers/portfolio.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class TopUpViaAssetConfirmation extends StatefulWidget {
  @override
  State<TopUpViaAssetConfirmation> createState() =>
      _TopUpViaAssetConfirmationState();
}

class _TopUpViaAssetConfirmationState extends State<TopUpViaAssetConfirmation> {
  bool loading = true;

  bool fullHeight = false;

  FocusNode _focusNode = FocusNode();
  double _topuppayment = 0;
  TextEditingController _controller = TextEditingController();
  late Wallet? _wallet;
  UserInvestment? investment;
  // double _amount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _wallet =
          Provider.of<PortfolioProvider>(context, listen: false).selectedWallet;
      investment = Provider.of<InvestmentsProvider>(context, listen: false)
          .selectedInvestment;
      _topuppayment =
          Provider.of<PaymentProvider>(context, listen: false).topuppayment;

      loading = false;
    });

    // _fetchUserBanks();
  }

  bool isDouble(String text) {
    try {
      double.parse(text);
      return true;
    } catch (e) {
      return false;
    }
  }

  String getAvailableBalance() {
    double doublebalance = 0;
    String balance = "";
    NumberFormat formatter = NumberFormat.currency(
        locale: 'en_US', symbol: "${investment!.property.currency} ");

    // balance = formatter.format()
    if (investment!.maturityDate > DateTime.now().millisecondsSinceEpoch) {
      // if it's not mature
      doublebalance = ((investment!.property.pricePerUnit -
                  investment!.pricePerUnitAtPurchase) *
              investment!.quantity) -
          investment!.amountWithdrawn;
    } else {
      doublebalance =
          (investment!.property.pricePerUnit * investment!.quantity) -
              investment!.amountWithdrawn;
    }

    balance = formatter.format(doublebalance);
    return balance;
  }

  double getAvailableBalanceDouble() {
    double doublebalance = 0;

    if (investment!.maturityDate > DateTime.now().millisecondsSinceEpoch) {
      // if it's not mature
      doublebalance = ((investment!.property.pricePerUnit -
                  investment!.pricePerUnitAtPurchase) *
              investment!.quantity) -
          investment!.amountWithdrawn;
    } else {
      doublebalance =
          (investment!.property.pricePerUnit * investment!.quantity) -
              investment!.amountWithdrawn;
    }

    return doublebalance;
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat.currency(
        locale: 'en_US', symbol: "${investment!.property.currency} ");
    // print(_focusNode.hasFocus);
    return GestureDetector(
      onTap: () {
        print("hit detector");
        FocusScope.of(context).unfocus();
      },
      child: Container(
        color: Colors.white,
        height:
            _focusNode.hasFocus ? MediaQuery.of(context).size.height * .8 : 360,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            height: 40,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, "top_up_via_investments");
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: MyColors.neutralblack,
                ),
              ),
              const Expanded(
                child: Text(
                  "Top up via Asset",
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
          Container(
            width: double.infinity,
            child: Text(
              "Available Balance: ${getAvailableBalance()} ",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: MyColors.neutral,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: "Inter",
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            child: Text(
              "Withdraw ${formatter.format(_topuppayment)} from ${investment!.property.name}",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: MyColors.neutral,
                fontWeight: FontWeight.w400,
                fontSize: 16,
                fontFamily: "Inter",
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          if (loading) LinearProgressIndicator(),
          SizedBox(
            height: 20,
          ),
          PropStockButton(
              text: "Add Cash",
              disabled: getAvailableBalanceDouble() <= _topuppayment,
              onPressed: () async {
                try {
                  setState(() {
                    loading = true;
                  });
                  await Provider.of<PaymentProvider>(context, listen: false)
                      .setInvestmentWithdrawalRequestToWallet(
                          _topuppayment, investment);
                  Provider.of<InvestmentsProvider>(context, listen: false)
                      .setSelectedInvestment(null);
                  Navigator.pop(context, "success_topup_assets");
                } catch (e) {
                  showErrorDialog(e.toString(), context);
                } finally {
                  setState(() {
                    loading = false;
                  });
                }

                // Navigator.pop(context, "top_up_page_2");
              })
        ]),
      ),
    );
  }
}
