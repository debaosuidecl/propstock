import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/country.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/providers/buy.dart';
import 'package:propstock/providers/marketplace.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/modal_sheet.dart';
import 'package:propstock/screens/state_modal_select.dart';
import 'package:propstock/widgets/filter_selector.dart';
import 'package:propstock/widgets/ps_dropdown.dart';
import 'package:provider/provider.dart';

class MarketPlaceFilter extends StatefulWidget {
  static const id = "filter_market_place";
  const MarketPlaceFilter({super.key});

  @override
  State<MarketPlaceFilter> createState() => _MarketPlaceFilterState();
}

class _MarketPlaceFilterState extends State<MarketPlaceFilter> {
  final List<String> _propertyTypeOptions = [
    "All",
    "Land",
    "Home",
    "Luxury Apartment",
    "Commercial",
  ];

  List<String> selectedPropertyOptions = [];
  final List<String> _availabilityOptions = [
    "All",
    "For Sale",
    "Coming Soon",
  ];

  List<String> selectedavailabilitys = [];
  final List<String> furnitures = [
    "All",
    "Furnished",
    "Unfurnished",
  ];

  final List<String> facilities = [
    "Swimming pool",
    "Gym",
    "Theatre",
    "Parking space",
  ];
  List<String> selectedFacilities = [];
  TextEditingController _stateController = TextEditingController();
  RangeValues values = const RangeValues(1, 1000000000);
  double max = 900000000;
  FocusNode _focusNode = FocusNode();
  List<String> selectedfurnitures = [];

  String _selectedState = "";
  String bedNumber = ""; // Initially selected value
  String bathNumber = ""; // Initially selected value

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initSelections();
  }

  void initSelections() {
    setState(() {
      selectedPropertyOptions =
          Provider.of<MarketPlaceProvider>(context, listen: false)
              .selectedPropertyTypes;
      selectedavailabilitys =
          Provider.of<MarketPlaceProvider>(context, listen: false)
              .selectedavailabilitys;
      selectedfurnitures =
          Provider.of<MarketPlaceProvider>(context, listen: false)
              .selectedFurnitures;

      values = RangeValues(
          Provider.of<MarketPlaceProvider>(context, listen: false).minPrice *
              Provider.of<MarketPlaceProvider>(context, listen: false).factor,
          Provider.of<MarketPlaceProvider>(context, listen: false).maxPrice *
              Provider.of<MarketPlaceProvider>(context, listen: false).factor);
    });

    print(values);
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext contextb) {
        return ModalSheet();
      },
    ).then((val) {
      print("I have been popped");
      setState(() {
        _selectedState = "";
        _stateController.clear();
        _focusNode.unfocus();
      });
    });
  }

  void _showModalStateSelectBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext contextb) {
        return StateModalSelect();
      },
    ).then((val) {
      print("I have been popped");
      setState(() {
        _selectedState = "";
        _stateController.clear();
        _focusNode.unfocus();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // double max = values.end;
    var currencyFormatter = NumberFormat.currency(
        locale: 'en_US',
        symbol:
            Provider.of<MarketPlaceProvider>(context, listen: true).currency);

    RangeLabels labels =
        RangeLabels(values.start.toString(), values.end.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          Container(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _selectedState = "";
                    selectedPropertyOptions = [];
                    selectedavailabilitys = [];
                    selectedfurnitures = [];
                    Provider.of<Auth>(context, listen: false)
                        .setCountry(Country(flag: "", name: ""));
                    Provider.of<Auth>(context, listen: false)
                        .setStateOfCountry("");
                    setState(() {});
                  },
                  child: Text(
                    "Clear All",
                    style: TextStyle(
                        color: Color(0xff1D3354),
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                ),
                Text(
                  "Filter",
                  style: TextStyle(
                      color: Color(0xff1D3354),
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SvgPicture.asset("images/close_icon.svg"),
                )
              ],
            ),
          ),
          Divider(),
          // SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                FilterSelector(
                    options: _propertyTypeOptions,
                    title: "Property Type",
                    selected_options: selectedPropertyOptions,
                    selectOptionHandler: (String item) {
                      if (item == "All") {
                        selectedPropertyOptions = [item];
                      } else if (selectedPropertyOptions.contains(item)) {
                        selectedPropertyOptions.remove(item);
                      } else {
                        selectedPropertyOptions.add(item);
                        selectedPropertyOptions.remove("All");
                      }
                      setState(() {});
                    }),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: const Text(
                    "Location",
                    style: TextStyle(
                      color: Color(0xff1D3354),
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showModalBottomSheet(context);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffCBDFF7), width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text(
                        Provider.of<Auth>(context, listen: true)
                                    .country!
                                    .name !=
                                ""
                            ? Provider.of<Auth>(context, listen: true)
                                .country!
                                .name
                            : "Country",
                        style: TextStyle(
                          color: Color(0xff5E6D85),
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w100,
                          fontSize: 12,
                        ),

                        // style: TextStyle(),
                      ),
                      trailing: Image(
                        image: AssetImage("images/dropdownIcon.png"),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    _showModalStateSelectBottomSheet(context);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffCBDFF7), width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text(
                        Provider.of<Auth>(context, listen: true)
                                    .selectedState !=
                                ""
                            ? Provider.of<Auth>(context, listen: true)
                                .selectedState
                            : "State",
                        style: TextStyle(
                          color: Color(0xff5E6D85),
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w100,
                          fontSize: 12,
                        ),

                        // style: TextStyle(),
                      ),
                      trailing: Image(
                        image: AssetImage("images/dropdownIcon.png"),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FilterSelector(
                    options: _availabilityOptions,
                    title: "Availability",
                    selected_options: selectedavailabilitys,
                    selectOptionHandler: (String item) {
                      // if (selectedavailabilitys.contains(item)) {
                      //   selectedavailabilitys.remove(item);
                      // } else {
                      //   selectedavailabilitys.add(item);
                      // }
                      if (item == "All") {
                        selectedavailabilitys = [item];
                      } else if (selectedavailabilitys.contains(item)) {
                        selectedavailabilitys.remove(item);
                      } else {
                        selectedavailabilitys.add(item);
                        selectedavailabilitys.remove("All");
                      }
                      setState(() {});
                    }),
                // SizedBox(height: 5),
                FilterSelector(
                    options: furnitures,
                    title: "Furniture",
                    selected_options: selectedfurnitures,
                    selectOptionHandler: (String item) {
                      if (item == "All") {
                        selectedfurnitures = [item];
                      } else if (selectedfurnitures.contains(item)) {
                        selectedfurnitures.remove(item);
                      } else {
                        selectedfurnitures.add(item);
                        selectedfurnitures.remove("All");
                      }
                      setState(() {});
                    }),
                SizedBox(height: 10),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  width: double.infinity,
                  child: Text(
                    "Facilities",
                    style: TextStyle(
                      color: Color(0xff1D3354),
                      fontSize: 18,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Bed: ",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          PSDropdown(
                            selectedValue: bedNumber,
                            onChanged: (String? value) {
                              setState(() {
                                bedNumber = value.toString();
                              });
                            },
                            itemsToSelect: <String>[
                              "",
                              '1',
                              '2',
                              '3',
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Bath: ",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          PSDropdown(
                            selectedValue: bathNumber,
                            onChanged: (String? value) {
                              setState(() {
                                bathNumber = value.toString();
                              });
                            },
                            itemsToSelect: <String>[
                              "",
                              '1',
                              '2',
                              '3',
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                Container(
                  // height: 96,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  // width: MediaQuery.of(context).size.width,

                  child: Row(
                    children: [
                      // SizedBox(
                      //   width: 20,
                      // ),
                      Expanded(
                        child: Wrap(
                          // shrinkWrap: true,
                          // itemExtent: 20,

                          children: facilities.map((facility) {
                            return GestureDetector(
                              onTap: () {
                                // setState(() {
                                //   _propertyTypeSelect = propertyType;
                                // });

                                // _fetchBuyProperties(propertyType: propertyType);

                                if (facility == "All") {
                                  selectedFacilities = [facility];
                                } else if (selectedFacilities
                                    .contains(facility)) {
                                  selectedFacilities.remove(facility);
                                } else {
                                  selectedFacilities.add(facility);
                                  selectedFacilities.remove("All");
                                }
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 13),
                                // width: 10,
                                margin: EdgeInsets.only(right: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    color: selectedFacilities.contains(facility)
                                        ? Color(0xff2286FE)
                                        : Color(0xffE0EAF6),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                child: Text(
                                  facility,
                                  style: TextStyle(
                                    color: selectedFacilities.contains(facility)
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

                // FilterSelector(
                //     options: furnitures,
                //     title: "Furniture",
                //     selected_options: selectedfurnitures,
                //     selectOptionHandler: (String item) {
                //       if (item == "All") {
                //         selectedfurnitures = [item];
                //       } else if (selectedfurnitures.contains(item)) {
                //         selectedfurnitures.remove(item);
                //       } else {
                //         selectedfurnitures.add(item);
                //         selectedfurnitures.remove("All");
                //       }
                //       setState(() {});
                //     }),
                // SizedBox(height: 10),
                // String formattedAmount = currencyFormatter.format(amount);
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: const Text(
                    "Price Range",
                    style: TextStyle(
                      color: Color(0xff1D3354),
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${currencyFormatter.format(values.start)}",
                      ),
                      Text(
                        "${currencyFormatter.format(values.end)}",
                      ),
                    ],
                  ),
                ),

                RangeSlider(
                  values: values,
                  onChanged: (RangeValues newRange) {
                    print(newRange);
                    setState(() {
                      values = newRange;
                    });
                  },
                  min: 0,
                  max: max,
                  divisions: 200,
                  labels: RangeLabels(
                    values.start.toStringAsFixed(1),
                    values.end.toStringAsFixed(1),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 140,
                      child: ElevatedButton(
                        onPressed: () {
                          Provider.of<MarketPlaceProvider>(context,
                                  listen: false)
                              .setFilters(
                            selectedPropertyOptions,
                            selectedavailabilitys,
                            selectedfurnitures,
                            selectedFacilities,
                            Provider.of<Auth>(context, listen: false)
                                .country!
                                .name,
                            Provider.of<Auth>(context, listen: false)
                                .selectedState,
                            values.end,
                            values.start,
                            bedNumber,
                            bathNumber,
                            // values
                          );

                          Navigator.pop(context);
                          // // setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff2286FE),
                          elevation: 0,
                        ),
                        child: Text("Done"),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),

                SizedBox(
                  height: 50,
                ),
              ]),
            ),
          )
        ]),
      ),
    );
  }
}
