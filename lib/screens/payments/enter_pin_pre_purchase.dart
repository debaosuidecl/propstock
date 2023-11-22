import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/dashboard.dart';
import 'package:propstock/screens/investments/investements.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class EnterPinPrePurchase extends StatefulWidget {
  String type;
  EnterPinPrePurchase({
    super.key,
    required this.type,
  });

  @override
  State<EnterPinPrePurchase> createState() => _EnterPinPrePurchaseState();
}

class _EnterPinPrePurchaseState extends State<EnterPinPrePurchase> {
  Property? _property;
  bool loading = false;
  int _quantity = 0;
  bool _success = false;

  FocusNode _focusNode = FocusNode();
  double _userShare = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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

    setState(() {
      _property = propertyToPay;
      _quantity = quantity;
      _userShare = userShareInCoInvestment;
    });
  }

  TextEditingController _pinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat.currency(
        locale: 'en_US', symbol: "${_property!.currency} ");
    final defaultPinTheme = PinTheme(
      width: 67,
      height: 77,
      padding: const EdgeInsets.only(bottom: 15),
      textStyle: TextStyle(
          fontSize: 25,
          color: Colors.black,
          fontWeight: FontWeight.w300,
          fontFamily: "Inter"),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffbbbbbb))),
        color: Colors.transparent,
        // borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border(bottom: BorderSide(color: Color(0xff222222))),
      // borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border(bottom: BorderSide(color: Color(0xff222222))),
        // color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration
          ?.copyWith(border: Border(bottom: BorderSide(color: Colors.red))),
      // color: Color.fromRGBO(234, 239, 243, 1),
    );
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      // Calculate available screen height
      double screenHeight = constraints.maxHeight;

      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            height: _focusNode.hasFocus
                ? screenHeight
                : MediaQuery.of(context).size.height * .7,
            child: _success
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Text(
                          "Payment Successful",
                          style: TextStyle(
                            color: MyColors.secondary,
                            fontFamily: "Inter",
                            fontSize: 26,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Image(
                          image: AssetImage("images/successcircle.png"),
                          height: 150,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "You can find your investments in your assets ",
                          style: TextStyle(
                            color: MyColors.neutralGrey,
                            fontFamily: "Inter",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MyColors.primary,
                                elevation: 0,
                              ),
                              onPressed: () async {
                                // _showBottomSheet(context);
                                print("going to investments");
                                Navigator.pushNamedAndRemoveUntil(
                                    context, Investments.id, (route) {
                                  return route.settings.name == Dashboard.id;
                                });
                              },
                              child: Text(
                                "View Investment",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                        )
                      ],
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context, "restart");
                            },
                            child: Icon(
                              Icons.arrow_back_ios_new_outlined,
                              color: MyColors.neutralGrey,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            "Input your PIN",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: MyColors.secondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                fontFamily: "Inter"),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Enter your four digit transaction PIN to complete your card payment",
                        style: TextStyle(
                          color: MyColors.neutralGrey,
                          fontSize: 16,
                          fontFamily: "Inter",
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Pinput(
                          onChanged: (String val) {},
                          focusNode: _focusNode,
                          defaultPinTheme: defaultPinTheme,
                          obscureText: true,
                          controller: _pinController,
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          errorPinTheme: errorPinTheme,
                          length: 4,
                          pinputAutovalidateMode:
                              PinputAutovalidateMode.onSubmit,
                          showCursor: true,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      if (loading) LinearProgressIndicator(),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyColors.primary,
                              elevation: 0,
                            ),
                            onPressed: () async {
                              // _showBottomSheet(context);
                              try {
                                setState(() {
                                  loading = true;
                                });
                                User? friendAsGift =
                                    Provider.of<PropertyProvider>(context,
                                            listen: false)
                                        .friendAsGift;
                                List<User> _coInvestors =
                                    Provider.of<PropertyProvider>(context,
                                            listen: false)
                                        .coInvestors;
                                double _userShareInCoInvestment =
                                    Provider.of<PropertyProvider>(context,
                                            listen: false)
                                        .userShareInCoInvestment;

                                await Provider.of<PaymentProvider>(context,
                                        listen: false)
                                    .investInProperty(
                                  _property,
                                  _quantity,
                                  _pinController.text,
                                  friendAsGift,
                                  _coInvestors,
                                  _userShareInCoInvestment,
                                  widget.type,
                                );
                                Provider.of<PropertyProvider>(context,
                                        listen: false)
                                    .setFriendAsGift(null);
                                Provider.of<PropertyProvider>(context,
                                        listen: false)
                                    .setCoInvestors([]);

                                setState(() {
                                  _success = true;
                                });

                                if (widget.type == "buy") {
                                  Navigator.pop(context, "success");
                                }
                              } catch (e) {
                                showErrorDialog(e.toString(), context);
                              } finally {
                                setState(() {
                                  loading = false;
                                });
                              }
                            },
                            child: Text(
                              "Pay ${formatter.format(_userShare > 0 ? _userShare : _property!.pricePerUnit * _quantity)}",
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
    });
  }
}
