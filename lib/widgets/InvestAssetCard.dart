import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/assets.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_investment.dart';

class InvestAssetCard extends StatelessWidget {
  final UserInvestment? userInvestment;

  const InvestAssetCard({
    required this.userInvestment,
    super.key,
  });

  int getPercentage() {
    // print(userPurchase!.coBuyAmount);

    return (userInvestment!.coInvestAmount /
            (userInvestment!.quantity *
                userInvestment!.pricePerUnitAtPurchase) *
            100)
        .round();
    // return 0;
  }

  @override
  Widget build(BuildContext context) {
    double valueAtPurchase = userInvestment!.pricePerUnitAtPurchase;
    double currentPropertyValue = userInvestment!.property.pricePerUnit;
    double percentageChange =
        (currentPropertyValue - valueAtPurchase) / valueAtPurchase;
    return Container(
      height: 195,
      // width: ,
      padding: EdgeInsets.only(left: 10),

      margin: EdgeInsets.only(
        bottom: 10,
      ),
      alignment: Alignment.center,
      // padding: EdgeInsets.all(
      //   14,
      // ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: .5, color: Color(0xffEBEDF0)),
        borderRadius: BorderRadius.all(
          Radius.circular(
            8,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            // width: MediaQuery.of(context).size.width * .4,
            clipBehavior: Clip.hardEdge,

            child: Container(
              clipBehavior: Clip.hardEdge,

              width: MediaQuery.of(context).size.width *
                  .35, // Width of the container rectangle
              // height: 150.0, // Height of the container rectangle
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(
                8,
              ))),
              child: Image.network(
                userInvestment!.property.propImage,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
              child: Container(
            height: 150,
            // alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(
              horizontal: 14,
              // vertical:
            ),
            // color: Colors.green,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Investment",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    color: MyColors.primary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "${userInvestment!.property.name}",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    color: MyColors.secondary,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "${userInvestment!.property.location}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400,
                    color: MyColors.neutral,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "${userInvestment!.quantity} Unit(s)",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    color: MyColors.neutral,
                    fontSize: 12,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      size: 16,
                      color: percentageChange < 0
                          ? MyColors.error
                          : MyColors.success,
                    ),
                    Text(
                      "${(percentageChange * 100).toStringAsFixed(2)}%",
                      style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: MyColors.success),
                    )
                  ],
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
