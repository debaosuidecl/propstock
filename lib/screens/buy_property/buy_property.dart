import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/providers/buy.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/buy_property/buy_property_detail.overview.dart';
import 'package:propstock/screens/buy_property/filter_buy_property.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/single_buy_card.dart';
import 'package:provider/provider.dart';

class BuyProperty extends StatefulWidget {
  const BuyProperty({super.key});

  @override
  State<BuyProperty> createState() => _BuyPropertyState();
}

class _BuyPropertyState extends State<BuyProperty> {
  final List<String> _propertyTypeList = [
    "All",
    "Land",
    "Residential",
    "Luxury Apartment",
  ];
  List<String> _fProp = [];
  String _propertyTypeSelect = "All";
  int page = 0;
  bool _loading = true;

  List<Property> _buyProperties = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<PropertyProvider>(context, listen: false).setCoInvestors([]);
    Provider.of<PropertyProvider>(context, listen: false).setFriendAsGift(null);
    Provider.of<PropertyProvider>(context, listen: false)
        .setUserShareInCoInvestment(0);
    _fetchBuyProperties(propertyType: "All");
  }

  Future<void> _fetchBuyProperties({String? propertyType}) async {
    try {
      // await
      // if(filter)
      setState(() {
        _loading = true;
      });
      List<Property> buyProperties =
          await Provider.of<BuyPropertyProvider>(context, listen: false)
              .getBuyProperties(page, propertyType: propertyType);

      List<String> fProp =
          Provider.of<BuyPropertyProvider>(context, listen: false).allProps;
      List<String> uniqueListFprop = [];
      if (fProp.isNotEmpty) {
        Set<String> uniqueItems = Set<String>.from(fProp);
        uniqueListFprop = uniqueItems.toList();
      }
      setState(() {
        _buyProperties = buyProperties;
        _loading = false;
        _fProp = uniqueListFprop;
      });
    } catch (e) {
      showErrorDialog("Failed to fecth properties", context);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Buy Property",
                    style: TextStyle(
                        color: MyColors.secondary,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter"),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(FilterBuyProperty.id)
                          .then((value) {
                        _fetchBuyProperties();
                      });
                    },
                    child: SvgPicture.asset(
                      "images/FunnelSimple.svg",
                      height: 24,
                      semanticsLabel: 'Acme Logo',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            if (_fProp.isEmpty)
              Container(
                height: 66,
                // width: MediaQuery.of(context).size.width,

                child: Row(
                  children: [
                    Expanded(
                      child: ListView(
                        // shrinkWrap: true,
                        // itemExtent: 20,

                        scrollDirection: Axis
                            .horizontal, // Set the scroll direction to horizontal

                        children: _propertyTypeList.map((propertyType) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _propertyTypeSelect = propertyType;
                              });

                              _fetchBuyProperties(propertyType: propertyType);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 13),
                              // width: 10,
                              margin: propertyType == "All"
                                  ? EdgeInsets.only(
                                      left: 20, right: 10, bottom: 20)
                                  : EdgeInsets.only(right: 10, bottom: 20),
                              decoration: BoxDecoration(
                                  color: _propertyTypeSelect == propertyType
                                      ? Color(0xff2286FE)
                                      : Color(0xffE0EAF6),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              child: Text(
                                propertyType,
                                style: TextStyle(
                                  color: _propertyTypeSelect == propertyType
                                      ? Colors.white
                                      : Color(0xff5E6D85),
                                  fontSize: 14,
                                  fontFamily: "Inter",
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        // child: ListView.builder(
                        //     shrinkWrap: true,
                        //     itemCount: _propertyTypeList.length,
                        //     scrollDirection: Axis.horizontal,
                        //     itemBuilder: (ctx, index) {
                      ),
                    ),
                  ],
                ),
              ),
            if (_fProp.isNotEmpty)
              Container(
                height: 66,
                // width: MediaQuery.of(context).size.width,

                child: Row(
                  children: [
                    Expanded(
                      child: ListView(
                        // shrinkWrap: true,
                        // itemExtent: 20,

                        scrollDirection: Axis
                            .horizontal, // Set the scroll direction to horizontal

                        children: _fProp.map((filterItem) {
                          return GestureDetector(
                            onTap: () {
                              // setState(() {
                              //   _propertyTypeSelect = propertyType;
                              // });

                              // _fetchBuyProperties(propertyType: filterItem);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 13),
                              // width: 10,
                              margin: _fProp.indexOf(filterItem) == 0
                                  ? const EdgeInsets.only(
                                      left: 20, right: 10, bottom: 20)
                                  : const EdgeInsets.only(
                                      right: 10, bottom: 20),
                              decoration: const BoxDecoration(
                                  color: Color(0xffE0EAF6),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    filterItem,
                                    style: const TextStyle(
                                      color: Color(0xff5E6D85),
                                      fontSize: 14,
                                      fontFamily: "Inter",
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Provider.of<BuyPropertyProvider>(
                                                context,
                                                listen: false)
                                            .removeFromAllProp(filterItem);

                                        _fetchBuyProperties();

                                        List<String> fProp =
                                            Provider.of<BuyPropertyProvider>(
                                                    context,
                                                    listen: false)
                                                .allProps;
                                        List<String> uniqueListFprop = [];
                                        if (fProp.isNotEmpty) {
                                          Set<String> uniqueItems =
                                              Set<String>.from(fProp);
                                          uniqueListFprop =
                                              uniqueItems.toList();
                                        }
                                        setState(() {
                                          _loading = false;
                                          _fProp = uniqueListFprop;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: Color(0xff5E6D85),
                                      ))
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        // child: ListView.builder(
                        //     shrinkWrap: true,
                        //     itemCount: _propertyTypeList.length,
                        //     scrollDirection: Axis.horizontal,
                        //     itemBuilder: (ctx, index) {
                      ),
                    ),
                  ],
                ),
              ),
            // BUY PROPERTIES LIST

            // BuyPropertyList()
            if (_loading)
              Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: LinearProgressIndicator()),
            if (!_loading && _buyProperties.isEmpty)
              Container(
                child: Text("There are no buy properties to display"),
              ),
            if (!_loading && _buyProperties.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: RefreshIndicator(
                    onRefresh: _fetchBuyProperties,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _buyProperties.length,
                        itemBuilder: (ctx, index) {
                          Property prop = _buyProperties[index];
                          print(prop.propImage);
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(
                                BuyPropertyDetailOverview.id,
                                arguments: prop,
                              )
                                  .then((value) {
                                // bool justbought =
                                //     Provider.of<BuyPropertyProvider>(context,
                                //             listen: false)
                                //         .justbought;

                                // if (justbought) {
                                //   _fetchBuyProperties();
                                //   Provider.of<BuyPropertyProvider>(context,
                                //           listen: false)
                                //       .setJustBought(false);
                                // }
                              });
                            },
                            child: SingleBuyCard(
                              property: prop,
                            ),
                          );
                        }),
                  ),
                ),
              )
          ],
        ),
      )),
    );
  }
}
