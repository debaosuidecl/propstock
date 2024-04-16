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

class NotificationsProfile extends StatefulWidget {
  static const id = "NotificationsProfile";
  const NotificationsProfile({super.key});

  @override
  State<NotificationsProfile> createState() => _NotificationsProfileState();
}

class _NotificationsProfileState extends State<NotificationsProfile> {
  bool enabledBio = false;
  bool enabledisplayinfo = false;
  bool? pushnotify = false;
  bool? emailnotify = false;
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
    check();
  }

  Future<void> check() async {
    try {
      final enotify =
          await Provider.of<Auth>(context, listen: false).getemailnotify;
      final pnotify =
          await Provider.of<Auth>(context, listen: false).getpushnotify;
      // final extractedUserData = prefs.getString("displayinfo");

      // print(extractedUserData);

      // final biostate = extractedUserData["biometrics_token"];

      // if () {
      // if(extractedUserData =)
      setState(() {
        emailnotify = enotify;
        pushnotify = pnotify;
      });
      // }
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
                "Notifications",
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
                    title: const Text(
                      "Push Notifications",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w400,
                        color: Color(0xff303030),
                      ),
                    ),
                    trailing: CupertinoSwitch(
                        activeColor: Color(0xff37B34A),
                        value: pushnotify == true,
                        onChanged: (bool val) async {
                          print(val);
                          setState(() {
                            pushnotify = val;
                          });
                          try {
                            await Provider.of<Auth>(context, listen: false)
                                .pushnotify(val);
                          } catch (e) {
                            showErrorDialog(e.toString(), context);
                            setState(() {
                              pushnotify = !val;
                            });
                          }
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17.0),
                    child: Text(
                      "Allow Propstock display certain information that makes it easier for others to make better decisions.",
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
                    title: const Text(
                      "Email Notifications",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w400,
                        color: Color(0xff303030),
                      ),
                    ),
                    trailing: CupertinoSwitch(
                        activeColor: Color(0xff37B34A),
                        value: emailnotify == true,
                        onChanged: (bool val) async {
                          print(val);
                          setState(() {
                            emailnotify = val;
                          });
                          try {
                            await Provider.of<Auth>(context, listen: false)
                                .emailnotify(val);
                          } catch (e) {
                            showErrorDialog(e.toString(), context);
                            setState(() {
                              emailnotify = !val;
                            });
                          }
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Allow e-mail notifications on events in propstock. if you are getting too much of these you can always switch these off and we won't send you an email",
                      textAlign: TextAlign.left,
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
            // const Divider(),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
