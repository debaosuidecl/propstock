import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:flutter/cupertino.dart';
import 'package:propstock/providers/investments.dart';
import 'package:propstock/screens/investments/sell_investments_preview.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class MarketPlaceSeller extends StatefulWidget {
  const MarketPlaceSeller({super.key});

  static const id = "market_place_seller";

  @override
  State<MarketPlaceSeller> createState() => _MarketPlaceSellerState();
}

class _MarketPlaceSellerState extends State<MarketPlaceSeller> {
  final TextEditingController _unitscontroller = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool activeAutoInvest = false;

  bool _disabledCondition() {
    return _unitscontroller.text.isEmpty || _priceController.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final UserInvestment investment =
        ModalRoute.of(context)!.settings.arguments as UserInvestment;

    final coInvestPercentage = (investment.coInvestAmount /
            (investment.pricePerUnitAtPurchase * investment.quantity)) *
        100;

    print("${investment.coInvestAmount}, ${investment.pricePerUnitAtPurchase}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: MyColors.primaryDark,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            print("working");
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: MediaQuery.of(context).size.height * .85,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height * .8 * .05,
                          ),
                          Text(
                            "Fill in the details",
                            style: TextStyle(
                              color: MyColors.secondary,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Inter",
                            ),
                          ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height * .8 * .025,
                          ),
                          const Text(
                            "Fill in the necessary details in order to upload this investment to the marketplace",
                            style: TextStyle(
                              color: Color(0xff5E6D85),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter",
                            ),
                          ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height * .8 * .05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Units: ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 50.0),
                                  child: TextField(
                                    controller: _unitscontroller,
                                    // focusNode: _focus,
                                    onChanged: (String value) {
                                      // _onSearchTextChanged(value);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      // prefixIcon: Icon(Icons.search),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                      label: const Text('Enter a number',
                                          style: TextStyle(
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w100,
                                          )),
                                      hintStyle:
                                          TextStyle(color: Color(0xffbbbbbb)),
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
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height * .8 * .05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Price: ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 50.0),
                                  child: TextField(
                                    controller: _priceController,
                                    // focusNode: _focus,
                                    onChanged: (String value) {
                                      // _onSearchTextChanged(value);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      // prefixIcon: Icon(Icons.search),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                      label: Text(
                                          'Enter your price (${investment.property.currency})',
                                          style: TextStyle(
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w100,
                                          )),
                                      hintStyle:
                                          TextStyle(color: Color(0xffbbbbbb)),
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
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height * .8 * .05,
                          ),
                          if (investment.coInvestors.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset("images/Info2.svg"),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    "Please note that this price is for the sale of your ${coInvestPercentage.toStringAsFixed(2)}% of the total amount of units specified",
                                    style: TextStyle(
                                      color: MyColors.neutral,
                                      fontFamily: "Inter",
                                    ),
                                  ),
                                )
                              ],
                            ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height * .8 * .05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Allow co-investing with friends",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                  color: MyColors.secondary,
                                ),
                              ),
                              CupertinoSwitch(
                                // overrides the default green color of the track
                                activeColor: MyColors.primary,
                                // color of the round icon, which moves from right to left
                                thumbColor: !activeAutoInvest
                                    ? Colors.white
                                    : MyColors.primary,
                                // when the switch is off
                                trackColor: Color(0xffeeeeee),
                                // boolean variable value
                                value: activeAutoInvest,
                                // changes the state of the switch
                                onChanged: (bool val) => setState(() {
                                  activeAutoInvest = val;
                                }),
                              ),
                            ],
                          )
                        ]),
                  ),
                  Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset("images/Info2.svg"),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            "There is a service charge of 0.5% for every property sold at the marketplace.",
                            style: TextStyle(
                              color: MyColors.neutral,
                              fontFamily: "Inter",
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PropStockButton(
                        text: "Preview",
                        disabled: _disabledCondition(),
                        onPressed: () {
                          if (investment.quantity <
                              double.parse(_unitscontroller.text)) {
                            return showErrorDialog(
                                "You only have ${investment.quantity} unit(s) in this investment. please type a unit less than or equal to ${investment.quantity}",
                                context);
                          }
                          if (_disabledCondition()) {
                            showErrorDialog("Invalid values in input", context);
                            return;
                          }

                          Provider.of<InvestmentsProvider>(context,
                                  listen: false)
                              .setPriceAndUnitsAndAllowCoInvestToSellMarketPlace(
                            double.parse(_priceController.text),
                            double.parse(_unitscontroller.text),
                            activeAutoInvest,
                          );

                          Navigator.pushNamed(
                              context, SellInvestmentsPreview.id,
                              arguments: investment);

                          // go to preview
                        })
                  ])
                ]),
          ),
        ),
      ),
    );
  }
}
