import 'package:flutter/material.dart';
// import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';

class PropertyDetailTags extends StatefulWidget {
  final Property? property;
  const PropertyDetailTags({super.key, required this.property});

  @override
  State<PropertyDetailTags> createState() => _PropertyDetailTagsState();
}

class _PropertyDetailTagsState extends State<PropertyDetailTags> {
  // List<dynamic> options = prop;

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
                "Tags",
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
          Wrap(
            direction: Axis.horizontal,
            children: widget.property!.tags!.map((item) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 23, vertical: 14),
                // width: 10,
                margin: EdgeInsets.only(right: 10, bottom: 20),
                decoration: BoxDecoration(
                    color: Color(0xffE0EAF6),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Text(
                  "$item",
                  style: const TextStyle(
                      color: Color(0xff5E6D85),
                      fontSize: 14,
                      fontFamily: "Inter"),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
