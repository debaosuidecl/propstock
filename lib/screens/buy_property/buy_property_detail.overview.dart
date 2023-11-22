import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/screens/buy_property/buy_property_detail_about.dart';
import 'package:propstock/screens/buy_property/buy_property_facility.dart';
import 'package:propstock/screens/property_detail/property_detail.about.dart';
import 'package:propstock/screens/property_detail/property_detail.location.dart';
import 'package:propstock/screens/property_detail/property_detail.tags.dart';
import 'package:propstock/screens/property_detail/property_detail_documents.dart';
import 'package:propstock/screens/property_detail/property_more_information.dart';
import 'package:propstock/widgets/buy_buttons.dart';
import 'package:propstock/widgets/direction_image_slider.dart';
import 'package:propstock/widgets/invest_buttons.dart';

class BuyPropertyDetailOverview extends StatefulWidget {
  static const id = "buy_property_detail_overview";
  // final Property? property;
  const BuyPropertyDetailOverview({
    super.key,
    // required this.property,
  });

  @override
  State<BuyPropertyDetailOverview> createState() =>
      _BuyPropertyDetailOverviewState();
}

class _BuyPropertyDetailOverviewState extends State<BuyPropertyDetailOverview> {
  int imageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final Property property =
        ModalRoute.of(context)!.settings.arguments as Property;

    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          // padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 35,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SvgPicture.asset(
                          "images/back_arrow.svg",
                          height: 32,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .6,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 18.0,
                        ),
                        child: FittedBox(
                          child: Text(
                            property.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Inter",
                              color: Color(0xff011936),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 18.0,
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset("images/ShareNetwork.svg"),
                            SizedBox(
                              width: 4,
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              padding: EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xffeeeeee),
                                    blurRadius: 3,
                                    spreadRadius: 2,
                                  ),
                                ],
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: SvgPicture.asset("images/Heart.svg"),
                            ),
                          ],
                        ),
                      )
                    ]),
                Stack(
                  // fit: StackFit.expand,
                  children: [
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 100),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      child: Image.network(
                        property!.imagesList![imageIndex],
                        key: ValueKey<int>(imageIndex),
                        // width: double.infinity,
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 15,
                      top: 120,
                      child: GestureDetector(
                        onTap: () {
                          if (imageIndex == property!.imagesList!.length - 1) {
                            setState(() {
                              imageIndex = 0;
                            });
                          } else {
                            setState(() {
                              imageIndex = imageIndex + 1;
                            });
                          }
                        },
                        child: DirectionImageSlider(
                          icon: const Icon(
                            Icons.chevron_right_sharp,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 15,
                      top: 120,
                      child: GestureDetector(
                        onTap: () {
                          if (imageIndex - 1 < 0) {
                            setState(() {
                              imageIndex = 0;
                            });
                          } else {
                            setState(() {
                              imageIndex = imageIndex - 1;
                            });
                          }
                        },
                        child: DirectionImageSlider(
                          icon: const Icon(
                            Icons.chevron_left_sharp,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: property!.imagesList!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 5,
                          margin: EdgeInsets.only(right: 20),
                          width: 5,
                          decoration: BoxDecoration(
                            color: index == imageIndex
                                ? Color(0xff2286fe)
                                : Color(0xffbbbbbb),
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: 15,
                ),
                BuyButtons(
                  property: property,
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: BuyPropertyDetailAbout(property: property),
                ),
                if (property.facilities != null &&
                    property.propertyType != "Land")
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: BuyPropertyFacility(property: property),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: PropertyDetailLocation(property: property),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: PropertyMoreDocuments(property: property),
                ),
                const SizedBox(
                  height: 50,
                ),
                if (property.tags != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: PropertyDetailTags(property: property),
                  ),
              ],
            ),
          )),
    );
  }
}
