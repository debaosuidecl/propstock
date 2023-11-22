import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/providers/investments.dart';
import 'package:propstock/screens/investments/market_place_upload.dart';
import 'package:propstock/screens/property_detail/property_detail.about.dart';
import 'package:propstock/screens/property_detail/property_detail.location.dart';
import 'package:propstock/screens/property_detail/property_more_information.dart';
import 'package:propstock/widgets/ImageChanger.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class SellInvestmentsPreview extends StatefulWidget {
  static const id = "SellInvestmentsPreview";
  const SellInvestmentsPreview({
    super.key,
  });

  @override
  State<SellInvestmentsPreview> createState() => _SellInvestmentsPreviewState();
}

class _SellInvestmentsPreviewState extends State<SellInvestmentsPreview> {
  int imageIndex = 0;
  bool _loading = true;
  int unitsToSellMarketPlace = 0;
  double priceToSellMarketPlace = 0.0;

  @override
  initState() {
    super.initState();
    loadPropertyAndInvestment();
  }

  void loadPropertyAndInvestment() {
    setState(() {
      priceToSellMarketPlace =
          Provider.of<InvestmentsProvider>(context, listen: false)
              .priceToSellMarketPlace;

      unitsToSellMarketPlace =
          Provider.of<InvestmentsProvider>(context, listen: false)
              .unitsToSellMarketPlace
              .toInt();
      // _loading = false;
    });
  }

  Future<void> _showBottomSheet(
      BuildContext context, UserInvestment investment) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return MarketPlaceUploadModal(investment: investment);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserInvestment investment =
        ModalRoute.of(context)!.settings.arguments as UserInvestment;
    final Property property = investment.property;

    NumberFormat formatter =
        NumberFormat.currency(locale: 'en_US', symbol: "${property.currency} ");

    final coInvestPercentage =
        (investment.coInvestAmount / investment.pricePerUnitAtPurchase) * 100;
    // UserInvestment investment = args!['investment'] as UserInvestment;
    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageChanger(
                images: property.imagesList,
                imageIndex: imageIndex,
                setCurrentImage: (index) {
                  setState(() {
                    imageIndex = index;
                  });
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Investment",
                  style: TextStyle(
                    color: MyColors.primary,
                    fontSize: 14,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  property.name,
                  style: TextStyle(
                    color: MyColors.neutralblack,
                    fontSize: 22,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  property.location,
                  style: TextStyle(
                    color: MyColors.neutralblack,
                    fontSize: 14,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),
              // InvestButtons(
              //   property: property,
              // ),

              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: PropertyDetailAbout(property: property),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: PropertyDetailLocation(property: property),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: PropertyMoreInformation(property: property),
              ),
              SizedBox(
                height: 180,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -20,
          left: 0,
          child: Container(
            height: 220,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              border: Border.all(
                color: const Color(0xffeeeeee),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Price",
                      style: TextStyle(
                        color: Color(0xff5E6D85),
                        fontWeight: FontWeight.w100,
                        fontFamily: "Inter",
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "${formatter.format(priceToSellMarketPlace)}",
                            style: TextStyle(
                              color: MyColors.neutralblack,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Inter",
                            ),
                          ),
                          Text(
                            "/ ${investment.coInvestAmount > 0 ? '${coInvestPercentage.toStringAsFixed(2)}% of' : ''} ${unitsToSellMarketPlace} units",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: MyColors.neutralblack,
                              fontFamily: "Inter",
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("images/Info2.svg"),
                        Text(
                          "Includes 5% service charge",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: MyColors.neutralGrey,
                            fontFamily: "Inter",
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  // width: 100,
                  child: Container(
                    // padding: EdgeInsets.symmetric(
                    //   horizontal: 10,
                    // ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        PropStockButton(
                            text: "Upload",
                            disabled: false,
                            onPressed: () async {
                              _showBottomSheet(context, investment);
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
