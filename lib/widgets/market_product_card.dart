import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/market_place.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/screens/marketplace/market_place_bid.dart';
// import 'package:propstock/models/user_investment.dart';
// import 'package:propstock/providers/investments.dart';
// import 'package:propstock/providers/property.dart';
// import 'package:propstock/screens/buy_property/buy_property_detail.overview.dart';
// import 'package:propstock/screens/investments/investment_details.dart';
// import 'package:propstock/widgets/overlappeditemlist.dart';
// import 'package:provider/provider.dart';

class MarketProductCard extends StatelessWidget {
  final Property property;
  final MarketPlaceProduct marketplace;
  bool? notClickable;
  MarketProductCard(
      {super.key,
      required this.property,
      required this.marketplace,
      this.notClickable});
  @override
  Widget build(BuildContext context) {
    NumberFormat formatter =
        NumberFormat.currency(locale: 'en_US', symbol: "${property.currency} ");
    print(property.propImage);
    // double currentPropertyValue = property.pricePerUnit;

    return GestureDetector(
      onTap: () {
        print("tapped");
        if (notClickable != true) {
          Navigator.pushNamed(context, MarketPlaceBid.id,
              arguments: marketplace);
        }
      },
      child: Container(
        // height: ,
        margin: EdgeInsets.only(bottom: 10, right: 10, left: 10, top: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          // vertical: 0,
        ),
        decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xffCBDFF7),
              width: 1.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .331,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0), // Rounded corners
                  child: Image.network(
                    property.propImage, // Replace with your image URL
                    width: 120, // Adjust the width of the displayed image
                    height: 140, // Adjust the height of the displayed image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Container(
                // color: Colors.green,
                // height: 160,
                padding: EdgeInsets.symmetric(vertical: 20),

                // width: MediaQuery.of(context).size.width * .4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (marketplace.investmentid != null)
                      Container(
                        width: MediaQuery.of(context).size.width * .4,
                        child: Text(
                          "Investment",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: MyColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Inter",
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .4,
                      child: Text(
                        property.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          color: Color(
                            0xff011936,
                          ),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .4,
                      child: Text(
                        property.location,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          color: Color(
                            0xff5E6D85,
                          ),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .4,
                      child: FittedBox(
                        child: Text(
                          "${formatter.format(marketplace.price)} for ${marketplace.units} unit(s)",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Color(
                              0xff5E6D85,
                            ),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Inter",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * .4,
                      // width: MediaQuery.of(context).size.width * .2,
                      height: 30,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffCBDFF7),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: property.propertyType == "Land"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${property.plotNumber}plots",
                                  style: TextStyle(
                                    color: MyColors.primary,
                                    fontSize: 12,
                                    fontFamily: "Inter",
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SvgPicture.asset("images/line.svg"),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${property.landSize} sqr/m",
                                  style: TextStyle(
                                    color: MyColors.primary,
                                    fontSize: 12,
                                    fontFamily: "Inter",
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${property.bedNumber} Bed",
                                  style: TextStyle(
                                    color: MyColors.primary,
                                    fontSize: 11,
                                    fontFamily: "Inter",
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SvgPicture.asset("images/line.svg"),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${property.bathNumber} Bath",
                                  style: TextStyle(
                                    color: MyColors.primary,
                                    fontSize: 11,
                                    fontFamily: "Inter",
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SvgPicture.asset("images/line.svg"),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${property.plotNumber}plots",
                                  style: TextStyle(
                                    color: MyColors.primary,
                                    fontSize: 11,
                                    fontFamily: "Inter",
                                  ),
                                ),
                              ],
                            ),
                    )
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
