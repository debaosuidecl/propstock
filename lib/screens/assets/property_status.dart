import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/assets.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/providers/assets.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/providers/portfolio.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/assets/co_invest_asset.dart';
import 'package:propstock/screens/assets/property_status_coinvestors.dart';
import 'package:propstock/screens/property_detail/property_detail.dart';
import 'package:propstock/screens/property_detail/property_detail_documents.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/InvestAssetCard.dart';
import 'package:propstock/widgets/investAssetCardb.dart';
import 'package:propstock/widgets/overlappeditemlist.dart';
import 'package:propstock/widgets/purchaseAssetCard.dart';
import 'package:propstock/widgets/purchaseAssetCardb.dart';
import 'package:provider/provider.dart';

class PropertyStatus extends StatefulWidget {
  static const id = "PropertyStatus";
  const PropertyStatus({super.key});

  @override
  State<PropertyStatus> createState() => _PropertyStatusState();
}

class _PropertyStatusState extends State<PropertyStatus> {
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
  bool error = false;
  final List<String> _statusTypes = [
    "All",
    "Completed",
    "Incomplete",
    // "Luxury Apartment",
  ];
  List<String> _fProp = [];
  String _assetStatusSelect = "All";
  double _amountPaid = 0;
  @override
  initState() {
    super.initState();
    _searchAssets("");
    fetchAmountPaid();
  }
  // initState

  Future<String> fetchAmountPaid() async {
    String percentage = "";
    try {
      final String investmentId =
          Provider.of<PropertyProvider>(context, listen: false)
              .selectedInvestmentId;
      double amountPaid =
          await Provider.of<AssetsProvider>(context, listen: false)
              .fetchAmountPaid(investmentId);

      // percentage = percentageb;
      setState(() {
        _amountPaid = amountPaid;
        // loading = false;
      });

      print("go amoutn paid $amountPaid");
      return "$amountPaid";
    } catch (e) {
      print(e);
      setState(() {
        error = true;
      });
      showErrorDialog("Cannot get amount paid", context);
    } finally {
      setState(() {
        loading = false;
      });
    }

    return percentage;
  }
  // Future<void> fetchInvestmentAsset() async {
  //   // String percentage = "";
  //   try {
  //     final String investmentId =
  //         Provider.of<PropertyProvider>(context, listen: false)
  //             .selectedInvestmentId;
  //     double amountPaid =
  //         await Provider.of<AssetsProvider>(context, listen: false)
  //             .fetchAmountPaid(investmentId);

  //     // // percentage = percentageb;
  //     // setState(() {
  //     //   _amountPaid = amountPaid;
  //     //   // loading = false;
  //     // });

  //     // print("go amoutn paid $amountPaid");
  //     // return "$amountPaid";
  //   } catch (e) {
  //     print(e);
  //     setState(() {
  //       error = true;
  //     });
  //     showErrorDialog("Cannot get amount paid", context);
  //   } finally {
  //     setState(() {
  //       loading = false;
  //     });
  //   }

  //   // return percentage;
  // }

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
    final AssetModel asset =
        ModalRoute.of(context)!.settings.arguments as AssetModel;
    NumberFormat formatter = NumberFormat.currency(
        locale: 'en_US', symbol: '${asset.userInvestment!.property.currency} ');
    DateFormat formatterdate = DateFormat('dd MMMM yyyy');

    final List<User> totalCoInvestors = asset.userInvestment!.coInvestors +
        // asset.userInvestment!.
        [
          User(
              firstName: "${asset.userInvestment!.investor!.firstName}",
              avatar: "${asset.userInvestment!.investor!.avatar}",
              lastName: "${asset.userInvestment!.investor!.lastName}",
              userName: "${asset.userInvestment!.investor!.userName}",
              id: "${asset.userInvestment!.investor!.id}")
        ];

    print(asset.userInvestment!.coInvestAmount);

    // fetchAmountPaid(asset.userInvestment!.id);
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
      body: loading
          ? Center(child: CircularProgressIndicator())
          : error
              ? Center(
                  child: Column(children: [
                    Text("An Error occured"),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Go Back",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ]),
                )
              : GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SafeArea(
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "Property Status",
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
                        if (asset.userInvestment != null)
                          Container(
                            // color: Colors.blue,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: GestureDetector(
                              onTap: () {},
                              child: InvestAssetCardB(
                                  mode: "Init",
                                  userInvestment: asset.userInvestment),
                            ),
                          ),
                        if (asset.userInvestment == null)
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: GestureDetector(
                              onTap: () {},
                              child: PurchaseAssetCardB(
                                  userPurchase: asset.userPurchase),
                            ),
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Provider.of<PropertyProvider>(context,
                                    listen: false)
                                .setSelectedProperty(
                                    asset.userInvestment!.property);
                            Navigator.pushNamed(context, PropertyDetail.id);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.centerRight,
                            child: Text(
                              "See full details >",
                              style: TextStyle(
                                color: MyColors.primary,
                                fontSize: 14,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (asset.userInvestment!.coInvestors.isNotEmpty)
                          Container(
                            width: double.infinity,
                            height: 58,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                border: Border.all(color: Color(0xffCBDFF7))),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Co-investors",
                                    style: TextStyle(
                                      color: Color(0xff1D3354),
                                      fontSize: 16,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .25,
                                        height: 120,
                                        // color: Colors.green,
                                        alignment: Alignment.topRight,
                                        child: OverLappedItemList(
                                          users: totalCoInvestors,
                                          offset: 20,
                                          isRight: true,
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              PropertyStatusCoInvestors.id,
                                              arguments: {
                                                'totalCoInvestors':
                                                    totalCoInvestors,
                                                'investment_id':
                                                    asset.userInvestment!.id,
                                              },
                                            );
                                          },
                                          child: SvgPicture.asset(
                                              "images/right_angle.svg"))
                                    ],
                                  ),
                                  // Container(
                                  //   width: 300,
                                  //   height: 50,
                                  //   child: OverLappedItemList(
                                  //       radius: 20,
                                  //       users: asset.userInvestment!.coInvestors),
                                  // )
                                ]),
                          ),
                        SizedBox(
                          height: 20,
                        ),
                        if (asset.userInvestment!.isCoInvestor == true &&
                            asset.userInvestment!.coInvestAmount <= 0)
                          GestureDetector(
                            onTap: () {
                              Provider.of<PropertyProvider>(context,
                                          listen: false)
                                      .selectedInvestmentId =
                                  asset.userInvestment!.id;
                              Navigator.pushNamed(
                                context,
                                CoInvestFinalPageAsset.id,
                                arguments: {
                                  'property': asset.userInvestment!.property,
                                  'coInvestors': totalCoInvestors,
                                  // 'coI'
                                  'investment_id': asset.userInvestment!.id,
                                  'amountPaid': _amountPaid,
                                  'quantity': asset.userInvestment!.quantity,
                                  'amountremaining': asset.userInvestment!
                                              .pricePerUnitAtPurchase *
                                          asset.userInvestment!.quantity -
                                      _amountPaid,
                                  // 'investment_id':
                                  //     asset.userInvestment!.id,
                                },
                              ).then((value) {
                                if (value == "success") {
                                  Navigator.pop(context, 'success');
                                }
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Pending Payment",
                                            style: TextStyle(
                                                color: Color(0xff303030),
                                                fontSize: 16,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(Icons.info)
                                        ],
                                      ),
                                      SvgPicture.asset(
                                          "images/direction_right.svg"),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 5,
                                  ),

                                  Text(
                                    "This property has a pending payment of ${formatter.format(asset.userInvestment!.pricePerUnitAtPurchase * asset.userInvestment!.quantity - _amountPaid)} which is set to expire by 14 Dec, 2022",
                                    style: TextStyle(
                                      color: Color(0xff8E99AA),
                                      fontFamily: "Inter",
                                      fontSize: 14,
                                    ),
                                  )

                                  // Row(
                                  //   children: [

                                  // ],)
                                ],
                              ),
                            ),
                          ),

                        // HorizontalLine(y: y)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Row(
                                    children: [
                                      Text(
                                        "Tracking Progress",
                                        style: TextStyle(
                                            color: Color(0xff303030),
                                            fontSize: 16,
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      // Icon(Icons.info)
                                    ],
                                  ),
                                  SvgPicture.asset(
                                      "images/direction_right.svg"),
                                ],
                              ),

                              SizedBox(
                                height: 5,
                              ),

                              Text(
                                "Follow the step by step process for acquiring this property and track your progress till the end.",
                                style: TextStyle(
                                  color: Color(0xff8E99AA),
                                  fontFamily: "Inter",
                                  fontSize: 14,
                                ),
                              )

                              // Row(
                              //   children: [

                              // ],)
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (asset.userInvestment != null)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                Container(
                                  // height: 70,
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xffeeeeee)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Details",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                              color: Color(0xff1D3354),
                                            ),
                                          ),
                                          Icon(
                                            Icons.keyboard_arrow_up_sharp,
                                            color: Color(0xffbbbbbb),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Total Units bought",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color(0xff5E6D85),
                                            ),
                                          ),
                                          Text(
                                            "${asset.userInvestment!.quantity} Units",
                                            style: TextStyle(
                                              color: Color(0xff303030),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Total Price",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color(0xff5E6D85),
                                            ),
                                          ),
                                          Text(
                                            formatter.format(asset
                                                    .userInvestment!
                                                    .pricePerUnitAtPurchase *
                                                asset.userInvestment!.quantity),
                                            style: const TextStyle(
                                              color: Color(0xff303030),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Amount Paid",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color(0xff5E6D85),
                                            ),
                                          ),
                                          Text(
                                            formatter.format(_amountPaid),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Inter",
                                              color: Color(0xff5E6D85),
                                            ),
                                          )
                                          // FutureBuilder<String>(
                                          //   future: ,
                                          //   builder: (BuildContext context,
                                          //       AsyncSnapshot<String> snapshot) {
                                          //     if (snapshot.connectionState ==
                                          //         ConnectionState.waiting) {
                                          //       return CircularProgressIndicator();
                                          //     } else if (snapshot.hasError) {
                                          //       return Text(
                                          //         'Error: ${snapshot.error}',
                                          //         style: TextStyle(color: Colors.red),
                                          //       );
                                          //     } else if (snapshot.hasData) {
                                          //       return Text(
                                          //         formatter.format(
                                          //             double.parse(_amountPaid)),
                                          //         style: TextStyle(
                                          //           fontSize: 14,
                                          //           fontFamily: "Inter",
                                          //           color: Color(0xff5E6D85),
                                          //         ),
                                          //       );
                                          //     } else {
                                          //       return Text('No data found');
                                          //     }
                                          //   },
                                          // ),
                                          // Text(
                                          //   formatter.format(
                                          //       asset.userInvestment!.coInvestAmount),
                                          //   style: TextStyle(
                                          //     color: Color(0xff303030),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Amount Pending",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color(0xff5E6D85),
                                            ),
                                          ),
                                          //  Text("")
                                          Text(
                                            formatter.format(asset
                                                        .userInvestment!
                                                        .pricePerUnitAtPurchase *
                                                    asset.userInvestment!
                                                        .quantity -
                                                _amountPaid),
                                            style: TextStyle(
                                              color: Color(0xff303030),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Total Percentage",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color(0xff5E6D85),
                                            ),
                                          ),
                                          Text(
                                            "${(_amountPaid * 100 / (asset.userInvestment!.property.pricePerUnit * asset.userInvestment!.quantity)).toStringAsFixed(2)}%",
                                            style: TextStyle(
                                              color: Color(0xff303030),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Number of Co-investors",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color(0xff5E6D85),
                                            ),
                                          ),
                                          Text(
                                            "${(asset.userInvestment!.coInvestors.length + 1)}",
                                            style: TextStyle(
                                              color: Color(0xff303030),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Status",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color(0xff5E6D85),
                                            ),
                                          ),
                                          Text(
                                            asset.userInvestment!.complete ==
                                                    true
                                                ? "Complete"
                                                : "Incomplete",
                                            style: TextStyle(
                                              color: Color(0xff303030),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Auto-invest",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color(0xff5E6D85),
                                            ),
                                          ),
                                          Text(
                                            "Inactive",
                                            style: TextStyle(
                                              color: Color(0xff303030),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Payment Date",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color(0xff5E6D85),
                                            ),
                                          ),
                                          Text(
                                            // "${asset.userInvestment!.createdAt}",
                                            formatterdate.format(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    asset.userInvestment!
                                                        .createdAt as int)),
                                            // "${asset.userInvestment!.createdAt}",
                                            style: TextStyle(
                                              color: Color(0xff303030),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Maturity Date",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color(0xff5E6D85),
                                            ),
                                          ),
                                          Text(
                                            // "${asset.userInvestment!.createdAt}",
                                            formatterdate.format(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    asset.userInvestment!
                                                        .maturityDate)),
                                            // "${asset.userInvestment!.createdAt}",
                                            style: const TextStyle(
                                              color: Color(0xff303030),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        SizedBox(
                          height: 20,
                        ),
                        if (asset.userInvestment == null)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: PropertyMoreDocuments(
                                property: asset.userPurchase!.property),
                          )
                      ],
                    )),
                  )),
    );
  }
}
