import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/screens/dashboard.dart';
// import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/invest/buy_units_invest_page.dart';
import 'package:propstock/screens/wallet/wallet.dart';
import 'package:propstock/utils/showErrorDialog.dart';

import 'package:propstock/widgets/text_input_formatter_cardnumber.dart';
import 'package:propstock/widgets/text_input_formatter_expirydate.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:provider/provider.dart';

class AddCard extends StatefulWidget {
  static const id = "add_card";
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  int? _month = 0;
  int? _year = 0;
  bool? valid = false;
  bool loading = false;

  TextEditingController _cardController = TextEditingController();
  TextEditingController _expiry_date_controller = TextEditingController();
  TextEditingController _cvvController = TextEditingController();

  FocusNode _cardNumberNode = FocusNode();
  FocusNode _expiry_date_node = FocusNode();
  FocusNode _cvv_node = FocusNode();
  bool _isDefault = false;

  Future<void> _saveCard(String page) async {
    try {
      setState(() {
        loading = true;
      });

      await Provider.of<PaymentProvider>(context, listen: false)
          .saveCustomerCard(_getCardFromUI(), _isDefault);
      // setState(() {
      //   // _accessCode = accessCode;
      // });

      _showBottomSheet(context, page);
    } catch (e) {
      print("Error: $e");
      showErrorDialog("Error saving card", context);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void _showBottomSheet(BuildContext context, String pageId) {
    showModalBottomSheet(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      context: context,
      builder: (BuildContext btx) {
        return Container(
          height: 300,
          child: Column(children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "Card Successfully Added",
              style: TextStyle(
                color: MyColors.secondary,
                fontFamily: "Inter",
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Image(
              image: AssetImage("images/success_circle_2.png"),
              height: 100,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: valid != true || loading
                        ? MyColors.neutralGrey
                        : MyColors.primary,
                    elevation: 0,
                  ),
                  onPressed: () {
                    // _showBottomSheet(btx);
                    // if (valid != true || loading) return;
                    // _saveCard();
                    if (pageId != BuyUnitsInvestPage.id) {
                      Navigator.pop(
                        context,
                      );
                      Navigator.pop(
                        context,
                      );
                    } else {
                      Navigator.popUntil(context, (route) {
                        return route.settings.name == pageId;
                      });
                    }
                  },
                  child: Text(
                    pageId == BuyUnitsInvestPage.id
                        ? "Back to Invest"
                        : "Back to Topup",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
            )
          ]),
        );
      },
    );
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.

    return PaymentCard(
      number: _cardController.text,
      cvc: _cvvController.text,
      expiryMonth: _month,
      expiryYear: _year,
    );
  }

  void _checkValidity() {
    try {
      PaymentCard card = _getCardFromUI();
      print(card);
      print(card.isValid());
      setState(() {
        valid = card.isValid();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String pageReturnID =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_sharp,
            color: MyColors.secondary,
          ),
        ),
        title: Text(""),
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height * .8,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Add a new card",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter",
                        fontSize: 24,
                        color: MyColors.secondary,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "The amount of N10.00 would charged from your account. This would be refunded immediately.",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: "Inter",
                        fontSize: 16,
                        color: MyColors.neutral,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextField(
                      controller: _cardController,
                      focusNode: _cardNumberNode,
                      onChanged: (String val) {
                        print(val);
                        _checkValidity();

                        // if (val.length == 19) {
                        //   _cardNumberNode.unfocus();
                        //   _expiry_date_node.requestFocus();
                        // }
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CardNumberInputFormatter(),
                      ],
                      decoration: InputDecoration(
                        // prefixStyle: TextStyle(

                        // ),
                        // prefixIconConstraints: BoxConstraints(),

                        prefixIcon: Icon(Icons.credit_card),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        label: Text('Card Number',
                            style: TextStyle(fontFamily: "Inter")),
                        hintStyle: TextStyle(color: Color(0xffbbbbbb)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: MyColors.fieldDefault,
                          ), // Use the hex color
                          borderRadius: BorderRadius.circular(
                              8), // You can adjust the border radius as needed
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: MyColors.fieldDefault,
                          ), // Use the hex color
                          borderRadius: BorderRadius.circular(
                              8), // You can adjust the border radius as needed
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .4,
                          height: 40,
                          // padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                          child: TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              MonthYearInputFormatter(),
                            ],
                            onChanged: (val) {
                              // card.validExpiryDate
                              _checkValidity();
                              if (val.length == 5) {
                                _expiry_date_node.unfocus();
                                _cvv_node.requestFocus();
                              }
                              print(val);

                              setState(() {
                                try {
                                  _month = int.parse(val.split("/")[0]);
                                  // print("Integer value: $intValue");
                                  _year = int.parse(val.split("/")[1]);
                                } catch (e) {
                                  print("Error: $e");
                                }
                              });
                            },
                            focusNode: _expiry_date_node,
                            controller: _expiry_date_controller,
                            decoration: InputDecoration(
                              // hintText: "Expiry Date",
                              label: Text(
                                'Expiry Date',
                                style: TextStyle(fontFamily: "Inter"),
                              ),

                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              hintStyle: TextStyle(color: Color(0xffbbbbbb)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: MyColors.fieldDefault,
                                ), // Use the hex color
                                borderRadius: BorderRadius.circular(
                                    8), // You can adjust the border radius as needed
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: MyColors.fieldDefault,
                                ), // Use the hex color
                                borderRadius: BorderRadius.circular(
                                    8), // You can adjust the border radius as needed
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * .4,
                          height: 40,
                          // padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                          child: TextField(
                            onChanged: (val) {
                              // card.validExpiryDate
                              _checkValidity();

                              if (val.length == 3) {
                                FocusScope.of(context).unfocus();
                              }
                            },
                            focusNode: _cvv_node,
                            controller: _cvvController,
                            decoration: InputDecoration(
                              // hintText: "Expiry Date",
                              label: Text(
                                'CVV ',
                                style: TextStyle(fontFamily: "Inter"),
                              ),

                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              hintStyle: TextStyle(color: Color(0xffbbbbbb)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: MyColors.fieldDefault,
                                ), // Use the hex color
                                borderRadius: BorderRadius.circular(
                                    8), // You can adjust the border radius as needed
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: MyColors.fieldDefault,
                                ), // Use the hex color
                                borderRadius: BorderRadius.circular(
                                    8), // You can adjust the border radius as needed
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _isDefault,
                          onChanged: (newValue) {
                            setState(() {
                              _isDefault = newValue ?? false;
                            });
                          },
                        ),
                        Text("Make this my default card",
                            style: TextStyle(
                              color: MyColors.neutralGrey,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ))
                      ],
                    )
                  ],
                ),
              ),
              if (loading) LinearProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                // padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: valid != true || loading
                          ? MyColors.neutralGrey
                          : MyColors.primary,
                      elevation: 0,
                    ),
                    onPressed: () {
                      // _showBottomSheet(context);
                      if (valid != true || loading) return;
                      _saveCard(pageReturnID);
                      // _showBottomSheet(context, "efd");
                    },
                    child: Text(
                      "Add Card",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              )
            ],
          ),
        ),
      )),
    );
  }
}
