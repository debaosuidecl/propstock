import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';

class PropertyMoreInformation extends StatefulWidget {
  final Property? property;
  const PropertyMoreInformation({super.key, required this.property});

  @override
  State<PropertyMoreInformation> createState() =>
      _PropertyMoreInformationState();
}

class _PropertyMoreInformationState extends State<PropertyMoreInformation> {
  @override
  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat.currency(
        locale: 'en_US', symbol: '${widget.property!.currency} ');
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
                "More Information",
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
                "Total Units",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                  color: MyColors.neutral,
                ),
              ),
              Text(
                "${widget.property!.totalUnits}",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: MyColors.neutral,
                ),
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
                "Available Units",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                  color: MyColors.neutral,
                ),
              ),
              Text(
                "${widget.property!.availableUnit}",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: MyColors.neutral,
                ),
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
                "Status",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                  color: MyColors.neutral,
                ),
              ),
              Text(
                "${(widget.property!.availableUnit! / int.parse('${widget.property!.totalUnits}') * 100).round()}% funded",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: MyColors.neutral,
                ),
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
                "Price Per Unit",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                  color: MyColors.neutral,
                ),
              ),
              Text(
                "${formatter.format(widget.property!.pricePerUnit)}",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: MyColors.neutral,
                ),
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
                "Leverage",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                  color: MyColors.neutral,
                ),
              ),
              Text(
                "${widget.property!.leverage}%",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: MyColors.neutral,
                ),
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
                "Volatility",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                  color: MyColors.neutral,
                ),
              ),
              Text(
                "${widget.property!.volatility}",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: MyColors.neutral,
                ),
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
                "Min holding time",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                  color: MyColors.neutral,
                ),
              ),
              Text(
                "${widget.property!.minHoldingTime} Months",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: MyColors.neutral,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
