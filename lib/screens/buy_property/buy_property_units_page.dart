import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/buy_property/send_property_as_gifts.dart';
import 'package:propstock/screens/buy_property/success_buy.dart';
import 'package:propstock/screens/invest/send_investment_as_gifts.dart';
import 'package:propstock/screens/payments/display_wallet_balance.dart';
import 'package:propstock/screens/payments/enter_pin_pre_purchase.dart';
import 'package:propstock/screens/payments/pick_payment_option.payment_page.dart';
import 'package:propstock/utils/showErrorDialog.dart';
// import 'package:propstock/screens/single_person_investment/display_wallet_balance.dart';
// import 'package:propstock/screens/single_person_investment/enter_pin_pre_purchase.dart';
// import 'package:propstock/screens/single_person_investment/pick_payment_option.payment_page.dart';
import 'package:propstock/widgets/number_changer.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class BuyPropertyUnitsPage extends StatefulWidget {
  final Property? property;
  const BuyPropertyUnitsPage({super.key, this.property});
  static const id = "BuyPropertyUnitsPage";
  @override
  State<BuyPropertyUnitsPage> createState() => _BuyPropertyUnitsPageState();
}

enum PaymentPages {
  pickPaymentOption,
  enterPinPrePurchase,
  displayWalletBalance,
}

class _BuyPropertyUnitsPageState extends State<BuyPropertyUnitsPage> {
  int _number = 1;
  User? _friendToGift;
  int _payment_page = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchFriendForGift();
  }

  final List<Widget> paymentpages = [
    PickPaymentOption(type: "buy"),
    EnterPinPrePurchase(type: "buy"),
    const DisplayWalletBalance(),
    SuccessBuy(),
  ];

  Future<void> _showBottomSheet(BuildContext context) async {
    var res = await showModalBottomSheet(
      isScrollControlled: _payment_page == 1,
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
          _payment_page = 1;
        });
      } else if (res == "wallet_pre") {
        print(2);
        setState(() {
          _payment_page = 2;
        });
      } else if (res == "restart") {
        setState(() {
          _payment_page = 0;
        });
      } else if (res == "success") {
        setState(() {
          _payment_page = 3;
        });
      } else {
        return;
      }

      _showBottomSheet(context);
    }
  }

  void _fetchFriendForGift() {
    setState(() {
      _friendToGift =
          Provider.of<PropertyProvider>(context, listen: false).friendAsGift;
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
          "Buy",
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
                            "${property.name}",
                            style: TextStyle(
                              color: MyColors.primaryDark,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Inter",
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // if (property.propertyType == "Land") Divider(),
                          if (property.propertyType == "Land")
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Plots",
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
                                        int.parse('${property.plotNumber}')) {
                                      showErrorDialog(
                                          "There are only ${property.plotNumber} plots left",
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
                          // Divider(),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Size",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w400,
                                  color: MyColors.neutral,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${property.plotNumber} Plot",
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
                                property.landSize != null
                                    ? "${property.landSize}"
                                    : "2,500 sqr/m",
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
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: [
                              SvgPicture.asset(
                                "images/Info2.svg",
                                height: 20,
                              ),
                              SizedBox(
                                width: 9,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "For further inquiry on this property please feel free to ",
                                    style: TextStyle(
                                      color: MyColors.neutral,
                                      fontFamily: "Inter",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "contact us",
                                    style: TextStyle(
                                      color: MyColors.primary,
                                      fontFamily: "Inter",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          if (_friendToGift == null)
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                        context, SendPropertyAsGift.id)
                                    .then(
                                  (value) => _fetchFriendForGift(),
                                );
                              },
                              child: Text(
                                "Send this property as a gift?",
                                style: TextStyle(
                                  color: MyColors.primary,
                                  fontFamily: "Inter",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          if (_friendToGift != null)
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Recipient",
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
                                Stack(children: [
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Color(0xffeeeeee),
                                    child: Icon(
                                      Icons.person_2,
                                      color: Color(0xffbbbbbb),
                                    ),
                                  ),
                                  Positioned(
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          _friendToGift = null;
                                          Provider.of<PropertyProvider>(context,
                                                  listen: false)
                                              .setFriendAsGift(null);
                                        },
                                        child: Container(
                                            height: 17.14,
                                            width: 17.14,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: Colors.black26,
                                                shape: BoxShape.circle),
                                            child: Icon(
                                              Icons.close,
                                              size: 13,
                                              color: Colors.white,
                                            )),
                                      ))
                                ]),
                                Text(
                                  "${_friendToGift?.firstName} ",
                                  style: TextStyle(
                                    color: MyColors.neutralblack,
                                    fontFamily: "Inter",
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "${_friendToGift?.lastName} ",
                                  style: TextStyle(
                                    color: MyColors.neutralblack,
                                    fontFamily: "Inter",
                                    fontSize: 12,
                                  ),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: PropStockButton(
                    text:
                        "Pay ${formatter.format(property.pricePerUnit * _number)}",
                    disabled: false,
                    onPressed: () {
                      Provider.of<PaymentProvider>(context, listen: false)
                          .setPropertyToPay(property, _number);
                      Provider.of<PaymentProvider>(context, listen: false)
                          .setPropertyToPay(property, _number);
                      _showBottomSheet(context);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
