import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/card.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class SingleDebitCardProfile extends StatefulWidget {
  const SingleDebitCardProfile({super.key});
  static const id = "SingleDebitCardProfile";

  @override
  State<SingleDebitCardProfile> createState() => _SingleDebitCardProfileState();
}

class _SingleDebitCardProfileState extends State<SingleDebitCardProfile> {
  bool loading = false;
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

  Future<void> _deleteCard(CardModel card) async {
    try {
      setState(() {
        loading = true;
      });
      await Provider.of<PaymentProvider>(context, listen: false)
          .deleteCard(card);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete Card successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      showErrorDialog(e.toString(), context);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final CardModel card =
        ModalRoute.of(context)!.settings.arguments as CardModel;
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
      body: Stack(
        children: [
          SingleChildScrollView(
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
                height: 40,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Stack(
                      // clipBehavior: Clip.none,
                      children: [
                        Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: SvgPicture.asset(
                                "images/rectangleundermap.svg")),
                        Image.asset("images/map.png"),
                        Positioned(
                          top: 85,
                          left: 30,
                          child: Image.asset("images/goldcardb.png"),
                        ),
                        Positioned(
                          top: 145,
                          left: 30,
                          child: Text(
                            "XXXX XXXX XXXX ${card.last4digits}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "Inter",
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 185,
                          left: 30,
                          child: Text(
                            "Exp. ${card.expiry}",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontFamily: "Inter",
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 25,
                          left: 30,
                          child: Text(
                            "${Provider.of<Auth>(context, listen: false).firstname} ${Provider.of<Auth>(context, listen: false).lastname}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "Inter",
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 25,
                          right: 30,
                          child: Text(
                            "${card.bank}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "Inter",
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 35,
                          right: 30,
                          child: Image.memory(Uint8List.fromList(
                              base64Decode(cardLogoDetermine(card.type)))),
                        ),
                        // SvgPicture.asset("images/goldcard.svg"),
                        // Text("")
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListTile(
                  title: Text(
                    "Make this your default card",
                    style: TextStyle(
                      color: Color(0xff5E6D85),
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: CupertinoSwitch(
                    onChanged: (bool value) async {
                      setState(() {
                        card.isDefault = true;
                      });

                      try {
                        await Provider.of<PaymentProvider>(context,
                                listen: false)
                            .setCardAsDefault(card);
                      } catch (e) {
                        showErrorDialog(e.toString(), context);
                        setState(() {
                          card.isDefault = !value;
                        });
                      }
                    },
                    value: card.isDefault,
                  ),
                ),
              ),
              // Expanded(
              //     child: SizedBox(
              //   height: 10,
              // ))
              // if (loading) LinearProgressIndicator(),
            ],
          )),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (loading)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: LinearProgressIndicator(),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: PropStockButton(
                    text: "DELETE CARD",
                    disabled: false,
                    onPressed: () => _deleteCard(card)),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ],
      ),
    );
  }
}
