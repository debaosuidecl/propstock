import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/invest/co_invest_modal.dart';
import 'package:propstock/screens/investments/successInvest.dart';
// import 'package:propstock/screens/invest/send_investment_as_gifts.dart';
import 'package:propstock/screens/payments/display_wallet_balance.dart';
import 'package:propstock/screens/payments/enter_pin_pre_purchase.dart';
import 'package:propstock/screens/payments/pick_payment_option.payment_page.dart';
import 'package:propstock/utils/showErrorDialog.dart';
// import 'package:propstock/screens/single_person_investment/display_wallet_balance.dart';
// import 'package:propstock/screens/single_person_investment/enter_pin_pre_purchase.dart';
// import 'package:propstock/screens/single_person_investment/pick_payment_option.payment_page.dart';
import 'package:propstock/widgets/number_changer.dart';
import 'package:propstock/widgets/selected_user.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class CoInvestFinalPage extends StatefulWidget {
  final Property? property;
  const CoInvestFinalPage({super.key, this.property});
  static const id = "CoInvestFinalPage";
  @override
  State<CoInvestFinalPage> createState() => _CoInvestFinalPageState();
}

enum PaymentPages {
  pickPaymentOption,
  enterPinPrePurchase,
  displayWalletBalance,
}

class _CoInvestFinalPageState extends State<CoInvestFinalPage> {
  int _number = 1;
  // User? _friendToGift;
  int _payment_page = 0;

  List<User> _coInvestors = [];

  final GlobalKey _key = GlobalKey();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // final state = _key.currentState as _CoInvestFinalPageState?;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initInvestState();
  }

  final List<Widget> paymentpages = [
    const CoInvestModal(),
    PickPaymentOption(
      type: "coinvest",
    ),
    EnterPinPrePurchase(type: "invest"),
    const DisplayWalletBalance(),
    SuccesInvest(),
  ];

  Future<void> _showBottomSheet(BuildContext context) async {
    var res = await showModalBottomSheet(
      isScrollControlled: _payment_page == 2 || _payment_page == 0,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return paymentpages[_payment_page];
      },
    );

    if (res != null) {
      Provider.of<PaymentProvider>(context, listen: false)
          .setPaymentOption(res);

      if (res == "paystack" || res == "wallet") {
        setState(() {
          _payment_page = 2;
        });
      } else if (res == "success") {
        print(2);
        setState(() {
          _payment_page = 4;
        });
      } else if (res == "wallet_pre") {
        print(2);
        setState(() {
          _payment_page = 3;
        });
      } else if (res == "restart") {
        setState(() {
          _payment_page = 0;
        });
      } else if (res == "pick_payment_option") {
        setState(() {
          _payment_page = 1;
        });
      } else {
        return;
      }

      _showBottomSheet(context);
    }
  }

  void _initInvestState() {
    setState(() {
      // _friendToGift =
      //     Provider.of<PropertyProvider>(context, listen: false).friendAsGift;
      _coInvestors =
          Provider.of<PropertyProvider>(context, listen: false).coInvestors;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Property property =
        ModalRoute.of(context)!.settings.arguments as Property;

    final String mdateProperty = DateFormat('dd MMMM, yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(property.maturitydate));

    NumberFormat formatter =
        NumberFormat.currency(locale: 'en_US', symbol: '${property.currency} ');

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: MyColors.primaryDark,
          ),
        ),
        title: Text(
          "Co Invest",
          style: TextStyle(
            color: MyColors.primaryDark,
            fontWeight: FontWeight.w600,
            fontFamily: "Inter",
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * .85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    // height: MediaQuery.of(context).size.height * .5,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    // color: Colors.green,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "How many units will you like to buy?",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: MyColors.primaryDark,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Quantity",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w400,
                                  color: MyColors.neutral,
                                  fontSize: 16,
                                ),
                              ),
                              NumberChanger(
                                number: _number,
                                increase: () {
                                  if (_number >=
                                      int.parse('${property.availableUnit}')) {
                                    showErrorDialog(
                                        "There are only ${property.availableUnit} units left",
                                        context);
                                  } else {
                                    setState(() {
                                      _number = _number + 1;
                                    });
                                  }
                                },
                                decrease: () {
                                  setState(() {
                                    if (_number <= 1) return;
                                    _number = _number - 1;
                                  });
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Conversion",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w400,
                                  color: MyColors.neutral,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "1 Plot",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w800,
                                  color: MyColors.neutral,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Divider(),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Measurements",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w400,
                                  color: MyColors.neutral,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "2,500 sqr/m",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w800,
                                  color: MyColors.neutral,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Divider(),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Price",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w400,
                                  color: MyColors.neutral,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${formatter.format(property.pricePerUnit * _number)}",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w800,
                                  color: MyColors.neutralblack,
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Divider(),
                          SizedBox(
                            height: 15,
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "images/Info2.svg",
                                height: 20,
                              ),
                              SizedBox(
                                width: 9,
                              ),
                              Text(
                                "Maturity date for this investment is ",
                                style: TextStyle(
                                  color: MyColors.neutral,
                                  fontFamily: "Inter",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "${mdateProperty}",
                                style: TextStyle(
                                  color: MyColors.primary,
                                  fontFamily: "Inter",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          if (_coInvestors.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Co Investors",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: MyColors.secondary,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Wrap(
                                      alignment: WrapAlignment.start,
                                      children: _coInvestors
                                          .map((User userstate) => Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SelectedUser(
                                                    onTap: () {
                                                      _coInvestors
                                                          .remove(userstate);
                                                      Provider.of<PropertyProvider>(
                                                              context,
                                                              listen: false)
                                                          .setCoInvestors(
                                                              _coInvestors);
                                                      setState(() {});
                                                    },
                                                    user: userstate),
                                              ))
                                          .toList()),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                        ]),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primary,
                      elevation: 0,
                    ),
                    onPressed: () {
                      Provider.of<PaymentProvider>(context, listen: false)
                          .setPropertyToPay(property, _number);
                      Provider.of<PropertyProvider>(context, listen: false)
                          .setCoInvestors(_coInvestors);
                      _showBottomSheet(context);
                    },
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
