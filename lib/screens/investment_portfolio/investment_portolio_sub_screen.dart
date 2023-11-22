import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/providers/portfolio.dart';
import 'package:propstock/screens/investment_portfolio/asset_data.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class InvestmentPortfolioSubScreen extends StatefulWidget {
  const InvestmentPortfolioSubScreen({super.key});
  static const id = "portfolio_sub_screen";

  @override
  State<InvestmentPortfolioSubScreen> createState() =>
      _InvestmentPortfolioSubScreenState();
}

class _InvestmentPortfolioSubScreenState
    extends State<InvestmentPortfolioSubScreen> {
  List<FlSpot> balanceData = [FlSpot(1672527600000, 2000000)];

  late double growthPercentage = 0;
  late double growthValue = 0;
  bool _loading = true;
  String searchcriteria = "1Y";
  double _balance = 0;
  String _currency = "";
  bool _error = false;
  bool _hideBalance = true;

  late List<String> timeRanges = ["1D", "1W", "1M", "1Y", "ALL"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initBalanceFetch();
  }

  Future<void> _initBalanceFetch() async {
    try {
      List<FlSpot> priceData =
          await Provider.of<PortfolioProvider>(context, listen: false)
              .fetchUserWalletData(searchcriteria);
      print(priceData);

      setState(() {
        balanceData = priceData;
        double earliestPrice = priceData[0].y;
        if (earliestPrice == 0) {
          earliestPrice = 1;
        }
        growthPercentage =
            ((priceData[priceData.length - 1].y - priceData[0].y) /
                earliestPrice);
        growthValue = (priceData[priceData.length - 1].y - priceData[0].y);

        _currency = Provider.of<PortfolioProvider>(context, listen: false)
            .balanceCurrency;
        _balance =
            Provider.of<PortfolioProvider>(context, listen: false).userBalance;
      });
    } catch (e) {
      print(e);

      showErrorDialog("Could not fetch properties", context);
      setState(() {
        _error = true;
      });
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

    return _loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
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

                        Text(
                          "Total Balance",
                          style: TextStyle(
                            color: MyColors.neutral,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        // Icon(Icons.eye)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _hideBalance = !_hideBalance;
                            });
                          },
                          child: _hideBalance
                              ? Icon(
                                  Icons.remove_red_eye,
                                  size: 20,
                                  color: Colors.grey,
                                )
                              : SvgPicture.asset(
                                  "images/EyeSlash.svg",
                                  height: 20,
                                ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        if (_hideBalance)
                          Text(
                            formatter.format(_balance),
                            style: TextStyle(
                              color: MyColors.primaryDark,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Inter",
                            ),
                          ),
                        if (!_hideBalance)
                          Text(
                            " $_currency ******",
                            style: TextStyle(
                              fontFamily: "Inter",
                              color: MyColors.primaryDark,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                      ],
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
                          size: 16,
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
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Inter",
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Text(
                            "(${growthValue > 0 ? '+' : ''}${formatter.format(growthValue)})",
                            style: TextStyle(
                              color: growthPercentage > 0
                                  ? MyColors.success
                                  : MyColors.error,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Inter",
                            ),
                          ),
                        ),
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
                        getTouchedSpotIndicator:
                            (LineChartBarData barData, List<int> spotIndexes) {
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
                                getDotPainter: (spot, percent, barData, index) {
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
                      minY: balanceData.map((v) {
                            return v.y;
                          }).reduce((value, element) =>
                              value < element ? value : element) /
                          2,
                      // baselineX: 0,
                      lineBarsData: [
                        LineChartBarData(
                            spots: balanceData,
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
                          _initBalanceFetch();
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
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AssetData(),
                )
              ]));
  }
}
