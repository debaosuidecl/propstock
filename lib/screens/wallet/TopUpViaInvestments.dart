import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/providers/investments.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/investment_card_topup.dart';
import 'package:provider/provider.dart';

class TopUpViaInvestments extends StatefulWidget {
  const TopUpViaInvestments({super.key});

  @override
  State<TopUpViaInvestments> createState() => _TopUpViaInvestmentsState();
}

class _TopUpViaInvestmentsState extends State<TopUpViaInvestments> {
  List<UserInvestment> _investments = [];
  bool _loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchAvailableBalanceInvestments();
  }

  Future<dynamic> _fetchAvailableBalanceInvestments() async {
    try {
      List<UserInvestment> investments =
          await Provider.of<InvestmentsProvider>(context, listen: false)
              .fetchMatureInvestmentsWithAvailableBalance("", 0, 20);

      setState(() {
        _investments = investments;
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
    // print(_focusNode.hasFocus);
    return GestureDetector(
      onTap: () {
        print("hit detector");
        FocusScope.of(context).unfocus();
      },
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * .89,
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
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: MyColors.neutralblack,
                ),
              ),
              const Expanded(
                child: Text(
                  "Top up via Investments",
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
          Text(
            "Select the asset you wish to withdraw from to for top up",
            style: TextStyle(
              fontFamily: "Inter",
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: MyColors.neutral,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          if (_loading) LinearProgressIndicator(),
          if (_investments.isEmpty && !_loading)
            Column(
              children: [Text("There are no investments available for topup")],
            ),
          Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _investments.length,
                  itemBuilder: (context, index) {
                    return InvestmentCardTopup(
                        investment: _investments[index],
                        onPressed: () {
                          print("setting selected investment for topup");
                          Provider.of<InvestmentsProvider>(context,
                                  listen: false)
                              .setSelectedInvestment(_investments[index]);
                          Navigator.pop(
                              context, "top_up_via_asset_confirmation");
                        });
                  }))
        ]),
      ),
    );
  }
}
