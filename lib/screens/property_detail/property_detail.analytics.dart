import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/invest/co_invest.dart';
import 'package:propstock/screens/property_detail/property_detail.important_statistics.dart';
import 'package:propstock/screens/property_detail/property_detail.returns.dart';
import 'package:propstock/screens/property_detail/property_detail.tags.dart';
import 'package:propstock/screens/invest/buy_units_invest_page.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/invest_buttons.dart';
import 'package:provider/provider.dart';

class PropertyDetailAnalytics extends StatefulWidget {
  // const PropertyDetailAnalytics({super.key});
  final Property? property;
  PropertyDetailAnalytics({
    super.key,
    required this.property,
  });

  @override
  State<PropertyDetailAnalytics> createState() =>
      _PropertyDetailAnalyticsState();
}

// var myflspot = FlSpot(0, 3).x;

class _PropertyDetailAnalyticsState extends State<PropertyDetailAnalytics> {
  List<FlSpot> propData = [FlSpot(1672527600000, 2000000)];

  late double growthData = 0;
  bool _loading = true;
  String searchcriteria = "1Y";
  late List<String> timeRanges = ["1D", "1W", "1M", "1Y", "ALL"];
  late List<String> _fullWordsRanges = [
    "Growth in 1 day",
    "Growth in 1 week",
    "Growth in 1 month",
    "Growth in 1 year",
    "All time growth"
  ];

  // late String defaultTimeRange = "1Y";
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
        growthData = ((priceData[priceData.length - 1].y - priceData[0].y) /
            priceData[0].y);
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
    // print(propData[propData.length - 1].y);

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
                    height: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Icon(
                            growthData > 0
                                ? Icons.arrow_upward_sharp
                                : Icons.arrow_downward_sharp,
                            color: growthData > 0
                                ? MyColors.success
                                : MyColors.error,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            child: Text(
                              "${(growthData * 100).toStringAsFixed(2)}%",
                              style: TextStyle(
                                color: growthData > 0
                                    ? MyColors.success
                                    : MyColors.error,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Inter",
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 25,
                          ),
                          Text(
                              _fullWordsRanges[
                                  timeRanges.indexOf(searchcriteria)],
                              style: TextStyle(
                                fontSize: 14,
                                color: MyColors.neutral,
                                fontWeight: FontWeight.w100,
                              )),
                        ],
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
                  InvestButtons(
                    property: widget.property,
                  ),
                  SizedBox(
                    height: 30,
                  ),
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
