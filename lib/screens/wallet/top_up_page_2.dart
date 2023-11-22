import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/card.dart';
import 'package:propstock/models/colors.dart';
import 'package:flutter/services.dart';
// import 'package:propstock/models/property.dart';
import 'package:propstock/models/wallet.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/providers/portfolio.dart';

// import 'package:propstock/screens/payment_card/add_card.dart';
import 'package:propstock/screens/wallet/card_component.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class TopUpPage2 extends StatefulWidget {
  const TopUpPage2({super.key});

  @override
  State<TopUpPage2> createState() => _TopUpPage2State();
}

class _TopUpPage2State extends State<TopUpPage2> {
  bool _loading = false;
  List<CardModel> _cards = [];
  String paystackPublicKey = 'pk_test_143fd324876738add7122e3f4adf935c8e243812';
  final plugin = PaystackPlugin();
  Wallet? _wallet;
  bool _processing = false;
  String? _email = "";
  // double _userShare = 0;
  double _topuppayment = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    plugin.initialize(publicKey: paystackPublicKey);
    _initPaymentoptions();
    // _initPickOptions();
  }

  // void _initPickOptions() {}

  CardModel usableCard() {
    // if (_cards.isEmpty) return null;

    return _cards.firstWhere((card) => card.isDefault);
  }

  Future<void> makePayment(CardModel? _paymentcard,
      {double? temporarychargePrice}) async {
    print(temporarychargePrice);
    print("temp price");
    int price = _topuppayment.ceil();
    price = price * 100;
    setState(() {
      _processing = true;
    });
    if (temporarychargePrice == null) {
      Charge charge = Charge()
        ..amount = price
        ..reference = "ref_${DateTime.now()}_debalini"
        ..email = _email
        ..currency = "NGN";

      try {
        final String accesscode =
            await Provider.of<PaymentProvider>(context, listen: false)
                .initializePaystackPayment(price);

        print(accesscode);

        // return;

        charge.accessCode = accesscode;

        CheckoutResponse response = await plugin.checkout(context,
            charge: charge,
            method: CheckoutMethod.selectable,
            fullscreen: true);

        if (response.status == true) {
          print(response.message);
          Navigator.pop(context, 'success');
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
    } else {
      print("temp time");
      Charge charge = Charge()
        ..amount = double.parse("$temporarychargePrice").ceil()
        ..reference = "ref_${DateTime.now()}_debalini"
        ..email = _email
        ..currency = "NGN";

      final String accesscode =
          await Provider.of<PaymentProvider>(context, listen: false)
              .initializePaystackPayment(
                  double.parse("$temporarychargePrice").ceil(),
                  verify: true);

      print(accesscode);

      // return;

      charge.accessCode = accesscode;

      try {
        CheckoutResponse response = await plugin.checkout(
          context,
          charge: charge,
          fullscreen: true,
        );
        print(111);
        print(response);
        if (response.status == true) {
          print(response.message);
          _initPaymentoptions();
          // Navigator.pop(context);
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
  }

  Future<void> _initPaymentoptions() async {
    try {
      // get user cards
      await Provider.of<PaymentProvider>(context, listen: false)
          .fetchCustomerCard();
      _wallet =
          Provider.of<PortfolioProvider>(context, listen: false).selectedWallet;

      setState(() {
        _cards = Provider.of<PaymentProvider>(context, listen: false).userCards;

        _email = Provider.of<Auth>(context, listen: false).email;
        _topuppayment =
            Provider.of<PaymentProvider>(context, listen: false).topuppayment;
      });
    } catch (e) {
      print(e);
      // showErrorDialog(e.toString(), context);
    } finally {
      // setState(() {
      //   _loading = false;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading)
      return Container(height: 10, child: LinearProgressIndicator());

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: MediaQuery.of(context).size.height * .6,
      // decoration: const BoxDecoration(),
      child: Column(children: [
        const SizedBox(
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
                "How would you like to Top Up?",
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
        const SizedBox(
          height: 45,
        ),
        if (_processing) const LinearProgressIndicator(),
        if (_cards.isEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Card",
                style: TextStyle(
                  fontSize: 16,
                  color: MyColors.neutralblack,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Inter",
                ),
              ),
              GestureDetector(
                onTap: () {
                  //
                  // Navigator.pop(context, "switch_cards");
                  // Navigator.pushNamed(context, AddCard.id, arguments: "top_up");
                  print("adding card");
                  makePayment(null, temporarychargePrice: 1000);
                },
                child: Text(
                  "Add card",
                  style: TextStyle(
                    fontFamily: "Inter",
                    color: MyColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
        if (_cards.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () async {
                    // //
                    // if (_processing) return;
                    // // makePayment(usableCard());
                    // setState(() {
                    //   _processing = true;
                    // });
                    // try {
                    //   int price = _topuppayment.ceil();
                    //   // price = price * 100;
                    //   await Provider.of<PaymentProvider>(context, listen: false)
                    //       .chargeAlreadyKnownCard(usableCard(), price);
                    // } catch (e) {
                    //   showErrorDialog(e.toString(), context);
                    // } finally {
                    //   setState(() {
                    //     _processing = false;
                    //   });
                    // }
                    Navigator.pop(context, "wallet_pin_top_up");
                    Provider.of<PaymentProvider>(context, listen: false)
                        .setSelectedCard(usableCard());
                  },
                  child: CardComponent(card: usableCard())),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      //
                      Navigator.pop(context, "switch_cards");
                    },
                    child: Text(
                      "Switch",
                      style: TextStyle(
                        fontFamily: "Inter",
                        color: MyColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_processing) return;
                      makePayment(usableCard());
                    },
                    child: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: MyColors.neutralGrey,
                      size: 27,
                    ),
                  ),
                ],
              )
            ],
          ),
        const Divider(),
        const SizedBox(
          height: 17,
        ),
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
                makePayment(null);
              },
              child: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: MyColors.neutralGrey,
                size: 27,
              ),
            )
          ],
        ),
        const Divider(),
        const SizedBox(
          height: 17,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Investments",
              style: TextStyle(
                fontSize: 16,
                color: MyColors.neutralblack,
                fontWeight: FontWeight.w400,
                fontFamily: "Inter",
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, "top_up_via_investments");
              },
              child: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: MyColors.neutralGrey,
                size: 27,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 17,
        ),
        const Divider(),
        const SizedBox(
          height: 17,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "USSD",
              style: TextStyle(
                fontSize: 16,
                color: MyColors.neutralblack,
                fontWeight: FontWeight.w400,
                fontFamily: "Inter",
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, "top_up_via_ussd");
              },
              child: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: MyColors.neutralGrey,
                size: 27,
              ),
            )
          ],
        ),
      ]),
    );
  }
}
