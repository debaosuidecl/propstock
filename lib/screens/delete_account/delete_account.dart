import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/create_new_pin.dart';
import 'package:propstock/screens/delete_account/delete_account_final.dart';

import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteAccount extends StatefulWidget {
  static const id = "DeleteAccount";
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  bool enabledBio = false;
  bool enabledisplayinfo = false;
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // auth = LocalAuthentication();
    // auth.isDeviceSupported().then((bool isSupported) {
    //   print("is supported: $isSupported");
    //   setState(() {
    //     _supportState = isSupported;
    //   });
    // });
    // check();
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
                "Delete Account",
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Delete your Propstock account?",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color(0xff1D3354),
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "You are about to delete your propstock account. we will delete every bit of data from our database and stop sending you promotional emails. Please withdraw any funds you have with us before you continue this action or you may not be able to retrieve your funds anymore",
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "If you're having trouble with your account",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color(0xff1D3354),
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Please you do not need to delete your account if you are having trouble with your account. Please contact our customer service and we will help you with anything you need.",
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
              height: 100,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, DeleteAccountFinal.id);
                },
                child: Text(
                  "Delete Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: "Inter",
                      color: Color(0xffFA4F4F)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
