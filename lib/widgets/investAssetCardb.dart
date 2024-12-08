import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/assets.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_investment.dart';

class InvestAssetCardB extends StatelessWidget {
  final UserInvestment? userInvestment;
  final String? mode;

  const InvestAssetCardB({
    required this.userInvestment,
    this.mode,
    super.key,
  });

  List<String> months() {
    return [
      "Jan",
      "Feb",
      "Mar",
      "April",
      "May",
      "June",
      "July",
      "Aug",
      "Sept",
      "Oct",
      "Nov",
      "Dec",
    ];
  }

  int getPercentage() {
    // print(userPurchase!.coBuyAmount);

    return (userInvestment!.coInvestAmount /
            (userInvestment!.quantity *
                userInvestment!.pricePerUnitAtPurchase) *
            100)
        .round();
    // return 0;
  }

  int toInt(createdAt) {
    if (createdAt == null) return 0;

    return createdAt;
  }

  String getTime(DateTime datetime) {
    return "${months()[datetime.month - 1]} ${datetime.day}, ${datetime.year}";
  }

  // String formattedAmount = currencyFormatter.format(amount);

  @override
  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat.currency(
        locale: 'en_US', symbol: '${userInvestment!.property.currency} ');
    double valueAtPurchase = userInvestment!.pricePerUnitAtPurchase;
    double currentPropertyValue = userInvestment!.property.pricePerUnit;
    double percentageChange =
        (currentPropertyValue - valueAtPurchase) / valueAtPurchase;
    return Container(
      height: 210,
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
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                userInvestment!.complete == true ? "Completed" : "Incomplete",
                style: TextStyle(
                  color: Color(0xff1D3354),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Inter",
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "${getTime(DateTime.fromMillisecondsSinceEpoch(toInt(userInvestment!.createdAt)))}",
                style: TextStyle(
                  color: Color(0xff5E6D85),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Inter",
                ),
              ),
            ],
          ),
          SizedBox(
            height: 14,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                // width: MediaQuery.of(context).size.width * .4,
                clipBehavior: Clip.hardEdge,

                child: Container(
                  clipBehavior: Clip.hardEdge,

                  width: MediaQuery.of(context).size.width *
                      .25, // Width of the container rectangle
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
                    if (mode == "Init")
                      Text(
                        "${formatter.format(userInvestment!.pricePerUnitAtPurchase)}/unit",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          color: MyColors.neutral,
                          fontSize: 12,
                        ),
                      ),
                    if (mode == "Init")
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                            color: Color(0xffCBDFF7),
                            borderRadius: BorderRadius.all(Radius.circular(
                              4,
                            ))),
                        width: MediaQuery.of(context).size.width * .38,
                        height: 37,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${userInvestment!.property.bedNumber} Bed",
                              style: TextStyle(
                                  color: MyColors.primary,
                                  fontFamily: "Inter",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                            SvgPicture.asset("images/line.svg"),
                            Text(
                              "${userInvestment!.property.bathNumber} Bath",
                              style: TextStyle(
                                color: MyColors.primary,
                                fontFamily: "Inter",
                                fontSize: 12,
                              ),
                            ),
                            SvgPicture.asset("images/line.svg"),
                            Text(
                              "${userInvestment!.quantity} Plot",
                              style: TextStyle(
                                color: MyColors.primary,
                                fontFamily: "Inter",
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                    if (mode != "Init")
                      Text(
                        "${userInvestment!.quantity} Unit(s)",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          color: MyColors.neutral,
                          fontSize: 12,
                        ),
                      ),
                    if (mode != "Init")
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
        ],
      ),
    );
  }
}
