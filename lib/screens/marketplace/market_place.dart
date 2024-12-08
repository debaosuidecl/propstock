import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/market_place.dart';
import 'package:propstock/providers/marketplace.dart';
import 'package:propstock/screens/marketplace/market_place_filter.dart';
import 'package:propstock/screens/marketplace/market_place_products.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class MarketPlace extends StatefulWidget {
  static const id = "marketplace";
  const MarketPlace({super.key});

  @override
  State<MarketPlace> createState() => _MarketPlaceState();
}

class _MarketPlaceState extends State<MarketPlace> {
  int _pageIndex = 0;
  bool _loading = true;
  List<MarketPlaceProduct> _marketplist = [];
  String _propertyTypeSelect = "All";
  List<String> _fProp = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      setState(() {
        _loading = true;
      });
      List<MarketPlaceProduct> marketplist =
          await Provider.of<MarketPlaceProvider>(context, listen: false)
              .fetchMarketPlace(0, 100);

      // console.log(ma)
      List<String> fProp =
          Provider.of<MarketPlaceProvider>(context, listen: false).allProps;
      List<String> uniqueListFprop = [];
      if (fProp.isNotEmpty) {
        Set<String> uniqueItems = Set<String>.from(fProp);
        uniqueListFprop = uniqueItems.toList();

        print("the prop is not empty");
      }

      print("this is the fprop list ooooo");
      uniqueListFprop.removeWhere((element) => element.isEmpty);
      print(uniqueListFprop);
      setState(() {
        // _buyProperties = buyProperties;
        _marketplist = marketplist;

        _loading = false;
        _fProp = uniqueListFprop;
      });
      print(marketplist);
    } catch (e) {
      showErrorDialog(e.toString(), context);
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
      appBar: !Navigator.canPop(context)
          ? null
          : AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: MyColors.primaryDark,
                  )),
            ),
      body: SafeArea(
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: Platform.isIOS
                    ? null
                    : [
                        BoxShadow(
                            color: Color(0xffeeeeee),
                            spreadRadius: 3,
                            blurRadius: 5)
                      ]),
            padding: const EdgeInsets.symmetric(
              // horizontal: 8.0,
              vertical: 20.0,
            ),
            // width: MediaQuery.of(context).size.w,
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 18.0,
                        ),
                        child: Text(
                          "Market Place",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Inter",
                            color: Color(0xff011936),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, MarketPlaceFilter.id)
                              .then((value) async {
                            try {
                              // await Provider.of<fet>(context,
                              //         listen: false)
                              //     .queryPropertyWithFilter(20, 0);
                              _fetchProducts();
                            } catch (e) {
                              showErrorDialog(
                                  "Could not fetch filtered results", context);
                            }
                          });
                          // MarketPlace
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: SvgPicture.asset(
                            "images/FunnelSimple.svg",
                            height: 24,
                            semanticsLabel: 'Acme Logo',
                          ),
                        ),
                      ),
                    ]),
              ],
            ),
          ),
          if (_fProp.isNotEmpty)
            SizedBox(
              height: 20,
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
                        print("filter item");
                        print(filterItem);
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
                                : const EdgeInsets.only(right: 10, bottom: 20),
                            decoration: const BoxDecoration(
                                color: Color(0xffE0EAF6),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    filterItem.isNotEmpty
                                        ? filterItem
                                        : "Clear Filter",
                                    style: const TextStyle(
                                      color: Color(0xff5E6D85),
                                      fontSize: 14,
                                      fontFamily: "Inter",
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Provider.of<MarketPlaceProvider>(context,
                                              listen: false)
                                          .removeFromAllProp(filterItem);
                                      setState(() {
                                        _loading = true;
                                      });
                                      _fetchProducts();

                                      List<String> fProp =
                                          Provider.of<MarketPlaceProvider>(
                                                  context,
                                                  listen: false)
                                              .allProps;
                                      List<String> uniqueListFprop = [];
                                      if (fProp.isNotEmpty) {
                                        Set<String> uniqueItems =
                                            Set<String>.from(fProp);
                                        uniqueListFprop = uniqueItems.toList();
                                      }
                                      setState(() {
                                        // _loading = false;
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

          // Container(
          //   color: Color(0xffEBEDF0),
          //   height: 2,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       Container(
          //         height: 2,
          //         width: MediaQuery.of(context).size.width / 10,
          //         color: _pageIndex == 0 ? Colors.blue : Color(0xffebedf0),
          //       ),
          //       Container(
          //         height: 12,
          //         width: MediaQuery.of(context).size.width / 10,
          //         color: _pageIndex == 1 ? Colors.blue : Color(0xffebedf0),
          //       ),
          //     ],
          //   ),
          // ),

          if (_loading)
            Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: LinearProgressIndicator()),
          if (!_loading && _marketplist.isEmpty)
            Container(
              child: Text("There are no  properties in the market place"),
            ),
          if (!_loading && _marketplist.isNotEmpty)
            Expanded(child: MarketPlaceProducts(marketplist: _marketplist))
        ]),
      ),
    );
  }
}
