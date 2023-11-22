import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';

class PropertyDetailImportantStatistics extends StatefulWidget {
  final Property? property;
  const PropertyDetailImportantStatistics({super.key, required this.property});

  @override
  State<PropertyDetailImportantStatistics> createState() =>
      _PropertyDetailImportantStatisticsState();
}

class _PropertyDetailImportantStatisticsState
    extends State<PropertyDetailImportantStatistics> {
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Important Statistics",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Color(0xff1D3354),
                ),
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
                "Market cap price",
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
                    "60 Million",
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
            height: 20,
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
                    "0.00%",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: MyColors.neutral,
                    ),
                  ),
                  SvgPicture.asset("images/InfoItem.svg")
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Revenue/mo",
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
                    "${widget.property!.currency} 0.00",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: MyColors.neutral,
                    ),
                  ),
                  SvgPicture.asset("images/InfoItem.svg")
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Net profit",
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
                    "${widget.property!.currency} 0.00",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: MyColors.neutral,
                    ),
                  ),
                  SvgPicture.asset("images/InfoItem.svg")
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Gross profit",
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
                    "${widget.property!.currency} 0.00",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: MyColors.neutral,
                    ),
                  ),
                  SvgPicture.asset("images/InfoItem.svg")
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Dividend Yield",
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
                    "0.00%",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: MyColors.neutral,
                    ),
                  ),
                  SvgPicture.asset("images/InfoItem.svg")
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
