import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:propstock/models/country.dart';
import 'package:http/http.dart' as http;
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/dashboard.dart';
import 'package:propstock/screens/loading_screen.dart';
import 'package:propstock/screens/modal_sheet.dart';
import 'dart:convert';

import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class PropertyPreference extends StatefulWidget {
  static const id = "prop_preference";
  const PropertyPreference({super.key});

  @override
  State<PropertyPreference> createState() => _PropertyPreferenceState();
}

class _PropertyPreferenceState extends State<PropertyPreference> {
  List<Country> _countries = [];
  List<String> _selectedStates = [];
  bool _loading = true;
  List<String> _proptypes = [];
  final FocusNode _focusNode = FocusNode();

  List<String> propTypes1 = [
    "Residential",
    "Industrial",
    "Agriculture",
    "Co-property",
    "Land",
    "Commercial",
    "Special"
  ];
  // final propTypes2 = ["Co-property", "Land", "Commercial"];
  // final propTypes3 = ["Special purpose"];

  final TextEditingController _stateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeSelect();
  }

  Future<void> _initializeSelect() async {
    try {
      List<Country> countries = await _getCountriesData();
      print(countries);
      setState(() {
        _countries = countries;
        _loading = false;
      });
    } catch (e) {
      print(e);
      showErrorDialog("Could not load Country Data", context);
    }
  }

  Future<List<Country>> _getCountriesData() async {
    final response =
        await http.get(Uri.parse('https://restcountries.com/v2/all'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((country) {
        String name = country['name'];
        String flagUrl = country['flags']['png'];
        return Country(flag: flagUrl, name: name);
      }).toList();
    } else {
      throw Exception('Failed to load countries');
    }
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
        _selectedStates = [];
        _stateController.clear();
        _focusNode.unfocus();
      });
    });
  }

  bool buttonActive() {
    var countryExists =
        Provider.of<Auth>(context, listen: false).country!.name != "";

    if (countryExists && _selectedStates.length > 0 && _proptypes.length > 1) {
      return true;
    }
    return false;
  }

  void _showBottomSuccessSheet(BuildContext context) {
    showModalBottomSheet(
      // isDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          // Customize the content of the bottom sheet
          width: 40,
          padding: EdgeInsets.all(16.0),
          child: Column(
            // mainAxisSize: MainAxisSize.c,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Your answers have been saved",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  )),
              SizedBox(
                height: 20,
              ),
              Image(
                image: AssetImage("images/successcircle.png"),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Welcome to Propstock"),
                  SizedBox(
                    width: 10,
                  ),
                  Image(
                    image: AssetImage(
                      "images/confetti.png",
                    ),
                    height: 15,
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .89,
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back_ios,
                                        color: Color(0xff1D3354),
                                      ),
                                      onPressed: () {
                                        // Navigate back to the previous screen when the back button is pressed
                                        Navigator.pop(context);
                                      },
                                    ),
                                    Text(
                                      "4/4",
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    // go to next page without submitting
                                    // go to next page without submitting
                                    await Provider.of<Auth>(context,
                                            listen: false)
                                        .skipQuiz();
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        LoadingScreen.id, (route) => false);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Skip Quiz",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .03,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Property preference",
                              style: TextStyle(
                                color: Color(0xffbbbbbb),
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .01,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "What and where will you prefer ?",
                              style: TextStyle(
                                  color: Color(0xff1D3354),
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                  height: 1.7),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: RichText(
                              text: TextSpan(
                                text: 'Preferred Location ',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xff1D3354),
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '(Optional)',
                                    style: const TextStyle(
                                      color: Color(0xff696969),
                                      fontSize: 10,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Where do you prefer to invest in and acquire property?",
                              style: TextStyle(
                                color: Color(0xff5E6D85),
                                fontFamily: "Inter",
                                fontSize: 16,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .04,
                          ),
                          GestureDetector(
                            onTap: () {
                              _showModalBottomSheet(context);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xffCBDFF7), width: 1),
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
                            height: MediaQuery.of(context).size.height * .01,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            width: MediaQuery.of(context).size.width,
                            height: _selectedStates.length == 0 ? 1 : 50,
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 3,
                                crossAxisCount: 3, // Number of items per row
                              ),
                              itemCount: _selectedStates.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.all(2),
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  // width: 1-0-,
                                  decoration: BoxDecoration(
                                      color: Color(0xffCBDFF7),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 35,
                                        child: Text(
                                          _selectedStates[index],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedStates.removeAt(index);
                                          });
                                        },
                                        child: Image(
                                          image:
                                              AssetImage("images/cancel.png"),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Stack(clipBehavior: Clip.none, children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xffCBDFF7), width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                title: TextField(
                                  // maxLines: 4,
                                  onChanged: (String val) {
                                    try {
                                      Provider.of<Auth>(context, listen: false)
                                          .showStateList(val);
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  focusNode: _focusNode,
                                  controller: _stateController,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 0),
                                      // label: Text(
                                      //   'State',
                                      //   style: TextStyle(fontSize: 12),
                                      // ),
                                      hintText: "State",
                                      hintStyle:
                                          TextStyle(color: Color(0xffbbbbbb)),
                                      border: InputBorder.none),
                                ),
                                // style: TextStyle(),

                                trailing: GestureDetector(
                                    onTap: () {
                                      final stateToAdd = _stateController.text;

                                      if (stateToAdd.isEmpty) return;
                                      setState(() {
                                        _selectedStates.add(stateToAdd);
                                        _stateController.clear();
                                      });
                                      _focusNode.unfocus();
                                    },
                                    child: Icon(Icons.add)),
                              ),
                            ),
                            if (_focusNode.hasFocus)
                              Container(
                                width: MediaQuery.of(context).size.width,
                                // height: 150,
                                constraints: BoxConstraints(
                                    minHeight: 30, maxHeight: 100),
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 60),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xffeeeeee))),
                                child: Provider.of<Auth>(context, listen: true)
                                            .dynamicStateList
                                            .length ==
                                        0
                                    ? ListTile(
                                        title: Text(
                                            "No States Available for selected country"),
                                      )
                                    : ListView.builder(
                                        itemCount: Provider.of<Auth>(context,
                                                listen: true)
                                            .dynamicStateList
                                            .length,
                                        itemBuilder: (context, index) {
                                          String state = Provider.of<Auth>(
                                                  context,
                                                  listen: true)
                                              .dynamicStateList[index];
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedStates.add(state);
                                                _stateController.clear();
                                              });
                                              _focusNode.unfocus();
                                              Provider.of<Auth>(context,
                                                      listen: false)
                                                  .resetStateList();
                                            },
                                            child: ListTile(
                                              title: Text(state),
                                            ),
                                          );
                                        },
                                      ),
                              )
                          ]),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: RichText(
                              text: TextSpan(
                                text: 'Property Types ',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff1D3354),
                                    fontWeight: FontWeight.w600),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "(2 minimum)",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              "What kind of property are you looking for?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff5E6D85),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            width: MediaQuery.of(context).size.width,
                            height: 150,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 3,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 15,
                                crossAxisCount: 3, // Number of items per row
                              ),
                              itemCount: propTypes1.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_proptypes
                                          .contains(propTypes1[index])) {
                                        _proptypes.remove(propTypes1[index]);
                                      } else {
                                        _proptypes.add(propTypes1[index]);
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: _proptypes
                                                .contains(propTypes1[index])
                                            ? Colors.blue
                                            : Color(0xffE0EAF6),
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Container(
                                      // width: 180,
                                      alignment: Alignment.center,
                                      child: Text(
                                        propTypes1[index],
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: _proptypes
                                                    .contains(propTypes1[index])
                                                ? Colors.white
                                                : Color(0xff5E6D85)),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ]),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Navigator.pushNamed(context, LocationSelect.id);
                      // Provider.of<Auth>(context, listen: false)
                      //     .setPrimaryGoals(_primaryGoals);
                      // Navigator.pushNamed(context, IncomeRange.id);

                      // saves all responses
                      // return;
                      if (_selectedStates.isEmpty ||
                          _proptypes.length < 2 ||
                          Provider.of<Auth>(context, listen: false)
                                  .country!
                                  .name ==
                              "") {
                        // print("something is empty");
                        return;
                      }
                      await Provider.of<Auth>(context, listen: false)
                          .submitQuiz(_selectedStates, _proptypes);
                      print("done on front end");
                      _showBottomSuccessSheet(context);

                      await Future.delayed(Duration(seconds: 4));
                      Navigator.pushNamedAndRemoveUntil(
                          context, Dashboard.id, (route) => false);
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: buttonActive()
                            ? Color(0xffffffff)
                            : Color(0xffB0B0B0),
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w200,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: buttonActive()
                            ? Color(0xff2386fe)
                            : Color(0xffEBEDF0),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        elevation: 0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
