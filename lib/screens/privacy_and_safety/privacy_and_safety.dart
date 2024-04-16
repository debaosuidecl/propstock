import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/create_new_pin.dart';

import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacyAndSafety extends StatefulWidget {
  static const id = "PrivacyAndSafety";
  const PrivacyAndSafety({super.key});

  @override
  State<PrivacyAndSafety> createState() => _PrivacyAndSafetyState();
}

class _PrivacyAndSafetyState extends State<PrivacyAndSafety> {
  bool enabledBio = false;
  bool enabledisplayinfo = false;
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) {
      print("is supported: $isSupported");
      setState(() {
        _supportState = isSupported;
      });
    });
    check();
  }

  Future<void> check() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final extractedUserData = prefs.getString("displayinfo");

      print(extractedUserData);

      // final biostate = extractedUserData["biometrics_token"];

      if (extractedUserData != null) {
        // if(extractedUserData =)
        setState(() {
          enabledisplayinfo = true;
        });
      }
    } catch (e) {
      print(e);
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Privacy And Safety",
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
            GestureDetector(
              onTap: () {
                // Navigator.pushNamed(context, TwoFactorAuth.id);
              },
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "Display information",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w400,
                        color: Color(0xff303030),
                      ),
                    ),
                    trailing: CupertinoSwitch(
                        activeColor: Color(0xff37B34A),
                        value: enabledisplayinfo,
                        onChanged: (bool val) async {
                          print(val);
                          setState(() {
                            enabledisplayinfo = val;
                          });
                          final prefs = await SharedPreferences.getInstance();
                          if (val == true) {
                            prefs.setString("displayinfo", "1");

                            // _authenticate();

                            // Navigator.pushNamed(context, EnterPasswordToProceed.id);
                          } else {
                            prefs.remove("displayinfo");
                            // disablebio();
                            // Provider.of<Auth>(context, listen: false)
                            //     .disableTwofaphone();
                          }
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17.0),
                    child: Text(
                      "Allow Propstock display strictly non-sensitive  information to makes it easier for users to make better decisions.",
                      style: TextStyle(
                        color: Color(0xff8E99AA),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            const Divider(),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
