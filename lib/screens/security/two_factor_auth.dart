import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/create_new_pin.dart';
import 'package:propstock/screens/security/enter_password_to_proceed.dart';
import 'package:propstock/screens/security/reset_password.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TwoFactorAuth extends StatefulWidget {
  static const id = "TwoFactorAuth";
  const TwoFactorAuth({super.key});

  @override
  State<TwoFactorAuth> createState() => _TwoFactorAuthState();
}

class _TwoFactorAuthState extends State<TwoFactorAuth> {
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
                "Two-factor Authentication",
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
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 11,
              ),
              child: Text(
                "For an added layer of security, require a second form of authentication before accessing your account",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color(0xff5E6D85),
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, EnterPasswordToProceed.id);
              },
              child: ListTile(
                title: const Text(
                  "Text message",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400,
                    color: Color(0xff303030),
                  ),
                ),
                trailing: CupertinoSwitch(
                    activeColor: Color(0xff37B34A),
                    value:
                        Provider.of<Auth>(context, listen: true).twofaenabled ==
                            true,
                    onChanged: (bool val) {
                      print(val);
                      if (val == true) {
                        // _authenticate();

                        Navigator.pushNamed(context, EnterPasswordToProceed.id);
                      } else {
                        // disablebio();
                        Provider.of<Auth>(context, listen: false)
                            .disableTwofaphone();
                      }
                    }),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
