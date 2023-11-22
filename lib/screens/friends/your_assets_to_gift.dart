import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/assets.dart';
import 'package:propstock/models/colors.dart';

import 'package:propstock/providers/portfolio.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/InvestAssetCard.dart';
import 'package:propstock/widgets/purchaseAssetCard.dart';
import 'package:provider/provider.dart';

class YourAssetsToGift extends StatefulWidget {
  const YourAssetsToGift({super.key});

  @override
  State<YourAssetsToGift> createState() => _YourAssetsToGiftState();
}

class _YourAssetsToGiftState extends State<YourAssetsToGift> {
  TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;
  String _currentQuery = '';
  bool _loading = true;
  bool showSeeMore = true;
  String filter = "all";
  List<AssetModel> _userAssets = [];
  bool _loadingNext = false;
  int _page = 0;
  final int _limit = 10;

  @override
  initState() {
    super.initState();
    _searchAssets("");
  }
  // initState

  Future<void> _searchAssets(String searchCriteria,
      {String? propSearch}) async {
    try {
      setState(() {
        filter = searchCriteria;
      });
      final List<AssetModel> userAssets =
          await Provider.of<PortfolioProvider>(context, listen: false)
              .fetchAssets(
        searchCriteria,
        _page,
        _limit,
        propSearch: propSearch,
      );

      print("user assets: $userAssets");

      setState(() {
        if (userAssets.isEmpty) {
          showSeeMore = false;
        }
        _userAssets = _userAssets + userAssets;
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
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      // Calculate available screen height
      // double screenHeight = constraints.maxHeight;

      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
            child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                height: MediaQuery.of(context).size.height * .8,
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SvgPicture.asset("images/close_icon.svg")),
                          Expanded(
                            child: Text(
                              "Your Assets",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: MyColors.secondary,
                                fontSize: 20,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Text(
                          "Select the asset you want to send as a gift ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: MyColors.secondary,
                            fontFamily: "Inter",
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
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
                          label: Text('Find assets',
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
                      SizedBox(
                        height: 30,
                      ),
                      if (_loading) CircularProgressIndicator(),
                      Expanded(
                        child: ListView.builder(
                            itemCount: _userAssets.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              AssetModel asset = _userAssets[index];
                              if (asset.userInvestment != null) {
                                return GestureDetector(
                                  onTap: () {
                                    Provider.of<PropertyProvider>(context,
                                            listen: false)
                                        .setAssetToGift(asset);
                                    Navigator.pop(context, "send_gift_1");
                                  },
                                  child: InvestAssetCard(
                                      userInvestment: asset.userInvestment),
                                );
                              }

                              return GestureDetector(
                                onTap: () {
                                  Provider.of<PropertyProvider>(context,
                                          listen: false)
                                      .setAssetToGift(asset);

                                  Navigator.pop(context, "send_gift_1");
                                },
                                child: PurchaseAssetCard(
                                    userPurchase: asset.userPurchase),
                              );
                            }),
                      )
                    ],
                  ),
                ))),
      );
    });
    ;
  }
}
