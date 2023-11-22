import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';

class AppreciationRoiChart extends StatefulWidget {
  final Property? property;
  const AppreciationRoiChart({super.key, this.property});

  @override
  State<AppreciationRoiChart> createState() => _AppreciationRoiChartState();
}

class _AppreciationRoiChartState extends State<AppreciationRoiChart> {
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  final double width = 16;

  int touchedGroupIndex = -1;
  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: MyColors.neutral,
          width: width,
          borderRadius: BorderRadius.all(
            Radius.zero,
          ),
        ),
        BarChartRodData(
          toY: y2,
          color: MyColors.primary,
          width: width,
          borderRadius: BorderRadius.all(
            Radius.zero,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    List<List<int>> appreciation_roi_group = [
      [5, 12],
      [16, 12],
      [18, 5],
      [20, 16],
    ];
    final barGroup1 = makeGroupData(0, 5, 12); // q1
    final barGroup2 = makeGroupData(1, 16, 12); // q2
    final barGroup3 = makeGroupData(2, 18, 5); // q3
    final barGroup4 = makeGroupData(3, 20, 16); // q4
    // barGroup1.

    // do a proper map functionality for  bar group items
    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 200,
        child: BarChart(
          BarChartData(
            maxY: 20,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.grey,
                getTooltipItem: (a, b, c, d) => null,
              ),
              touchCallback: (FlTouchEvent event, response) {},
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: showingBarGroups,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              // getDrawingVerticalLine: ()
            ),
          ),
        ),
      ),
      SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BarLabels(
            quarter: "Q1",
            year: "2023",
            appreciation: 3.51,
            roi: 2.54,
          ),
          BarLabels(
            quarter: "Q2",
            year: "2023",
            appreciation: 3.51,
            roi: 2.54,
          ),
          BarLabels(
            quarter: "Q3",
            year: "2023",
            appreciation: 3.51,
            roi: 2.54,
          ),
          BarLabels(
            quarter: "Q4",
            year: "2023",
            appreciation: 3.51,
            roi: 2.54,
          )
        ],
      ),
      SizedBox(
        height: 30,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                Icons.circle,
                size: 10,
                color: MyColors.neutral,
              ),
              Text('Appreciation',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Inter",
                  )),
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Row(
            children: [
              Icon(
                Icons.circle,
                size: 10,
                color: MyColors.primary,
              ),
              Text('ROI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Inter",
                  )),
            ],
          ),

          // Add more ListTiles as needed
        ],
      )
    ]);
  }
}

class BarLabels extends StatelessWidget {
  final String quarter;
  final String year;
  final double appreciation;
  final double roi;
  const BarLabels(
      {super.key,
      required this.quarter,
      required this.year,
      required this.appreciation,
      required this.roi});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          quarter,
          style: TextStyle(
            color: MyColors.neutralblack,
            fontSize: 16,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          year,
          style: TextStyle(
            color: MyColors.neutral,
            fontSize: 12,
            fontFamily: "Inter",
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "${appreciation}%",
          style: TextStyle(
            color: MyColors.neutral,
            fontSize: 14,
            fontFamily: "Inter",
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "${roi}%",
          style: TextStyle(
            color: MyColors.primary,
            fontSize: 14,
            fontFamily: "Inter",
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
