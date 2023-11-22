import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/card.dart';
import 'package:propstock/models/colors.dart';
import 'package:flutter/services.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/providers/buy.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/dashboard.dart';
import 'package:propstock/screens/investments/investements.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class PickPaymentOption extends StatefulWidget {
  String? type;
  PickPaymentOption({super.key, this.type});

  @override
  State<PickPaymentOption> createState() => _PickPaymentOptionState();
}

class _PickPaymentOptionState extends State<PickPaymentOption> {
  bool _loading = true;
  List<CardModel> _cards = [];
  String paystackPublicKey = 'pk_test_143fd324876738add7122e3f4adf935c8e243812';
  final plugin = PaystackPlugin();
  Property? _property;
  int _quantity = 0;
  bool _processing = false;
  String? _email = "";
  double _userShare = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    plugin.initialize(publicKey: paystackPublicKey);
    _initPaymentoptions();
    _initPinManagement();
  }

  void _initPinManagement() {
    Property? propertyToPay =
        Provider.of<PaymentProvider>(context, listen: false).propertyToPay;
    int quantity =
        Provider.of<PaymentProvider>(context, listen: false).quantityOfProperty;
    double userShareInCoInvestment =
        Provider.of<PropertyProvider>(context, listen: false)
            .userShareInCoInvestment;
    String? email = Provider.of<Auth>(context, listen: false).email;

    setState(() {
      _property = propertyToPay;
      _quantity = quantity;
      _userShare = userShareInCoInvestment;
      _email = email;
    });
  }

  CardModel usableCard() {
    // if (_cards.isEmpty) return null;

    return _cards.firstWhere((card) => card.isDefault);
  }

  Future<void> makePayment() async {
    int price = _userShare <= 0
        ? (_property!.pricePerUnit * _quantity).ceil()
        : (_userShare).ceil();
    price = price * 100;
    Charge charge = Charge()
      ..amount = price
      // ..card = PaymentCard(number: number, cvc: cvc, expiryMonth: expiryMonth, expiryYear: expiryYear)
      ..reference = "ref_${DateTime.now()}_debalini"
      ..email = _email
      ..currency = "NGN";

    List<User> _coInvestors =
        Provider.of<PropertyProvider>(context, listen: false).coInvestors;
    User? friendAsGift =
        Provider.of<PropertyProvider>(context, listen: false).friendAsGift;

    try {
      setState(() {
        _processing = true;
      });
      final String accesscode =
          await Provider.of<PropertyProvider>(context, listen: false)
              .initializePaystackPayment(_property, _quantity, _userShare,
                  _coInvestors, friendAsGift, widget.type);

      print(accesscode);

      // return;

      charge.accessCode = accesscode;

      CheckoutResponse response = await plugin.checkout(context,
          charge: charge, method: CheckoutMethod.selectable, fullscreen: true);

      if (response.status == true) {
        print("successsss");
        print(response.message);
        Provider.of<BuyPropertyProvider>(context, listen: false)
            .setPropertyPurchased(_property);
        Provider.of<PropertyProvider>(context, listen: false)
            .setCoInvestors([]);
        Provider.of<PropertyProvider>(context, listen: false)
            .setFriendAsGift(null);
        Provider.of<PropertyProvider>(context, listen: false)
            .setUserShareInCoInvestment(0);
        Provider.of<BuyPropertyProvider>(context, listen: false)
            .setJustBought(true);

        Navigator.pop(context, 'success');
        // Navigator.popUntil(context, (route) {
        //   return route.settings.name == Dashboard.id;
        // });
      } else {
        print(response.message);
      }
    } catch (e) {
      setState(() {
        _processing = false;
      });
      print(e);
      showErrorDialog("could not start paystack payment", context);
    } finally {
      setState(() {
        _processing = false;
      });
    }
  }

  Future<void> _initPaymentoptions() async {
    try {
      // get user cards

      await Provider.of<PaymentProvider>(context, listen: false)
          .fetchCustomerCard();

      setState(() {
        _cards = Provider.of<PaymentProvider>(context, listen: false).userCards;
      });
    } catch (e) {
      showErrorDialog(e.toString(), context);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  String cardLogoDetermine(type) {
    if (type == CardType.visa) {
      return CardModel.visaImage;
    }
    if (type == CardType.masterCard) {
      return CardModel.masterImage;
    }

    return CardModel.defaultCard;
  }

  Color cardColorDetermine(type) {
    if (type == CardType.visa) {
      return CardModel.visaColor;
    }
    if (type == CardType.masterCard) {
      return CardModel.normalColor;
    }

    return CardModel.normalColor;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading)
      return Container(height: 10, child: LinearProgressIndicator());

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: double.infinity,
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
      child: Column(children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                "images/close_icon.svg",
                height: 20,
              ),
            ),
            Expanded(
              child: Text(
                "Pick a Payment option",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MyColors.secondary,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 45,
        ),

        if (_processing) LinearProgressIndicator(),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Pay with Paystack",
              style: TextStyle(
                fontSize: 16,
                color: MyColors.neutralblack,
                fontWeight: FontWeight.w400,
                fontFamily: "Inter",
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_processing) return;
                makePayment();
                // Navigator.pop(context, "paystack");
                // PayWithPayStack()
                //     .now(
                //         context: context,
                //         secretKey:
                //             "sk_test_275794001fe445eeafe4434985fd233fcb166c2c",
                //         customerEmail: "popekabu@gmail.com",
                //         reference:
                //             DateTime.now().microsecondsSinceEpoch.toString() +
                //                 "3232",
                //         callbackUrl: "https://twitter.com",
                //         currency: "NGN",
                //         paymentChannel: ["mobile_money", "card"],
                //         amount: "20000",
                //         transactionCompleted: () {
                //           print("Transaction Successful^^^^^^^^^^^^");
                //         },
                //         transactionNotCompleted: () {
                //           print("Transaction Not Successful!");
                //         })
                //     .then((value) => Navigator.pop(context));
              },
              child: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: MyColors.neutralGrey,
                size: 27,
              ),
            )
          ],
        ),

        Divider(),

        SizedBox(
          height: 17,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Wallet Balance",
              style: TextStyle(
                fontSize: 16,
                color: MyColors.neutralblack,
                fontWeight: FontWeight.w400,
                fontFamily: "Inter",
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, "wallet_pre");
              },
              child: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: MyColors.neutralGrey,
                size: 27,
              ),
            )
          ],
        ),
        SizedBox(
          height: 17,
        ),
        Divider(),
        SizedBox(
          height: 17,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Text(
        //       "Crypto Payment",
        //       style: TextStyle(
        //         fontSize: 16,
        //         color: MyColors.neutralblack,
        //         fontWeight: FontWeight.w400,
        //         fontFamily: "Inter",
        //       ),
        //     ),
        //     Icon(
        //       Icons.keyboard_arrow_right_rounded,
        //       size: 27,
        //       color: MyColors.neutralGrey,
        //     )
        //   ],
        // ),
        // SizedBox(
        //   height: 17,
        // ),
        // Divider(),
      ]),
    );
  }
}
