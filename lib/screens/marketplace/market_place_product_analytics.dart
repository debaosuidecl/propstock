import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/providers/auth.dart';
// import 'package:propstock/providers/investments.dart';
import 'package:propstock/providers/property.dart';
// import 'package:propstock/screens/invest/send_investment_as_gifts.dart';
// import 'package:propstock/screens/investments/friend_gift_finalize.dart';
// import 'package:propstock/screens/investments/market_place_seller.dart';
import 'package:propstock/screens/property_detail/property_detail.important_statistics.dart';
import 'package:propstock/screens/property_detail/property_detail.returns.dart';
import 'package:propstock/screens/property_detail/property_detail.tags.dart';
// import 'package:propstock/screens/verify_account/verify_account.dart';
import 'package:propstock/screens/withdrawals/amount_to_withdraw.dart';
import 'package:propstock/screens/withdrawals/amount_to_withdraw_b.dart';
import 'package:propstock/screens/withdrawals/pin_to_withdraw_to_bank.dart';
import 'package:propstock/screens/withdrawals/propstock_wallet_withdraw.dart';
import 'package:propstock/screens/withdrawals/select_a_bank.dart';
import 'package:propstock/screens/withdrawals/withdrawal_address.dart';
import 'package:propstock/screens/withdrawals/withdrawal_init.dart';
import 'package:propstock/utils/showErrorDialog.dart';
// import 'package:propstock/widgets/propstock_button.dart';
// import 'package:propstock/widgets/user_invest_actions.dart';
import 'package:provider/provider.dart';

class MarketPlaceProductAnalytics extends StatefulWidget {
  static const id = "market_place_product_anaylytics";
  // const MarketPlaceProductAnalytics({super.key});
  final Property? property;
  final UserInvestment? investment;
  MarketPlaceProductAnalytics({
    super.key,
    required this.property,
    required this.investment,
  });

  @override
  State<MarketPlaceProductAnalytics> createState() =>
      _MarketPlaceProductAnalyticsState();
}

// var myflspot = FlSpot(0, 3).x;

class _MarketPlaceProductAnalyticsState
    extends State<MarketPlaceProductAnalytics> {
  List<FlSpot> propData = [FlSpot(1672527600000, 2000000)];
  String withdrawalkey = "withdrawal_init";
  late double growthData = 0;
  late double growthPercentage = 0;
  late double growthValue = 0;
  late String? _currency = "USD";
  bool _loading = true;
  String searchcriteria = "1Y";
  late List<String> timeRanges = ["1D", "1W", "1M", "1Y", "ALL"];

  Map<String, dynamic> withdrawalPages = {
    "withdrawal_init": const WithdrawalInit(),
    "amount_to_withdraw": AmountToWithdraw(),
    "amount_to_withdraw_mature": Container(
      child: Text("to be done"),
    ),
    "amount_to_withdraw_b": AmountToWithdrawB(),
    "withdrawal_address": WithdrawalAddress(),
    "select_a_bank": SelectABank(),
    "propstock_wallet_withdraw": PropstockWalletWithdraw(),
    "pin_to_bank": PinToWithdrawToBank()
  };

  // late String defaultTimeRange = "1Y";
  Map<String, dynamic> textMap = {
    "1D": "Growth in 1 day",
    "1W": "Growth in 1 week",
    "1M": "Growth in 1 month",
    "1Y": "Growth in 1 year",
    "All": "Growth all time",
  };
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initPropData();
  }

  Future<void> _initPropData() async {
    // FACTOR IN TIME RANGE

    try {
      List<FlSpot> priceData =
          await Provider.of<PropertyProvider>(context, listen: false)
              .fetchPropertyPriceData(widget.property!.id, searchcriteria);
      setState(() {
        propData = priceData;
        _currency = Provider.of<PropertyProvider>(context, listen: false)
            .selectedCurrency;
        growthPercentage =
            ((priceData[priceData.length - 1].y - priceData[0].y) /
                priceData[0].y);
        growthValue = (priceData[priceData.length - 1].y - priceData[0].y);
      });
    } catch (e) {
      showErrorDialog(e.toString(), context);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat formatter =
        NumberFormat.currency(locale: 'en_US', symbol: "$_currency ");

    // print(propData[propData.length - 1]);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .7,
      child: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Icon(Icons.eye)
                        ],
                      ),

                      // Row(
                      //   children: [
                      //     SizedBox(
                      //       width: 20,
                      //     ),
                      //     // if (_hideBalance)
                      //     Text(
                      //       formatter.format(propData[propData.length - 1].y),
                      //       style: TextStyle(
                      //         color: MyColors.primaryDark,
                      //         fontSize: 24,
                      //         fontWeight: FontWeight.w500,
                      //         fontFamily: "Inter",
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child:
                                    SvgPicture.asset("images/back_arrow.svg"))
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${widget.property!.name}",
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset("images/ShareNetworkb.svg"),
                                SvgPicture.asset("images/loveb.svg"),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Analytics",
                          style: TextStyle(
                            color: MyColors.neutral,
                            fontSize: 14,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            growthPercentage > 0
                                ? Icons.arrow_upward_sharp
                                : Icons.arrow_downward_sharp,
                            color: growthPercentage > 0
                                ? MyColors.success
                                : MyColors.error,
                            size: 24,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            child: Text(
                              "${(growthPercentage * 100).toStringAsFixed(2)}%",
                              style: TextStyle(
                                color: growthPercentage > 0
                                    ? MyColors.success
                                    : MyColors.error,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Inter",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          // Container(
                          //   child: Text(
                          //     "(${growthValue > 0 ? '+' : ''}${formatter.format(growthValue)})",
                          //     style: TextStyle(
                          //       color: growthPercentage > 0
                          //           ? MyColors.success
                          //           : MyColors.error,
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.w500,
                          //       fontFamily: "Inter",
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "${textMap[searchcriteria]}",
                          style: TextStyle(
                            color: MyColors.neutral,
                            fontSize: 14,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 196,
                    child: LineChart(LineChartData(
                        lineTouchData: LineTouchData(
                          getTouchedSpotIndicator: (LineChartBarData barData,
                              List<int> spotIndexes) {
                            return spotIndexes.map((spotIndex) {
                              final spot = barData.spots[spotIndex];
                              if (spot.x == 0 || spot.x == 6) {
                                return null;
                              }
                              return TouchedSpotIndicatorData(
                                FlLine(
                                  color: Colors.black,
                                  strokeWidth: 1,
                                  dashArray: [1, 4],
                                ),
                                FlDotData(
                                  getDotPainter:
                                      (spot, percent, barData, index) {
                                    return FlDotCirclePainter(
                                      radius: 1,
                                      color: Colors.white,
                                      strokeWidth: 1,
                                      strokeColor: Colors.white,
                                    );
                                  },
                                ),
                              );
                            }).toList();
                          },
                          touchTooltipData: LineTouchTooltipData(
                            fitInsideHorizontally: true,
                            tooltipBorder: BorderSide.none,
                            showOnTopOfTheChartBoxArea: false,
                            tooltipRoundedRadius: 10,
                            tooltipHorizontalOffset: 5,
                            tooltipBgColor:
                                Colors.white, // Background color of the tooltip
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((touchedSpot) {
                                DateTime date =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        touchedSpot.x.toInt());
                                String formattedDate =
                                    DateFormat('MMMM dd, yyyy').format(date);

                                return LineTooltipItem(
                                  // direction
                                  // textDirection: TextDirection.,
                                  children: [
                                    // TextSpan(
                                    //   text: "Hi",
                                    //   style: TextStyle(color: Colors.black),
                                    // )
                                  ],
                                  '${formattedDate}', // Customize the label
                                  TextStyle(color: Colors.black),
                                );
                              }).toList();
                            },
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ), // Hide Y-axis labels
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ), // Hide X-axis labels
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ), // Hide Y-axis labels
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ), // Hide X-axis labels
                        ),
                        gridData: FlGridData(show: false),
                        minY: propData.map((v) {
                              return v.y;
                            }).reduce((value, element) =>
                                value < element ? value : element) /
                            2,
                        // baselineX: 0,
                        lineBarsData: [
                          LineChartBarData(
                              spots: propData,
                              // isCurved: true,
                              dotData: FlDotData(show: false),
                              color: Colors.blue,
                              barWidth: 1,
                              belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    // begin: ,
                                    begin: Alignment
                                        .topCenter, // Start at the top-left corner
                                    end: Alignment
                                        .bottomCenter, // End at the bottom-right corner
                                    colors: [
                                      Color(0xffD4E8FF),
                                      Colors.white,
                                    ],
                                  )))
                        ])),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: timeRanges.map((timerange) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              searchcriteria = timerange;
                            });
                            _initPropData();
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              // color: Colors.blue,
                              child: Text(timerange,
                                  style: TextStyle(
                                    color: timerange == searchcriteria
                                        ? MyColors.primary
                                        : MyColors.neutral,
                                    fontFamily: "Inter",
                                    fontSize: 14,
                                  ))),
                        );
                      }).toList()),
                  SizedBox(
                    height: 15,
                  ),
                  // UserInvestActions(
                  //   investment: widget.investment,
                  //   sellaction: () {
                  //     _showBottomSheet(context);
                  //   },
                  //   withdrawaction: () {
                  //     Provider.of<InvestmentsProvider>(context, listen: false)
                  //         .setSelectedInvestment(widget.investment);
                  //     _showWithdrawalSheet(context);
                  //   },
                  //   giftaction: () {
                  //     Navigator.pushNamed(context, SendInvestmentAsGift.id)
                  //         .then((value) {
                  //       print("sending to finalisation page");
                  //       print(value);
                  //       if (value != null) {
                  //         Navigator.pushNamed(context, FriendGiftFinalize.id,
                  //             arguments: widget.investment);
                  //       }
                  //     });
                  //   },
                  // ),
                  // SizedBox(
                  //   height: 30,
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: PropertyDetailImportantStatistics(
                        property: widget.property),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: PropertyDetailReturns(property: widget.property),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: PropertyDetailTags(property: widget.property),
                  ),
                ],
              ),
            ),
    );
  }
}
