import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/providers/property.dart';
// import 'package:propstock/screens/property_detail.dart';
import 'package:propstock/screens/property_detail/property_detail.dart';
import 'package:provider/provider.dart';

class InvestCard extends StatelessWidget {
  final Property property;
  InvestCard({super.key, required this.property});
//"images/prop_img.png"
  @override
  Widget build(BuildContext context) {
    double fractionOfAvailableUnits = (int.parse('${property.totalUnits}') -
            int.parse('${property.availableUnit}')) /
        int.parse('${property.totalUnits}');
    NumberFormat formatter =
        NumberFormat.currency(locale: 'en_US', symbol: '${property.currency} ');
    // String formattedAmount = currencyFormatter.format(amount);

    return GestureDetector(
      onTap: () {
        Provider.of<PropertyProvider>(context, listen: false)
            .setSelectedProperty(property);
        Navigator.pushNamed(context, PropertyDetail.id);
      },
      child: Container(
        // height: ,
        margin: EdgeInsets.only(bottom: 25),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          // vertical: 0,
        ),
        decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xffCBDFF7),
              width: 1.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0), // Rounded corners
                  child: Image.network(
                    property.propImage, // Replace with your image URL
                    width: 120, // Adjust the width of the displayed image
                    height: 120, // Adjust the height of the displayed image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Container(
                // color: Colors.green,
                // height: 160,
                padding: EdgeInsets.symmetric(vertical: 20),

                width: MediaQuery.of(context).size.width * .37,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      property.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Color(
                          0xff011936,
                        ),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Inter",
                      ),
                    ),
                    Text(
                      property.location,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Color(
                          0xff5E6D85,
                        ),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Inter",
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${formatter.format(property.pricePerUnit)}/unit",
                      style: const TextStyle(
                        color: Color(
                          0xff011936,
                        ),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter",
                      ),
                    ),
                    if (int.parse('${property.availableUnit}') <
                        int.parse('${property.totalUnits}'))
                      Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Stack(
                            // fit: StackFit.passthrough,
                            children: [
                              Positioned(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * .37,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Color(0xffEBEDF0),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      .37 *
                                      (fractionOfAvailableUnits),
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 20,
                            // padding: EdgeInsets.(20),
                            width: MediaQuery.of(context).size.width * .45,
                            // color: Colors.green,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "${(fractionOfAvailableUnits * 100).toStringAsFixed(2)}% funded",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xff5E6D85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (int.parse('${property.availableUnit}') == 0)
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        width: MediaQuery.of(context).size.width * .47,
                        child: Row(children: [
                          SvgPicture.asset("images/CheckCircle.svg"),
                          Text(
                            "Fully funded",
                            style: TextStyle(
                              color: Color(0xff5E6D85),
                              fontSize: 10,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ]),
                      )
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
