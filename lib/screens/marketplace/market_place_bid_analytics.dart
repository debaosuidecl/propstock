import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/market_place.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/providers/investments.dart';
import 'package:propstock/screens/investments/market_place_upload.dart';
import 'package:propstock/screens/marketplace/market_place_product_analytics.dart';
import 'package:propstock/screens/property_detail/property_detail.about.dart';
import 'package:propstock/screens/property_detail/property_detail.location.dart';
import 'package:propstock/screens/property_detail/property_more_information.dart';
import 'package:propstock/widgets/ImageChanger.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class MarketPlaceBidAnalytics extends StatefulWidget {
  static const id = "MarketPlaceBidAnalytics";
  const MarketPlaceBidAnalytics({
    super.key,
  });

  @override
  State<MarketPlaceBidAnalytics> createState() =>
      _MarketPlaceBidAnalyticsState();
}

class _MarketPlaceBidAnalyticsState extends State<MarketPlaceBidAnalytics> {
  int imageIndex = 0;
  bool _loading = true;
  int unitsToSellMarketPlace = 0;
  double priceToSellMarketPlace = 0.0;

  @override
  initState() {
    super.initState();
    // loadPropertyAndInvestment();
  }

  void loadPropertyAndInvestment() {
    setState(() {
      // priceToSellMarketPlace =
      //     Provider.of<InvestmentsProvider>(context, listen: false)
      //         .priceToSellMarketPlace;

      // unitsToSellMarketPlace =
      //     Provider.of<InvestmentsProvider>(context, listen: false)
      //         .unitsToSellMarketPlace
      //         .toInt();
      // // _loading = false;
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
    final MarketPlaceProduct marketplaceproduct =
        ModalRoute.of(context)!.settings.arguments as MarketPlaceProduct;
    final UserInvestment? investment = marketplaceproduct.investment;
    final Property property = marketplaceproduct.property;

    NumberFormat formatter =
        NumberFormat.currency(locale: 'en_US', symbol: "${property.currency} ");

    // final coInvestPercentage =
    //     (investment.coInvestAmount / investment.pricePerUnitAtPurchase) * 100;
    // UserInvestment investment = args!['investment'] as UserInvestment;
    return Scaffold(
      body: Stack(children: [
        Column(
          children: [
            SizedBox(
              height: 40,
            ),
            MarketPlaceProductAnalytics(
                property: property, investment: investment),
          ],
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
                            "${formatter.format(marketplaceproduct.price)}",
                            style: TextStyle(
                              color: MyColors.neutralblack,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Inter",
                            ),
                          ),
                          Text(
                            "/ ${marketplaceproduct.units} units",
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
                            text: "Place a bid",
                            disabled: false,
                            onPressed: () async {
                              if (investment == null) return;
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
