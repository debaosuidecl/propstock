//TopUpViaUSSD

import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/wallet.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/providers/portfolio.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:propstock/widgets/ussd_list_tile.dart';
import 'package:provider/provider.dart';

class TopUpViaUSSD extends StatefulWidget {
  @override
  State<TopUpViaUSSD> createState() => _TopUpViaUSSDState();
}

class _TopUpViaUSSDState extends State<TopUpViaUSSD> {
  bool loading = true;
  String _selectedUSSDCode = "";
  bool fullHeight = false;
  double _topupamount = 0;
  late Wallet? _wallet;
  double _amount = 0;
  bool success = false;
  String successMessage = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _wallet =
          Provider.of<PortfolioProvider>(context, listen: false).selectedWallet;
      _topupamount =
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

  //   void _showAlertDialog(BuildContext context, String title, String description,
  //     {bool? startPayment}) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(title),
  //         content: Text(description),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               // Close the AlertDialog when the "OK" button is pressed

  //             },
  //             child: Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
        height: MediaQuery.of(context).size.height * .7,
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
                  Navigator.pop(context, "top_up_page_2");
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: MyColors.neutralblack,
                ),
              ),
              const Expanded(
                child: Text(
                  "Top up via USSD",
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
          if (!success)
            Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Text(
                    "Choose your bank to start your wallet top up",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: MyColors.neutral,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                if (loading) const LinearProgressIndicator(),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedUSSDCode = "822";
                    });
                  },
                  child: USSDListTile(
                    bank: "Sterling Bank",
                    ussdCode: "*822#",
                    selected: _selectedUSSDCode == "822",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedUSSDCode = "737";
                    });
                  },
                  child: USSDListTile(
                    bank: "Guarantee Trust Bank",
                    ussdCode: "*737#",
                    selected: _selectedUSSDCode == "737",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedUSSDCode = "919";
                    });
                  },
                  child: USSDListTile(
                    bank: "United Bank for Africa",
                    ussdCode: "*919#",
                    selected: _selectedUSSDCode == "919",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                ),
                PropStockButton(
                    text: "Add Cash",
                    disabled: _selectedUSSDCode.isEmpty,
                    onPressed: () async {
                      // set ussd request
                      try {
                        setState(() {
                          loading = true;
                        });
                        dynamic successStatus =
                            await Provider.of<PaymentProvider>(context,
                                    listen: false)
                                .topUpWithUSSD(_selectedUSSDCode, _topupamount);

                        // Navigator.pop(context, 'success');
                        setState(() {
                          success = true;
                          successMessage =
                              successStatus["data"]["display_text"];
                        });
                      } catch (e) {
                        showErrorDialog(e.toString(), context);
                      } finally {
                        setState(() {
                          loading = false;
                        });
                      }
                    })
              ],
            ),
          if (success)
            Column(
              children: [
                Text(
                  successMessage,
                  style: TextStyle(
                    color: MyColors.neutral,
                    fontFamily: "Inter",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                PropStockButton(
                    text: "Done",
                    disabled: false,
                    onPressed: () async {
                      Navigator.pop(context, 'success');
                    })
              ],
            )
        ]),
      ),
    );
  }
}
