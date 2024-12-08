import 'package:flutter/material.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/screens/affiliate/ListingHouseFeatures.dart';
import 'package:propstock/screens/affiliate/listing_property_detail_about.dart';
import 'package:propstock/screens/affiliate/listing_property_more_information.dart';
import 'package:propstock/screens/affiliate/property_docs_new.dart';
import 'package:propstock/screens/property_detail/property_detail.about.dart';
import 'package:propstock/screens/property_detail/property_detail.location.dart';
import 'package:propstock/screens/property_detail/property_detail.tags.dart';
import 'package:propstock/screens/property_detail/property_detail_documents.dart';
import 'package:propstock/screens/property_detail/property_more_information.dart';
import 'package:propstock/widgets/direction_image_slider.dart';
import 'package:propstock/widgets/invest_buttons.dart';

class ListingPropertyDetailOverview extends StatefulWidget {
  final Property? property;
  const ListingPropertyDetailOverview({
    super.key,
    required this.property,
  });

  @override
  State<ListingPropertyDetailOverview> createState() =>
      _ListingPropertyDetailOverviewState();
}

class _ListingPropertyDetailOverviewState
    extends State<ListingPropertyDetailOverview> {
  int imageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .7,
        // padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Stack(
                // fit: StackFit.expand,
                children: [
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 100),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: Image.network(
                      widget.property!.imagesList![imageIndex],
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
                        if (imageIndex ==
                            widget.property!.imagesList!.length - 1) {
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
                    itemCount: widget.property!.imagesList!.length,
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
              // InvestButtons(
              //   property: widget.property,
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListingPropertyDetailAbout(property: widget.property),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: PropertyDetailLocation(property: widget.property),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child:
                    ListingPropertyMoreInformation(property: widget.property),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListingHouseFeatures(property: widget.property),
              ),
              // const SizedBox(
              //   height: 50,
              // ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: PropertyDocsNew(property: widget.property),
              ),
              // const SizedBox(
              //   height: 50,
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10),
              //   child: PropertyDetailTags(property: widget.property),
              // ),
            ],
          ),
        ));
  }
}
