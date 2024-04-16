import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:propstock/screens/create_new_pin.dart';
import 'package:propstock/screens/security/reset_password.dart';
import 'package:propstock/screens/security/two_factor_auth.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Security extends StatefulWidget {
  static const id = "security";
  const Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  bool enabledBio = false;
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
    checkbiostate();
  }

  Future<void> checkbiostate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final extractedUserData = prefs.getString("enabled_biometrics");

      print(extractedUserData);

      // final biostate = extractedUserData["biometrics_token"];

      if (extractedUserData != null && extractedUserData != "skip") {
        // if(extractedUserData =)
        setState(() {
          enabledBio = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: "let us authenticate you with your local method",
        options:
            const AuthenticationOptions(stickyAuth: true, biometricOnly: true),
      );
      print("Authenticated: $authenticated");

      if (authenticated) {
        final prefs = await SharedPreferences.getInstance();
        // final enabledBio = prefs.containsKey('enabled_biometrics');
        prefs.setString("enabled_biometrics", "true");
        // var token = prefs.getString("token");
        final extractedUserData =
            json.decode(prefs.getString('userData') as String)
                as Map<String, dynamic>;

        final token = extractedUserData["token"] as String;

        prefs.setString("biometrics_token", token);

        setState(() {
          enabledBio = true;
        });
        // prefs.setString("enabled_biometrics", "true");
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => SetPin()));
      }
    } on PlatformException catch (e) {
      print(e);
      print("not available");
      showErrorDialog(
          "Security Credentials not available on your device", context);
    }
  }

  Future<void> disablebio() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final extractedUserData = prefs.remove("enabled_biometrics");

      setState(() {
        enabledBio = false;
      });
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
                "Security",
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
            ListTile(
              title: const Text(
                "Enable Biometrics",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w400,
                  color: Color(0xff303030),
                ),
              ),
              trailing: CupertinoSwitch(
                  activeColor: Color(0xff37B34A),
                  value: enabledBio,
                  onChanged: (bool val) {
                    if (val == true) {
                      _authenticate();
                    } else {
                      disablebio();
                    }
                  }),
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ResetPassword.id);
              },
              child: const ListTile(
                title: Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400,
                    color: Color(0xff303030),
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xffB0B0B0),
                  weight: 10,
                  size: 20,
                ),
              ),
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, CreateNewPin.id);
              },
              child: const ListTile(
                title: Text(
                  "Change Pin",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400,
                    color: Color(0xff303030),
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xffB0B0B0),
                  weight: 10,
                  size: 20,
                ),
              ),
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, TwoFactorAuth.id);
              },
              child: Column(
                children: [
                  const ListTile(
                    title: Text(
                      "Two-Factor Authentication",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w400,
                        color: Color(0xff303030),
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xffB0B0B0),
                      weight: 10,
                      size: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17.0),
                    child: Text(
                      "For an added layer of security, require a second form of authentication before accessing your account",
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
          ],
        ),
      ),
    );
  }
}
