import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/providers/listings.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/affiliate/about_listing_property.dart';
import 'package:propstock/screens/affiliate/listing.dart';
import 'package:propstock/screens/affiliate/listing_property_detail.dart';
import 'package:propstock/screens/affiliate/select_listing_type.dart';
import 'package:propstock/screens/affiliate/sign_exlusivity_form_action.dart';
import 'package:propstock/screens/dashboard.dart';
import 'package:propstock/screens/loading_screen.dart';
import 'package:propstock/screens/property_detail/property_detail.dart';
import 'package:propstock/screens/verify_identity/identityUpload.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/listing_card.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class AffiliateListing extends StatefulWidget {
  static const id = "AffiliateListing";
  const AffiliateListing({super.key});

  @override
  State<AffiliateListing> createState() => _AffiliateListingState();
}

class _AffiliateListingState extends State<AffiliateListing> {
  bool loading = false;
  TextEditingController _controller = new TextEditingController();
  final List<String> _statusTypes = [
    "All",
    "Residential",
    "Commercial",
    "Land",
    // "Luxury Apartment",
  ];
  List<String> _fProp = [];
  String _assetStatusSelect = "All";
  List<Property> _listings = [];
  Timer? _debounceTimer;
  String _currentQuery = '';

  @override
  void initState() {
    // TODO: implement initState
    _fetchListing();
    super.initState();
  }

  bool disabledFunc() {
    return false;
  }

  bool isLastPage(BuildContext context) {
    return ModalRoute.of(context)?.isCurrent ?? false;
  }

  void _onSearchTextChanged(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_currentQuery != query) {
        setState(() {
          _currentQuery = query;
          _listings = [];
        });
        _fetchListing(search: query);
      }
    });
  }

  Future<void> _fetchListing({String? propertyType, String? search}) async {
    try {
      setState(() {
        loading = true;
      });
      var listings = await Provider.of<ListingsProvider>(context, listen: false)
          .fetchListings(
        search: search,
        page: 0,
        propertyType: propertyType,
      );

      setState(() {
        _listings = _listings + listings;
      });
    } catch (e) {
      showErrorDialog(e.toString(), context);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            // if (isLastPage(context)) {
            Navigator.pushNamedAndRemoveUntil(
                context, LoadingScreen.id, (route) => false);
            // }
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * .9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "My Listings",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff1D3354),
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
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
                                  _listings = [];
                                  // _loading = true;
                                });
                                _fetchListing(propertyType: propertyType);

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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
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
                      label: Text('Search...',
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
                if (loading)
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: LinearProgressIndicator()),
                if (!loading && _listings.isEmpty)
                  Column(
                    children: [
                      SizedBox(
                        height: 150,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("images/undraw_house.svg"),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "No listing yet!",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xff8E99AA),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Click ‘+’ to add new listing as affiliate",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w200,
                          fontSize: 14,
                          color: Color(0xff8E99AA),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          _fetchListing();
                        },
                        child: Text(
                          "Reload",
                          style: TextStyle(
                            color: MyColors.primary,
                          ),
                        ),
                      )
                    ],
                  ),
                if (_listings.isNotEmpty)
                  SizedBox(
                    height: 30,
                  ),
                if (_listings.isNotEmpty)
                  Expanded(
                      child: ListView.builder(
                          itemCount: _listings.length,
                          itemBuilder: (ctx, idx) {
                            Property prop = _listings[idx];
                            return GestureDetector(
                                onTap: () {
                                  // Navigator.pushNamed(context, routeName)
                                  Provider.of<PropertyProvider>(context,
                                          listen: false)
                                      .setSelectedProperty(prop);
                                  Navigator.pushNamed(
                                      context, ListingPropertyDetail.id);
                                },
                                child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: ListingCard(prop: prop)));
                          }))
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AboutListingProperty.id);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
