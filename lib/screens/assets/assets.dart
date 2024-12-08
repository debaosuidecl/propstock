import 'dart:async';

import 'package:flutter/material.dart';
import 'package:propstock/models/assets.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/providers/assets.dart';
import 'package:propstock/providers/portfolio.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/assets/property_status.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/InvestAssetCard.dart';
import 'package:propstock/widgets/investAssetCardb.dart';
import 'package:propstock/widgets/purchaseAssetCard.dart';
import 'package:propstock/widgets/purchaseAssetCardb.dart';
import 'package:provider/provider.dart';

class Assets extends StatefulWidget {
  static const id = "assets";
  const Assets({super.key});

  @override
  State<Assets> createState() => _AssetsState();
}

class _AssetsState extends State<Assets> {
  bool loading = true;
  String _currentQuery = '';
  TextEditingController _controller = TextEditingController();

  List<AssetModel> _userAssets = [];
  String filter = "all";
  int _page = 0;
  Timer? _debounceTimer;

  final int _limit = 10;
  bool showSeeMore = true;
  bool _loading = true;

  bool _loadingNext = false;
  final List<String> _statusTypes = [
    "All",
    "Completed",
    "Incomplete",
    // "Luxury Apartment",
  ];
  List<String> _fProp = [];
  String _assetStatusSelect = "All";
  @override
  initState() {
    super.initState();
    _searchAssets("");
  }
  // initState

  Future<void> _searchAssets(String searchCriteria,
      {String? propSearch, String? realtimesearch}) async {
    try {
      setState(() {
        filter = searchCriteria;
      });
      final List<AssetModel> userAssets =
          await Provider.of<AssetsProvider>(context, listen: false).fetchAssets(
        searchCriteria,
        _page,
        _limit,
        propSearch: propSearch,
        status: realtimesearch != null ? realtimesearch : _assetStatusSelect,
      );

      print("user assets: $userAssets");

      setState(() {
        if (userAssets.isEmpty) {
          showSeeMore = false;
        }

        if (realtimesearch != null) {
          _userAssets = userAssets;
        } else {
          _userAssets = _userAssets + userAssets;
        }
      });
    } catch (e) {
      showErrorDialog(e.toString(), context);
    } finally {
      setState(() {
        _loading = false;
        _loadingNext = false;
      });
    }
  }

  void _onSearchTextChanged(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_currentQuery != query) {
        setState(() {
          _currentQuery = query;
          _page = 0;
          _loading = true;
          _userAssets = [];
        });
        // _fetchFriends(query);
        _searchAssets(filter, propSearch: query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Assets"),
      // ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xff1D3354),
          ),
          onPressed: () {
            // Navigate back to the previous screen when the back button is pressed
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: SingleChildScrollView(
                child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Assets Acquired",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MyColors.secondary,
                        fontSize: 20,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
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

                            children: _statusTypes.map((propertyType) {
                              return GestureDetector(
                                onTap: () {
                                  print('property type: $propertyType');
                                  setState(() {
                                    _assetStatusSelect = propertyType;
                                    _userAssets = [];
                                    _loading = true;
                                  });
                                  _searchAssets("",
                                      realtimesearch: propertyType);

                                  // _fetchBuyProperties(propertyType: propertyType);
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
                                      color: _assetStatusSelect == propertyType
                                          ? Color(0xff2286FE)
                                          : Color(0xffE0EAF6),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  child: Text(
                                    propertyType,
                                    style: TextStyle(
                                      color: _assetStatusSelect == propertyType
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
                            //     itemCount: _statusTypes.length,
                            //     scrollDirection: Axis.horizontal,
                            //     itemBuilder: (ctx, index) {
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: _controller,
                      // focusNode: _focus,
                      onChanged: (String value) {
                        _onSearchTextChanged(value);
                      },

                      // keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        // prefixIcon: Icon(Icons.search),
                        prefixIcon: Icon(
                          Icons.search,
                        ),

                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        label: Text('Search property',
                            style: TextStyle(fontFamily: "Inter")),
                        hintStyle: TextStyle(color: Color(0xffbbbbbb)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: MyColors.fieldDefault,
                          ), // Use the hex color
                          borderRadius: BorderRadius.circular(
                              8), // You can adjust the border radius as needed
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: MyColors.fieldDefault,
                          ), // Use the hex color
                          borderRadius: BorderRadius.circular(
                              8), // You can adjust the border radius as needed
                        ),
                      ),
                    ),
                  ),
                  if (_loading)
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: LinearProgressIndicator()),

                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: _userAssets.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          AssetModel asset = _userAssets[index];
                          if (asset.userInvestment != null) {
                            return Container(
                              // color: Colors.blue,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: GestureDetector(
                                onTap: () {
                                  Provider.of<PropertyProvider>(context,
                                              listen: false)
                                          .selectedInvestmentId =
                                      asset.userInvestment!.id;
                                  Navigator.pushNamed(
                                    context,
                                    PropertyStatus.id,
                                    arguments: asset,
                                  ).then((value) {
                                    if (value == "success") {
                                      setState(() {
                                        loading = true;
                                      });
                                      setState(() {
                                        _userAssets = [];
                                      });
                                      _searchAssets("");

                                      final snackBar = SnackBar(
                                        backgroundColor: MyColors.primary,
                                        content: Text(
                                          'You have successfully Paid your co investment',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        action: SnackBarAction(
                                          label: 'Done',
                                          onPressed: () {
                                            // Some code to undo the change.
                                          },
                                        ),
                                      );

                                      // Use ScaffoldMessenger to show the SnackBar.
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  });
                                },
                                child: InvestAssetCardB(
                                    mode: "Init",
                                    userInvestment: asset.userInvestment),
                              ),
                            );
                          }

                          return Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  PropertyStatus.id,
                                  arguments: asset,
                                );
                              },
                              child: PurchaseAssetCardB(
                                  userPurchase: asset.userPurchase),
                            ),
                          );
                        }),
                  )
                ],
              ),
            )),
          )),
    );
  }
}
