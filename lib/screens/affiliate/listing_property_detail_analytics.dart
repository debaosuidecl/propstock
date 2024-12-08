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

class ListingPropertyDetailAnalytics extends StatefulWidget {
  // const ListingPropertyDetailAnalytics({super.key});
  final Property? property;
  ListingPropertyDetailAnalytics({
    super.key,
    required this.property,
  });

  @override
  State<ListingPropertyDetailAnalytics> createState() =>
      _ListingPropertyDetailAnalyticsState();
}

// var myflspot = FlSpot(0, 3).x;

class _ListingPropertyDetailAnalyticsState
    extends State<ListingPropertyDetailAnalytics> {
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

    // _initPropData();
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
                children: [],
              ),
            ),
    );
  }
}
