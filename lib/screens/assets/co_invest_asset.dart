import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/providers/assets.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/assets/co_invest_modal_asset.dart';
import 'package:propstock/screens/invest/co_invest_modal.dart';
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

class CoInvestFinalPageAsset extends StatefulWidget {
  final Property? property;
  const CoInvestFinalPageAsset({super.key, this.property});
  static const id = "CoInvestFinalPageAsset";
  @override
  State<CoInvestFinalPageAsset> createState() => _CoInvestFinalPageAssetState();
}

enum PaymentPages {
  pickPaymentOption,
  enterPinPrePurchase,
  displayWalletBalance,
}

class _CoInvestFinalPageAssetState extends State<CoInvestFinalPageAsset> {
  int _number = 1;
  // User? _friendToGift;
  bool loading = true;
  int _payment_page = 0;
  bool isFinalPayment = false;
  List<User> _coInvestors = [];

  final GlobalKey _key = GlobalKey();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // final state = _key.currentState as _CoInvestFinalPageAssetState?;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initInvestState();
  }

  final List<Widget> paymentpages = [
    const CoInvestModalAsset(),
    PickPaymentOption(
      type: "coinvest",
    ),
    EnterPinPrePurchase(type: "invest"),
    const DisplayWalletBalance()
  ];

  Future<String> fetchUserData(User user, String? investmentId) async {
    String percentage = "";
    try {
      String percentageb =
          await Provider.of<AssetsProvider>(context, listen: false)
              .findCoInvestPercentage(user, investmentId);

      percentage = percentageb;
    } catch (e) {
      showErrorDialog("Cannot get percentage", context);
    }

    return percentage;
  }

  Future<String> getifuserisfinalusertopay(String? investmentId) async {
    String isFinalPaymentb = "";
    try {
      setState(() {
        loading = true;
      });
      bool isFinalPaymentb =
          await Provider.of<AssetsProvider>(context, listen: false)
              .getifuserisfinalusertopay(investmentId);

      isFinalPayment = isFinalPaymentb;
    } catch (e) {
      showErrorDialog("Cannot get final state", context);
    } finally {
      setState(() {
        loading = false;
      });
    }

    return isFinalPaymentb;
  }

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

    print("this is what res is equal to $res");
    if (res != null) {
      Provider.of<PaymentProvider>(context, listen: false)
          .setPaymentOption(res);

      if (res == "paystack" || res == "wallet") {
        setState(() {
          _payment_page = 2;
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
      } else if (res == "success") {
        print("successfully popping!!! at co invest asset");
        Navigator.pop(context, 'success');
        return;
      } else {
        return;
      }
      if (res != "success") {
        _showBottomSheet(context);
      }
    }
  }

  void _initInvestState() {
    setState(() {
      // _friendToGift =
      //     Provider.of<PropertyProvider>(context, listen: false).friendAsGift;
      _coInvestors =
          Provider.of<PropertyProvider>(context, listen: false).coInvestors;
    });
    getifuserisfinalusertopay(
        Provider.of<PropertyProvider>(context, listen: false)
            .selectedInvestmentId);
  }

  @override
  Widget build(BuildContext context) {
    final dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    final Property property = arguments['property'] as Property;
    final List<User> coInvestors = arguments['coInvestors'] as List<User>;
    final double amountPaid = arguments['amountPaid'] as double;
    final double amountremaining = arguments['amountremaining'] as double;
    final int quantity = arguments['quantity'] as int;
    final String investment_id = arguments['investment_id'] as String;

    print("this is the investment id: $investment_id");

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
              if (loading) LinearProgressIndicator(),
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
                            "Make Payment for this investment",
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
                                number: quantity,
                                increase: () {
                                  // if (_number >=
                                  //     int.parse('${property.availableUnit}')) {
                                  //   showErrorDialog(
                                  //       "There are only ${property.availableUnit} units left",
                                  //       context);
                                  // } else {
                                  //   setState(() {
                                  //     _number = _number + 1;
                                  //   });
                                  // }
                                },
                                decrease: () {
                                  // setState(() {
                                  //   if (_number <= 1) return;
                                  //   _number = _number - 1;
                                  // });
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
                                property.propertyType.toLowerCase() == "land"
                                    ? "1 Plot"
                                    : "1 unit",
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
                                "Sub total",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w400,
                                  color: MyColors.neutral,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${formatter.format(property.pricePerUnit * quantity)}",
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
                                "Amount Paid",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w400,
                                  color: MyColors.neutral,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${formatter.format(amountPaid)}",
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
                          if (property.propertyType.toLowerCase() == "land")
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                              ],
                            ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w400,
                                  color: MyColors.neutral,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${formatter.format(amountremaining)}",
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
                          if (coInvestors!.isNotEmpty)
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
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * .4,
                                  child: ListView.builder(
                                      itemCount: coInvestors.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext ctx, int index) {
                                        User coinv = coInvestors[index];
                                        return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  "${coinv.avatar}")),
                                          title: Text(coinv.firstName),
                                          trailing: FutureBuilder<String>(
                                            future: fetchUserData(
                                                coinv, investment_id),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String>
                                                    snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                  'Error: ${snapshot.error}',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                );
                                              } else if (snapshot.hasData) {
                                                return Text(
                                                  "${snapshot.data!}%",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Inter",
                                                    color: MyColors.primary,
                                                  ),
                                                );
                                              } else {
                                                return Text('No data found');
                                              }
                                            },
                                          ),
                                        );
                                      }),
                                )
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(
                                //       vertical: 10.0),
                                //   child: Wrap(
                                //       alignment: WrapAlignment.start,
                                //       children: coInvestors
                                //           .map((User userstate) => Padding(
                                //                 padding:
                                //                     const EdgeInsets.all(8.0),
                                //                 child: SelectedUser(
                                //                     onTap: () {
                                //                       coInvestors
                                //                           .remove(userstate);
                                //                       Provider.of<PropertyProvider>(
                                //                               context,
                                //                               listen: false)
                                //                           .setCoInvestors(
                                //                               coInvestors);
                                //                       setState(() {});
                                //                     },
                                //                     user: userstate),
                                //               ))
                                //           .toList()),
                                // ),
                                // SizedBox(
                                //   height: 20,
                                // ),
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
                          .setPropertyToPay(property, quantity);
                      Provider.of<PropertyProvider>(context, listen: false)
                          .setCoInvestors(coInvestors);
                      Provider.of<AssetsProvider>(context, listen: false)
                          .setAmountToBePaid(amountremaining);
                      Provider.of<AssetsProvider>(context, listen: false)
                          .setIsFinalPayment(isFinalPayment);
                      Provider.of<PropertyProvider>(context, listen: false)
                          .selectedInvestmentId = investment_id;
                      // Provider.of<PropertyProvider>(context, listen: false)
                      //     .isFinalCoinvestor = investment_id;

                      _showBottomSheet(context);
                    },
                    child: Text(
                      "PAY",
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
