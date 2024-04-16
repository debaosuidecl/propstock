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

class EditProfileB extends StatefulWidget {
  static const id = "EditProfileB";
  const EditProfileB({super.key});

  @override
  State<EditProfileB> createState() => _EditProfileBState();
}

class _EditProfileBState extends State<EditProfileB> {
  // bool enabledBio = false;
  // bool enabledisplayinfo = false;
  // late final LocalAuthentication auth;
  // bool _supportState = false;
  bool loading = true;
  String? gender = "";
  String? primaryLanguage = "";
  String? maritalStatus = "";
  String? religion = "";
  bool? hasPets;
  List<dynamic>? personalityTypes = [];
  int dateOfBirth = 0;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  List<String> personalities = [
    "Cool & Calm",
    "Introvert",
    "Extrovert",
    "Patient",
    "Competitive",
    "Aggressive",
    "Perfectionist",
  ];
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    check();
  }

  bool isInteger(int? value) {
    // Check if the value is not null and is of type int
    return value != null && value is int;
  }

  bool disabledFunc() {
    return gender == null;
  }

  Future<void> check() async {
    try {
      // final prefs = await SharedPreferences.getInstance();

      setState(() {
        gender = Provider.of<Auth>(context, listen: false).gender;
        primaryLanguage =
            Provider.of<Auth>(context, listen: false).primaryLanguage;
        maritalStatus = Provider.of<Auth>(context, listen: false).maritalStatus;
        religion = Provider.of<Auth>(context, listen: false).religion;
        hasPets = Provider.of<Auth>(context, listen: false).hasPets;

        if (Provider.of<Auth>(context, listen: false).personalityTypes !=
            null) {
          personalityTypes =
              Provider.of<Auth>(context, listen: false).personalityTypes;
        }
        // if(dateOfBirth !=null)

        if (isInteger(Provider.of<Auth>(context, listen: false).dateOfBirth)) {
          dateOfBirth =
              Provider.of<Auth>(context, listen: false).dateOfBirth as int;
        }
        loading = false;
      });

      // _firstNameController.setText("$firstName");
      // _emailController.setText("$email");
      // _lastNameController.setText("$lastName");
      // _phoneController.setText("$phone");

      // if (isInteger(dateOfBirth) && dateOfBirth != 0) {
      //   DateTime formatted = DateTime.fromMillisecondsSinceEpoch(dateOfBirth);
      //   _dateController
      //       .setText("${formatted.day}-${formatted.month}-${formatted.year}");
      // }

      // print("this is the avatar: $avatar");
      // final extractedUserData = prefs.getString("displayinfo");

      // print(extractedUserData);

      // // final biostate = extractedUserData["biometrics_token"];

      // if (extractedUserData != null) {
      //   // if(extractedUserData =)

      //   setState(() {
      //     enabledisplayinfo = true;
      //   });
      // // }
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
        gender: gender,
        primaryLanguage: primaryLanguage,
        maritalStatus: maritalStatus,
        religion: religion,
        hasPets: hasPets,
        personalityTypes: personalityTypes,
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
                  "More Information",
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
                      color:
                          gender != null ? MyColors.primary : Color(0xffCBDFF7),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    )),
                child: DropdownButton<String>(
                  // iconSize: 2,

                  icon: gender != null
                      ? SvgPicture.asset("images/down.svg")
                      : SvgPicture.asset("images/downlight.svg"),
                  // icon: SvgPicture.asset("images/down.svg"),
                  hint: Text('Gender'), // Add hint text
                  underline: Container(),

                  isExpanded: true,
                  value: gender,
                  onChanged: (String? newValue) {
                    setState(() {
                      gender = newValue!;
                    });
                  },
                  items: <String>[
                    'male',
                    'female',
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
                      color: primaryLanguage != null
                          ? MyColors.primary
                          : Color(0xffCBDFF7),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    )),
                child: DropdownButton<String>(
                  // iconSize: 2,
                  icon: primaryLanguage != null
                      ? SvgPicture.asset("images/down.svg")
                      : SvgPicture.asset("images/downlight.svg"),
                  hint: Text('Primary Language'), // Add hint text
                  underline: Container(),

                  isExpanded: true,
                  value: primaryLanguage,
                  onChanged: (String? newValue) {
                    setState(() {
                      primaryLanguage = newValue!;
                    });
                  },
                  items: <String>[
                    'English',
                    'French',
                    'Yoruba',
                    'Hausa',
                    'Igbo',
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
                  hint: Text('Marital Status'), // Add hint text
                  underline: Container(),

                  isExpanded: true,
                  value: maritalStatus,
                  onChanged: (String? newValue) {
                    print(newValue);
                    setState(() {
                      maritalStatus = newValue;
                    });
                  },
                  items: <String>[
                    'Single',
                    'Married',
                    'Divorced',
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
                      color: religion != null
                          ? MyColors.primary
                          : Color(0xffCBDFF7),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    )),
                child: DropdownButton<String>(
                  // iconSize: 2,
                  icon: religion != null
                      ? SvgPicture.asset("images/down.svg")
                      : SvgPicture.asset("images/downlight.svg"),
                  hint: Text('Regilion'), // Add hint text
                  underline: Container(),

                  isExpanded: true,
                  value: religion,
                  onChanged: (String? newValue) {
                    setState(() {
                      religion = newValue!;
                    });
                  },
                  items: <String>[
                    'Christian',
                    'Muslim',
                    'Buddhist',
                    'Other',
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
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Personality Types",
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
                  "Which of these best describes your personality",
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
                  children: personalities.map((item) {
                    return GestureDetector(
                      onTap: () {
                        print("added");
                        print(item);
                        if (personalityTypes!.contains("$item")) {
                          personalityTypes!.remove("$item");
                        } else {
                          personalityTypes!.add("$item");
                        }
                        setState(() {});
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 23, vertical: 14),
                        // width: 10,
                        margin: EdgeInsets.only(right: 5, bottom: 20),
                        decoration: BoxDecoration(
                            color: personalityTypes!.contains(item)
                                ? MyColors.primary
                                : Color(0xffE0EAF6),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Text(
                          "$item",
                          style: TextStyle(
                              color: personalityTypes!.contains(item)
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Do you have any pets?",
                  style: TextStyle(
                    color: Color(0xff1D3354),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Inter",
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          hasPets = true;
                        });
                      },
                      child: Container(
                        // child: ,

                        height: 16,
                        width: 16,

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hasPets == true
                              ? MyColors.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: hasPets == true
                                ? MyColors.primary
                                : Color(0xffCBDFF7),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          color: Color(0xff1D3354),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          hasPets = false;
                        });
                      },
                      child: Container(
                        // child: ,

                        height: 16,
                        width: 16,

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hasPets == false
                              ? MyColors.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: hasPets == false
                                ? MyColors.primary
                                : Color(0xffCBDFF7),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "No",
                        style: TextStyle(
                          color: Color(0xff1D3354),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              if (loading)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: LinearProgressIndicator(),
                ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: PropStockButton(
                    text: "NEXT",
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
