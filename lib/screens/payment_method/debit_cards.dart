import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/card.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/screens/payment_method/single_debit_card.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

class DebitCardsProfile extends StatefulWidget {
  static const id = "DebitCardsProfile";
  const DebitCardsProfile({super.key});

  @override
  State<DebitCardsProfile> createState() => _DebitCardsProfileState();
}

class _DebitCardsProfileState extends State<DebitCardsProfile> {
  bool loading = true;
  final plugin = PaystackPlugin();
  String paystackPublicKey = 'pk_test_143fd324876738add7122e3f4adf935c8e243812';

  List<CardModel> _customerCards = [];
  @override
  void initState() {
    // TODO: implement initState

    _findUserDebitCards();
    plugin.initialize(publicKey: paystackPublicKey);

    super.initState();
  }

  // bool disabledFunc() {
  //   return false;
  // }

  Future<void> makePayment() async {
    // price = price * 100;
    Charge charge = Charge()
      ..amount = 1000
      // ..card = PaymentCard(number: number, cvc: cvc, expiryMonth: expiryMonth, expiryYear: expiryYear)
      ..reference = "ref_${DateTime.now()}_debalini"
      ..email = Provider.of<Auth>(context, listen: false).email
      ..currency = "NGN";

    try {
      setState(() {
        loading = true;
      });
      final String accesscode =
          await Provider.of<PaymentProvider>(context, listen: false)
              .initializePaystackPayment(1000);

      print(accesscode);

      // return;

      charge.accessCode = accesscode;

      CheckoutResponse response = await plugin.checkout(context,
          charge: charge, method: CheckoutMethod.card, fullscreen: false);

      if (response.status == true) {
        _findUserDebitCards();
        //   print("successsss");
        //   print(response.message);
        //   Provider.of<BuyPropertyProvider>(context, listen: false)
        //       .setPropertyPurchased(_property);
        //   Provider.of<PropertyProvider>(context, listen: false)
        //       .setCoInvestors([]);
        //   Provider.of<PropertyProvider>(context, listen: false)
        //       .setFriendAsGift(null);
        //   Provider.of<PropertyProvider>(context, listen: false)
        //       .setUserShareInCoInvestment(0);
        //   Provider.of<BuyPropertyProvider>(context, listen: false)
        //       .setJustBought(true);

        //   Navigator.pop(context, 'success');
        // Navigator.popUntil(context, (route) {
        //   return route.settings.name == Dashboard.id;
        // });
      } else {
        print(response.message);
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e);
      showErrorDialog("could not start paystack payment", context);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Color cardColorDetermine(type) {
    if (type.toString().trim() == CardType.visa.toLowerCase().toString()) {
      return CardModel.visaColor;
    }
    if (type == CardType.masterCard) {
      return CardModel.normalColor;
    }

    return CardModel.normalColor;
  }

  String cardLogoDetermine(type) {
    // print(type);
    // print("lower cased ${CardType.visa.toLowerCase()}");
    // print(type == CardType.visa.toLowerCase());
    if (type.toLowerCase().trim() == CardType.visa.toLowerCase().toString()) {
      // print("returning visa");
      return CardModel.visaImage;
    }
    if (type.toLowerCase().trim() ==
        CardType.masterCard.toLowerCase().toString()) {
      return CardModel.masterImage;
    }

    return CardModel.defaultCard;
  }

  Future<void> _findUserDebitCards() async {
    try {
      List<CardModel> customerCards =
          await Provider.of<PaymentProvider>(context, listen: false)
              .fetchCustomerCard();

      print(customerCards![0]);

      setState(() {
        _customerCards = customerCards;
      });
    } catch (e) {
      showErrorDialog(e.toString(), context);
    } finally {
      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xff1D3354),
          ),
          onPressed: () {
            // Navigate back to the previous screen when the back button is pressed
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Debit Cards",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff1D3354),
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                if (loading) LinearProgressIndicator(),

                Expanded(
                  child: ListView.builder(
                      itemCount: _customerCards.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        CardModel card = _customerCards[index];

                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                        context, SingleDebitCardProfile.id,
                                        arguments: card)
                                    .then((value) {
                                  setState(() {
                                    loading = true;
                                  });
                                  _findUserDebitCards();
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: card.isDefault
                                            ? MyColors.primary
                                            : Color(0xffCBDFF7)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: ListTile(
                                    leading: Container(
                                      decoration: BoxDecoration(
                                        color: cardColorDetermine(card.type),
                                      ),
                                      child: Image.memory(
                                        Uint8List.fromList(base64Decode(
                                            cardLogoDetermine(card.type))),
                                        // fit: BoxFit.fill, // You can customize the Box
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0xff303030),
                                    ),
                                    title: Text(
                                      "${card.type}****${card.last4digits}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Inter",
                                        color: Color(0xff1D3354),
                                      ),
                                    )),
                              ),
                            ),
                            if (index == _customerCards.length - 1)
                              GestureDetector(
                                onTap: () {
                                  makePayment();
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xffCBDFF7)),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: ListTile(
                                      leading: Icon(
                                        Icons.add,
                                        color: Colors.black,
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Color(0xff303030),
                                      ),
                                      title: Text(
                                        "Add a new payment method",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Inter",
                                            color: Color(0xff1D3354)),
                                      )),
                                ),
                              ),
                          ],
                        );
                      }),
                ),

                // SizedBox(
                //   height: 20,
                // ),
                // Container(
                //   margin: const EdgeInsets.symmetric(horizontal: 20),
                //   decoration: BoxDecoration(
                //       border: Border.all(color: const Color(0xffCBDFF7)),
                //       borderRadius: BorderRadius.all(Radius.circular(8))),
                //   child: ListTile(
                //       leading: SvgPicture.asset("images/CreditCardc.svg"),
                //       trailing: Icon(
                //         Icons.arrow_forward_ios_rounded,
                //         color: Color(0xff303030),
                //       ),
                //       title: const Text(
                //         "Debit cards",
                //         style: TextStyle(color: Color(0xff1D3354)),
                //       )),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
