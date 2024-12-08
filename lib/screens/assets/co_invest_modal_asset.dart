import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:flutter/services.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/providers/assets.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/overlappeditemlist.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class CoInvestModalAsset extends StatefulWidget {
  const CoInvestModalAsset({super.key});

  @override
  State<CoInvestModalAsset> createState() => _CoInvestModalAssetState();
}

class _CoInvestModalAssetState extends State<CoInvestModalAsset> {
  bool _loading = true;
  // List<CardModel> _cards = [];
  TextEditingController _controller = TextEditingController();
  FocusNode _focus = FocusNode();
  List<User> _coInvestors = [];
  Property? _property;
  double _fraction = 0;
  int _quantity = 0;
  double _percentleft = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initPaymentoptions();
  }

  Future<void> _initPaymentoptions() async {
    try {
      Property? property =
          Provider.of<PaymentProvider>(context, listen: false).propertyToPay;
      int quantity = Provider.of<PaymentProvider>(context, listen: false)
          .quantityOfProperty;

      setState(() {
        _coInvestors =
            Provider.of<PropertyProvider>(context, listen: false).coInvestors;
        _property = property;
        _quantity = quantity;
        print(
            "has been paid: ${(property!.pricePerUnit * quantity - Provider.of<AssetsProvider>(context, listen: false).amountToBePaid)}, total left: ${property!.pricePerUnit * quantity}");
        _percentleft = (property.pricePerUnit * quantity -
                Provider.of<AssetsProvider>(context, listen: false)
                    .amountToBePaid) /
            (property.pricePerUnit * quantity);

        print(_percentleft);
      });
    } catch (e) {
      showErrorDialog(e.toString(), context);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  bool disabledCondition() {
    return _controller.text.isEmpty ||
        double.parse(_controller.text) >=
            Provider.of<AssetsProvider>(context, listen: false).amountToBePaid;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading)
      return Container(height: 10, child: LinearProgressIndicator());
    NumberFormat formatter = NumberFormat.currency(
        locale: 'en_US', symbol: "${_property!.currency} ");
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
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: _focus.hasFocus ? screenHeight : 500,
            // height: double.infinity,
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        "Co-invest",
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

                Text(
                    "Total Amount:  ${formatter.format(_property!.pricePerUnit * _quantity)}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff303030),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Inter",
                    )),
                SizedBox(
                  height: 15,
                ),

                Text(
                    "Amount to be paid:  ${formatter.format(Provider.of<AssetsProvider>(context, listen: true).amountToBePaid)}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: MyColors.neutral,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter",
                    )),

                // Divider(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .5,
                      height: 120,
                      child: OverLappedItemList(
                        users: _coInvestors,
                        offset: 20,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${(_percentleft * 100).toStringAsFixed(2)}% complete",
                          style: TextStyle(
                            color: MyColors.primary,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Stack(
                            // fit: StackFit.passthrough,
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * .26,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Color(0xffEBEDF0),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      .26 *
                                      _percentleft,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ])
                      ],
                    )
                  ],
                ),
                // SizedBox(
                //   height: 7,
                // ),
                if (!Provider.of<AssetsProvider>(context, listen: false)
                    .isFinalPayment)
                  Column(
                    children: [
                      Text(
                        "How much of the total amount are you paying?",
                        style: TextStyle(
                          color: MyColors.neutral,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _controller,
                        focusNode: _focus,
                        onChanged: (String value) {
                          // _onSearchTextChanged(value);
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          // prefixIcon: Icon(Icons.search),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          label: Text('Enter your amount',
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
                        height: 30,
                      ),
                    ],
                  ),

                // if (disabledCondition())
                //   Text(
                //     "Amount bigger than allowed amount",
                //     style: TextStyle(
                //       color: MyColors.neutral,
                //       fontSize: 16,
                //       fontWeight: FontWeight.w400,
                //     ),
                //   ),

                if (Provider.of<AssetsProvider>(context, listen: false)
                    .isFinalPayment)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your share",
                        style: TextStyle(
                          color: MyColors.neutral,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "${((1 - _percentleft) * 100).toStringAsFixed(2)}%",
                        style: TextStyle(
                          color: MyColors.neutral,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),

                if (_controller.text.isNotEmpty &&
                    !_focus.hasFocus &&
                    !disabledCondition())
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (double.parse(_controller.text) /
                              (_property!.pricePerUnit * _quantity) <=
                          1)
                        Text(
                          "Your share",
                          style: TextStyle(
                            color: MyColors.neutral,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      if (double.parse(_controller.text) /
                                  (_property!.pricePerUnit * _quantity) <=
                              1 &&
                          !disabledCondition())
                        Text(
                          "${(double.parse(_controller.text) / (_property!.pricePerUnit * _quantity) * 100).toStringAsFixed(4)}%",
                          style: TextStyle(
                            color: MyColors.neutral,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                    ],
                  ),
                SizedBox(
                  height: 20,
                ),
                PropStockButton(
                  text: _controller.text.isEmpty
                      ? "Continue"
                      : formatter.format(double.parse(_controller.text)),
                  disabled: Provider.of<AssetsProvider>(context, listen: false)
                          .isFinalPayment
                      ? false
                      : disabledCondition(),
                  onPressed: () {
                    if (!Provider.of<AssetsProvider>(context, listen: false)
                            .isFinalPayment &&
                        disabledCondition()) {
                      return print("disabled");
                    }

                    // print()

                    // if(double.parse(_controller.text))

                    // if (Provider.of<AssetsProvider>(context, listen: false)
                    //         .isFinalPayment &&
                    //     Provider.of<AssetsProvider>(context, listen: false)
                    //                 .amountToBePaid -
                    //             double.parse(_controller.text) >
                    //         0.01) {
                    //   print("compare");
                    //   print(double.parse(_controller.text));
                    //   print(Provider.of<AssetsProvider>(context, listen: false)
                    //       .amountToBePaid);

                    //   return showErrorDialog(
                    //       "This is the final co investor payment. you have to pay it off",
                    //       context);
                    // }

                    // reaffirm the co investors

                    Provider.of<PropertyProvider>(context, listen: false)
                        .setCoInvestors(_coInvestors);
                    // Provider.of<PropertyProvider>(context, listen: false)
                    //     .selectedInvestmentId = ;
                    Provider.of<PropertyProvider>(context, listen: false)
                        .setIsCoInvestorPayAfterInitialCoInvestment(true);
                    Provider.of<PropertyProvider>(context, listen: false)
                        .setCurrency(_property!.currency);
                    if (Provider.of<AssetsProvider>(context, listen: false)
                        .isFinalPayment) {
                      Provider.of<PropertyProvider>(context, listen: false)
                          .setUserShareInCoInvestment(
                              Provider.of<AssetsProvider>(context,
                                      listen: false)
                                  .amountToBePaid);
                      Provider.of<PropertyProvider>(context, listen: false)
                          .isFinalPayment = true;
                    } else {
                      Provider.of<PropertyProvider>(context, listen: false)
                          .setUserShareInCoInvestment(
                              double.parse(_controller.text));
                      Provider.of<PropertyProvider>(context, listen: false)
                          .isFinalPayment = false;
                    }

                    Navigator.pop(context, "pick_payment_option");
                  },
                )
                // Divider(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
