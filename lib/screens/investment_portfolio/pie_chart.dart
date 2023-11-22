import 'package:flutter/material.dart';

// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:propstock/models/asset_distribution.dart';
// import 'package:fl_chart_app/presentation/widgets/indicator.dart';
// import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';

class PropStockPieChart extends StatefulWidget {
  final AssetDistribution assetdist;
  const PropStockPieChart({
    super.key,
    required this.assetdist,
  });

  @override
  State<PropStockPieChart> createState() => _PropStockPieChartState();
}

class _PropStockPieChartState extends State<PropStockPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Color(0xfffa4f4f),
            value: (widget.assetdist.commercialCount /
                    (widget.assetdist.commercialCount +
                        widget.assetdist.rentalCount +
                        widget.assetdist.residentialCount +
                        widget.assetdist.landCount +
                        1)) *
                100,
            title: '',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffFA4F4F),
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: MyColors.primary,
            value: (widget.assetdist.landCount /
                    (widget.assetdist.commercialCount +
                        widget.assetdist.rentalCount +
                        widget.assetdist.residentialCount +
                        widget.assetdist.landCount +
                        1)) *
                100,
            title: '',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: MyColors.primaryDark,
            value: (widget.assetdist.rentalCount /
                    (widget.assetdist.commercialCount +
                        widget.assetdist.rentalCount +
                        widget.assetdist.residentialCount +
                        widget.assetdist.landCount +
                        1)) *
                100,
            title: '',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: MyColors.neutralblack,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Color(0xff1A936F),
            value: (widget.assetdist.residentialCount /
                    (widget.assetdist.commercialCount +
                        widget.assetdist.rentalCount +
                        widget.assetdist.residentialCount +
                        widget.assetdist.landCount +
                        1)) *
                100,
            title: '',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
