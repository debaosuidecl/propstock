import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/create_new_pin.dart';

import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences extends StatefulWidget {
  static const id = "Preferences";
  const Preferences({super.key});

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  // bool enabledBio = false;
  // bool enabledisplayinfo = false;
  // late final LocalAuthentication auth;
  // bool _supportState = false;
  bool loading = true;
  String? investmentExperience = "";
  String? incomeRange = "";
  String? maritalStatus = "";
  String? religion = "";
  bool? hasPets;
  List<dynamic>? primaryGoals = [];
  List<dynamic>? personalityTypes = [];
  List<dynamic>? preferredStates = [];
  List<String>? selectedPropertyTypes = [];
  int dateOfBirth = 0;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  List<String> stateList = [];
  List<String> personalities = [
    "Cool & Calm",
    "Introvert",
    "Extrovert",
    "Patient",
    "Competitive",
    "Aggressive",
    "Perfectionist",
  ];
  List<String> propertyTypes = [
    "Residential",
    "Industrial",
    "Agriculture",
    "Co-property",
    "Land",
    "Commercial",
    "Special"
  ];
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    loadstateofcountry();
    check();
  }

  Future<void> loadstateofcountry() async {
    try {
      String? country = Provider.of<Auth>(context, listen: false).countrystring;
      await Provider.of<Auth>(context, listen: false)
          .getStatesByCountry(country!);

      setState(() {
        stateList = Provider.of<Auth>(context, listen: false).stateListString;
      });
    } catch (e) {
      showErrorDialog("Could not fetch country states", context);
    }
  }

  bool isInteger(int? value) {
    // Check if the value is not null and is of type int
    return value != null && value is int;
  }

  bool disabledFunc() {
    return investmentExperience == null || selectedPropertyTypes!.length < 2;
  }

  Future<void> check() async {
    try {
      // final prefs = await SharedPreferences.getInstance();
      List<dynamic>? pretypes =
          Provider.of<Auth>(context, listen: false).propertyTypes;

      if (pretypes != null) {
        for (int i = 0; i < pretypes.length; i++) {
          selectedPropertyTypes!.add(pretypes[i].toString());
        }
      }
      setState(() {
        investmentExperience =
            Provider.of<Auth>(context, listen: false).investmentExperience;
        incomeRange = Provider.of<Auth>(context, listen: false).incomeRange;
        primaryGoals = Provider.of<Auth>(context, listen: false).primaryGoals;
        preferredStates =
            Provider.of<Auth>(context, listen: false).preferredStates;

        // hasPets = Provider.of<Auth>(context, listen: false).hasPets;
        loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future _updateProfile() async {
    setState(() {
      loading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false).updateAccount(
        investmentExperience: investmentExperience,
        incomeRange: incomeRange,
        primaryGoals: primaryGoals,
        preferredStates: preferredStates,
        propertyTypes: selectedPropertyTypes,
      );
      // Navigator.pop(context);
      // setState(() {
      //   avatar = img;
      // });
      final snackBar = SnackBar(
        content: Text('Profile successfully updated'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            // Perform some action when the user taps the action button
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      showErrorDialog("Could not update context", context);
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
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Preference",
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
                height: 30,
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: investmentExperience != null
                          ? MyColors.primary
                          : Color(0xffCBDFF7),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    )),
                child: DropdownButton<String>(
                  // iconSize: 2,

                  icon: investmentExperience != null
                      ? SvgPicture.asset("images/down.svg")
                      : SvgPicture.asset("images/downlight.svg"),
                  // icon: SvgPicture.asset("images/down.svg"),
                  hint:
                      Text('Select your level of investment'), // Add hint text
                  underline: Container(),

                  isExpanded: true,
                  value: investmentExperience,
                  onChanged: (String? newValue) {
                    setState(() {
                      investmentExperience = newValue!;
                    });
                  },
                  items: <String>[
                    'Novice',
                    'Beginner',
                    'Intermediate',
                    'Expert'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: maritalStatus != null
                          ? MyColors.primary
                          : Color(0xffCBDFF7),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    )),
                child: DropdownButton<String>(
                  // iconSize: 2,
                  icon: maritalStatus != null
                      ? SvgPicture.asset("images/down.svg")
                      : SvgPicture.asset("images/downlight.svg"),
                  hint: Text('Select your monthly income'), // Add hint text
                  underline: Container(),

                  isExpanded: true,
                  value: incomeRange,
                  onChanged: (String? newValue) {
                    print(newValue);
                    setState(() {
                      incomeRange = newValue;
                    });
                  },
                  items: <String>[
                    // 'Single',
                    // 'Married',
                    // 'Divorced',
                    "\$0 -  \$10,000",
                    "\$10,000 -  \$100,000",
                    "\$100,000 -  \$500,000",
                    "\$500,000 -  above"
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: maritalStatus != null
                              ? MyColors.primary
                              : Color(0xffCBDFF7),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        )),
                    child: DropdownButton<String>(
                      // iconSize: 2,
                      icon: maritalStatus != null
                          ? SvgPicture.asset("images/down.svg")
                          : SvgPicture.asset("images/downlight.svg"),
                      hint: primaryGoals!.isEmpty
                          ? Text('Select your primary purpose')
                          : Text(""), // Add hint text
                      underline: Container(),

                      isExpanded: true,
                      value: null,
                      onChanged: (String? newValue) {
                        print(newValue);
                        setState(() {
                          // incomeRange = newValue;
                          if (primaryGoals!.contains(newValue)) {
                            primaryGoals!.remove(newValue);
                          } else {
                            primaryGoals!.add(newValue);
                          }
                        });
                      },
                      items: <String>[
                        // 'Single',
                        // 'Married',
                        // 'Divorced',
                        "Build wealth",
                        "Retirement",
                        "Source of Income",
                        "Acquire Property",
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Positioned(
                      top: 10,
                      left: 26,
                      child: Container(
                        width: MediaQuery.of(context).size.width * .85,
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          children: primaryGoals!
                              .map((e) => Text(
                                    "${primaryGoals!.indexOf(e) == primaryGoals!.length - 1 ? e : '$e, '}",
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ))
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              //  STATE SELECT

              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                // height: (30 / 2) * 10 + 40,
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: preferredStates!.isNotEmpty
                          ? MyColors.primary
                          : Color(0xffCBDFF7),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    )),
                child: Stack(
                  children: [
                    DropdownButton<String>(
                      // iconSize: 2,
                      icon: preferredStates!.isNotEmpty
                          ? SvgPicture.asset("images/down.svg")
                          : SvgPicture.asset("images/downlight.svg"),
                      hint: preferredStates!.isEmpty
                          ? Text('Select your preferred states')
                          : Text(""), // Add hint text
                      underline: Container(),

                      isExpanded: true,
                      value: null,
                      onChanged: (String? newValue) {
                        print(newValue);
                        setState(() {
                          // incomeRange = newValue;
                          if (preferredStates!.contains(newValue)) {
                            // preferredStates!.remove(newValue);
                          } else {
                            preferredStates!.add(newValue);
                          }
                        });
                      },
                      items: Provider.of<Auth>(context, listen: true)
                          .stateListString
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .8,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        children: preferredStates!
                            .map((e) => Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          preferredStates!.remove(e);
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          top: 3,
                                          bottom: 3,
                                          left: 6,
                                          right: 25,
                                        ),
                                        // width: 100,
                                        margin: EdgeInsets.symmetric(
                                          vertical: 3,
                                          horizontal: 6,
                                        ),
                                        decoration: BoxDecoration(
                                            color: Color(0xffE0EAF6),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4))),
                                        child: Text(
                                          "$e",
                                          style: TextStyle(
                                            fontFamily: "Inter",
                                            color: Color(0xff5E6D85),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 7,
                                      top: 7,
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Icon(
                                          Icons.close,
                                          size: 15,
                                          weight: 100,
                                          color: Color(0xff5E6D85),
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Property Types",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 15),
                child: Text(
                  "What kind of property are you looking for?",
                  style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color(0xff5E6D85)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Wrap(
                  direction: Axis.horizontal,
                  children: propertyTypes.map((item) {
                    return GestureDetector(
                      onTap: () {
                        print("added");
                        print(item);
                        if (selectedPropertyTypes!.contains("$item")) {
                          selectedPropertyTypes!.remove("$item");
                        } else {
                          selectedPropertyTypes!.add("$item");
                        }
                        setState(() {});
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 23, vertical: 14),
                        // width: 10,
                        margin: EdgeInsets.only(right: 5, bottom: 20),
                        decoration: BoxDecoration(
                            color: selectedPropertyTypes!.contains(item)
                                ? MyColors.primary
                                : Color(0xffE0EAF6),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Text(
                          "$item",
                          style: TextStyle(
                              color: selectedPropertyTypes!.contains(item)
                                  ? Colors.white
                                  : Color(0xff5E6D85),
                              fontSize: 13,
                              fontFamily: "Inter"),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 15,
              ),

              if (loading)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: LinearProgressIndicator(),
                ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: PropStockButton(
                    text: "SAVE",
                    disabled: disabledFunc(),
                    onPressed: () {
                      _updateProfile();
                    }),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
