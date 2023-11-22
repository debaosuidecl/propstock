import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/assets.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/models/user_purchase.dart';

class PurchaseAssetCard extends StatelessWidget {
  final UserPurchase? userPurchase;

  const PurchaseAssetCard({
    required this.userPurchase,
    super.key,
  });

  int getPercentage() {
    // print(userPurchase!.coBuyAmount);

    return (userPurchase!.coBuyAmount /
            (userPurchase!.quantity * userPurchase!.pricePerUnitAtPurchase) *
            100)
        .round();
    // return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 195,
      // width: ,
      margin: EdgeInsets.only(
        bottom: 10,
      ),
      padding: EdgeInsets.only(left: 10),
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
                userPurchase!.property.propImage,
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
                  "${userPurchase!.property.propertyType}",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    color: MyColors.primary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "${userPurchase!.property.name}",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    color: MyColors.secondary,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "${userPurchase!.property.location}",
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
                  userPurchase!.coBuyAmount > 0
                      ? "${getPercentage()}% ownership"
                      : "100% ownership",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    color: MyColors.neutral,
                    fontSize: 12,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                      color: Color(0xffCBDFF7),
                      borderRadius: BorderRadius.all(Radius.circular(
                        4,
                      ))),
                  width: 202,
                  height: 37,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${userPurchase!.property.bedNumber} Bed",
                        style: TextStyle(
                            color: MyColors.primary,
                            fontFamily: "Inter",
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      SvgPicture.asset("images/line.svg"),
                      Text(
                        "${userPurchase!.property.bathNumber} Bath",
                        style: TextStyle(
                          color: MyColors.primary,
                          fontFamily: "Inter",
                          fontSize: 12,
                        ),
                      ),
                      SvgPicture.asset("images/line.svg"),
                      Text(
                        "${userPurchase!.quantity} Plot",
                        style: TextStyle(
                          color: MyColors.primary,
                          fontFamily: "Inter",
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
