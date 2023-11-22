import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/screens/property_detail/property_detail.appreciation_roi_chart.dart';
import 'package:propstock/widgets/loading_bar_returns.dart';

class PropertyDetailReturns extends StatefulWidget {
  final Property? property;
  const PropertyDetailReturns({super.key, required this.property});

  @override
  State<PropertyDetailReturns> createState() => _PropertyDetailReturnsState();
}

class _PropertyDetailReturnsState extends State<PropertyDetailReturns> {
  bool _showingChart = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 70,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffeeeeee)),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    "Returns",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Color(0xff1D3354),
                    ),
                  ),
                  SvgPicture.asset("images/InfoItem.svg")
                ],
              ),
              Icon(
                Icons.keyboard_arrow_up_sharp,
                color: Color(0xffbbbbbb),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Property Appreciation/yr",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                  color: MyColors.neutral,
                ),
              ),
              Row(
                children: [
                  Text(
                    "0%",
                    style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: MyColors.neutral),
                  ),
                  SvgPicture.asset("images/InfoItem.svg")
                ],
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Property Equity returns/yr",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                  color: MyColors.neutral,
                ),
              ),
              Row(
                children: [
                  Text(
                    "0%",
                    style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: MyColors.neutral),
                  ),
                  SvgPicture.asset("images/InfoItem.svg")
                ],
              ),
            ],
          ),
          SizedBox(
            height: 100,
          ),
          if (_showingChart)
            Column(
              children: [
                LoadingBar(fraction: .6),
                SizedBox(
                  height: 150,
                ),
                AppreciationRoiChart(property: widget.property),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          GestureDetector(
            onTap: () {
              setState(() {
                _showingChart = !_showingChart;
              });
            },
            child: Text(
              _showingChart ? "Hide Chart" : "Show Chart",
              style: TextStyle(
                color: MyColors.primary,
                fontSize: 12,
                fontFamily: "Inter",
              ),
            ),
          )
        ],
      ),
    );
  }
}
