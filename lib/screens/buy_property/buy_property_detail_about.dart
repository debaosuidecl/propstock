import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';

class BuyPropertyDetailAbout extends StatefulWidget {
  final Property? property;
  const BuyPropertyDetailAbout({super.key, required this.property});

  @override
  State<BuyPropertyDetailAbout> createState() => _BuyPropertyDetailAboutState();
}

class _BuyPropertyDetailAboutState extends State<BuyPropertyDetailAbout> {
  bool truncateAbout = true;

  @override
  Widget build(BuildContext context) {
    var currencyFormatter = NumberFormat.currency(
        locale: 'en_US', symbol: widget.property!.currency);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          child: const Text(
            "About",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Color(0xff1D3354),
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                  color: Color(0xffCBDFF7),
                  borderRadius: BorderRadius.all(Radius.circular(
                    4,
                  ))),
              width: 202,
              height: 37,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.property!.bedNumber} Bed",
                      style: TextStyle(
                          color: MyColors.primary,
                          fontFamily: "Inter",
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    SvgPicture.asset("images/line.svg"),
                    Text(
                      "${widget.property!.bathNumber} Bath",
                      style: TextStyle(
                          color: MyColors.primary, fontFamily: "Inter"),
                    ),
                    SvgPicture.asset("images/line.svg"),
                    Text(
                      "${widget.property!.plotNumber} Plot",
                      style: TextStyle(
                          color: MyColors.primary, fontFamily: "Inter"),
                    )
                  ]),
            ),
            Text(
              "${currencyFormatter.format(widget.property!.pricePerUnit)}",
              style: TextStyle(
                color: MyColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.property!.about}",
                maxLines: truncateAbout ? 4 : null,
                overflow: truncateAbout ? TextOverflow.ellipsis : null,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 2,
                  fontFamily: "Inter",
                  color: Color(0xff5E6D85),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              if (truncateAbout)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      truncateAbout = !truncateAbout;
                    });
                  },
                  child: Text(
                    "Read More",
                    style: TextStyle(color: MyColors.primary),
                  ),
                ),
              if (!truncateAbout)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      truncateAbout = !truncateAbout;
                    });
                  },
                  child: Text(
                    "Less",
                    style: TextStyle(color: MyColors.primary),
                  ),
                )
            ],
          ),
        ),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
