import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';

class ListingHouseFeatures extends StatefulWidget {
  final Property? property;
  const ListingHouseFeatures({super.key, required this.property});

  @override
  State<ListingHouseFeatures> createState() => _ListingHouseFeaturesState();
}

class _ListingHouseFeaturesState extends State<ListingHouseFeatures> {
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
                "House Features",
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
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Wrap(
            children: widget.property!.facilities!
                .map((e) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: EdgeInsets.only(right: 10, bottom: 10),
                    decoration: BoxDecoration(
                        color: Color(0xffE0EAF6),
                        borderRadius: BorderRadius.all(Radius.circular(32))),
                    child: Text("$e")))
                .toList(),
          )
        ],
      ),
    );
  }
}
