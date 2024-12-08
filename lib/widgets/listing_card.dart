import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/property.dart';
import 'package:provider/provider.dart';

class ListingCard extends StatelessWidget {
  final Property prop;
  const ListingCard({super.key, required this.prop});

  @override
  Widget build(BuildContext context) {
    var currencyFormatter =
        NumberFormat.currency(locale: 'en_US', symbol: prop.currency);
    return Container(
      height: 173,
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 15),
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffCBDFF7)),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              // Background Image
              Container(
                width: 125,
                height: 125,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(9))),
                child: Image.network(
                  prop.propImage,
                  fit: BoxFit.cover,
                ),
              ),
              // Overlay Container
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                decoration: BoxDecoration(
                    color: prop.published == true
                        ? Color(0xffE7F2EC)
                        : Color(0xffFFF4D2),
                    borderRadius: BorderRadius.all(Radius.circular(32))),
                child: Text(
                  prop.published == true ? "Published" : "Pending",
                  style: TextStyle(
                      color: prop.published == true
                          ? Color(0xff0B6E38)
                          : Color(0xffFB6E12)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * .43,
                child: Text(
                  "${prop.name}",
                  maxLines: 1, // Set the maximum number of lines
                  overflow: TextOverflow
                      .ellipsis, // Set overflow handling to ellipses
                  style: TextStyle(fontSize: 16, color: Color(0xff011936)),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width * .43,
                child: Text(
                  "${prop.location},${prop.country}",
                  maxLines: 1, // Set the maximum number of lines
                  overflow: TextOverflow
                      .ellipsis, // Set overflow handling to ellipses
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff5E6D85),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width * .43,
                child: Text(
                  "${currencyFormatter.format(prop.pricePerUnit)}",
                  maxLines: 1, // Set the maximum number of lines
                  overflow: TextOverflow
                      .ellipsis, // Set overflow handling to ellipses
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff011936),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
