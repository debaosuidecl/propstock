import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/confirm_pin.dart';
import 'package:propstock/screens/dashboard.dart';
import 'package:propstock/screens/forgot_pin.dart';
import 'package:propstock/screens/loading_screen.dart';
import 'package:propstock/screens/onboarding.dart';
import 'package:propstock/screens/sign_in_with_password.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SignInPin extends StatefulWidget {
  static const id = 'signinpin';
  const SignInPin({super.key});

  @override
  State<SignInPin> createState() => _SignInPinState();
}

class _SignInPinState extends State<SignInPin> {
  final TextEditingController _pinController = TextEditingController();
  String firstName = "";
  String email = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initUserState();
  }

  Future<void> _initUserState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        firstName = json
            .decode(prefs.getString("userDataForPin") as String)["firstName"];
        email =
            json.decode(prefs.getString("userDataForPin") as String)["email"];
      });
    } catch (e) {
      showErrorDialog("Could not find user data", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 67,
      height: 77,
      padding: const EdgeInsets.only(bottom: 15),
      textStyle: TextStyle(
          fontSize: 25,
          color: Colors.black,
          fontWeight: FontWeight.w300,
          fontFamily: "Inter"),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffbbbbbb))),

        color: Colors.transparent,
        // borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border(bottom: BorderSide(color: Color(0xff222222))),
      // borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border(bottom: BorderSide(color: Color(0xff222222))),
        // color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration
          ?.copyWith(border: Border(bottom: BorderSide(color: Colors.red))),
      // color: Color.fromRGBO(234, 239, 243, 1),
    );
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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        "Welcome back $firstName",
                        style: const TextStyle(
                          color: Color(0xff1D3354),
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                      const Image(
                        image: AssetImage("images/hi.png"),
                        height: 20,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Enter your 4-digit pin to Sign In",
                    style: TextStyle(
                      color: Color(0xffbbbbbb),
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w200,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Pinput(
                      onChanged: (String val) {},
                      obscureText: true,
                      defaultPinTheme: defaultPinTheme,
                      controller: _pinController,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      errorPinTheme: errorPinTheme,
                      length: 4,
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      onCompleted: (pin) async {
                        try {
                          print(
                              "this is line 163: $email ${_pinController.text}");

                          await Provider.of<Auth>(context, listen: false)
                              .signInWithPin(_pinController.text, email);

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoadingScreen()));
                        } catch (e) {
                          print(e);
                          showErrorDialog(e.toString(), context);
                          _pinController.clear();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      print("forgot pin medely");
                      // incorporate the forget pin algorithm
                      Navigator.pushNamed(context, ForgotPin.id);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Forgot PIN?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff2286FE),
                          fontFamily: "Inter",
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      // color: Colors.green,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Not $firstName?",
                              style: TextStyle(
                                color: Color(0xff8E99AA),
                                fontFamily: "Inter",
                                fontSize: 16,
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();

                              prefs.remove("userDataForPin");
                              Navigator.pushNamedAndRemoveUntil(
                                  context, SignInWithPassword.id, (route) {
                                return route.settings.name == OnBoarding.id;
                              });
                            },
                            child: Text("Switch Account",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: "Inter",
                                  fontSize: 16,
                                )),
                          )
                        ],
                      )),
                ]),
          ),
        ),
      ),
    );
  }
}
