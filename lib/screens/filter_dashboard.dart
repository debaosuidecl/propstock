import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/country.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/modal_sheet.dart';
import 'package:propstock/screens/property_preference.dart';
import 'package:propstock/screens/state_modal_select.dart';
import 'package:propstock/widgets/filter_selector.dart';
import 'package:provider/provider.dart';

class PageFilter extends StatefulWidget {
  static const id = "filter";
  const PageFilter({super.key});

  @override
  State<PageFilter> createState() => _PageFilterState();
}

class _PageFilterState extends State<PageFilter> {
  final List<String> _propertyTypeOptions = [
    // "All",
    "Land",
    "Residential",
    "Luxury Apartment",
    "Commercial",
  ];

  List<String> selectedPropertyOptions = [];
  final List<String> _investmentTypeOptions = [
    "Rental Income",
    "Buy to Resell",
    "Contract Investment",
  ];

  List<String> selectedInvestmentTypeOptions = [];
  final List<String> status = [
    "Partly funded",
    "Fully funded",
    "Not funded",
  ];
  TextEditingController _stateController = TextEditingController();
  RangeValues values = const RangeValues(1, 1000000);
  FocusNode _focusNode = FocusNode();
  List<String> selectedStatus = [];

  String _selectedState = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initSelections();
  }

  void initSelections() {
    setState(() {
      selectedPropertyOptions =
          Provider.of<PropertyProvider>(context, listen: false)
              .selectedPropertyOptions;
      selectedInvestmentTypeOptions =
          Provider.of<PropertyProvider>(context, listen: false)
              .selectedInvestmentTypeOptions;
      selectedStatus =
          Provider.of<PropertyProvider>(context, listen: false).selectedStatus;

      values = RangeValues(
          Provider.of<PropertyProvider>(context, listen: false).minPrice,
          Provider.of<PropertyProvider>(context, listen: false).maxPrice);
    });
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
    var currencyFormatter = NumberFormat.currency(
        locale: 'en_US',
        symbol: Provider.of<PropertyProvider>(context, listen: true)
            .selectedCurrency);

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
                    selectedInvestmentTypeOptions = [];
                    selectedStatus = [];
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
                    child: SvgPicture.asset("images/close_icon.svg"))
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
                      if (selectedPropertyOptions.contains(item)) {
                        selectedPropertyOptions.remove(item);
                      } else {
                        selectedPropertyOptions.add(item);
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
                    options: _investmentTypeOptions,
                    title: "Investment Type",
                    selected_options: selectedInvestmentTypeOptions,
                    selectOptionHandler: (String item) {
                      if (selectedInvestmentTypeOptions.contains(item)) {
                        selectedInvestmentTypeOptions.remove(item);
                      } else {
                        selectedInvestmentTypeOptions.add(item);
                      }
                      setState(() {});
                    }),
                SizedBox(height: 20),
                FilterSelector(
                    options: status,
                    title: "Status",
                    selected_options: selectedStatus,
                    selectOptionHandler: (String item) {
                      if (selectedStatus.contains(item)) {
                        selectedStatus.remove(item);
                      } else {
                        selectedStatus.add(item);
                      }
                      setState(() {});
                    }),
                SizedBox(height: 20),
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
                    setState(() {
                      values = newRange;
                    });
                  },
                  min: 0,
                  max: 2000000,
                  divisions: 200,

                  // labels: RangeLabels(
                  //   values.start.toStringAsFixed(1),
                  //   values.end.toStringAsFixed(1),
                  // ),
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
                          Provider.of<PropertyProvider>(context, listen: false)
                              .setFilters(
                                  selectedPropertyOptions,
                                  selectedInvestmentTypeOptions,
                                  selectedStatus,
                                  Provider.of<Auth>(context, listen: false)
                                      .country!
                                      .name,
                                  Provider.of<Auth>(context, listen: false)
                                      .selectedState,
                                  values.end,
                                  values.start);

                          Navigator.pop(context);
                          // // setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff2286FE),
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
