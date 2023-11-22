import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';

class BuyPropertyFacility extends StatefulWidget {
  final Property property;
  const BuyPropertyFacility({super.key, required this.property});

  @override
  State<BuyPropertyFacility> createState() => _BuyPropertyFacilityState();
}

class _BuyPropertyFacilityState extends State<BuyPropertyFacility> {
  bool truncateAbout = true;

  @override
  Widget build(BuildContext context) {
    // var currencyFormatter = NumberFormat.currency(
    //     locale: 'en_US', symbol: widget.property!.currency);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.property.facilities!.contains("Wifi network"))
              Container(
                height: 120,
                child: Column(children: [
                  SvgPicture.asset("images/wifi.svg"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Wifi network",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xff5E6D85),
                      fontSize: 14,
                    ),
                  ),
                ]),
              ),
            if (widget.property.facilities!.contains("Gym & Fitness"))
              Container(
                height: 120,
                child: Column(children: [
                  SvgPicture.asset("images/fitness.svg"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Gym & Fitness",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xff5E6D85),
                      fontSize: 14,
                    ),
                  ),
                ]),
              ),
            if (widget.property.facilities!.contains("Parking Space"))
              Container(
                height: 120,
                child: Column(children: [
                  SvgPicture.asset("images/parking.svg"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Parking Space",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xff5E6D85),
                      fontSize: 14,
                    ),
                  ),
                ]),
              ),
          ],
        )
      ],
    );
  }
}
