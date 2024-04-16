import 'dart:async';
import 'dart:convert';
// import 'dart:js_interop';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/country.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/forgot_password.dart';
import 'package:propstock/screens/loading_screen.dart';
import 'package:propstock/screens/security/reset_password_final.dart';
import 'package:propstock/screens/security/security.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyPhoneFromSignIn extends StatefulWidget {
  static const id = "VerifyPhoneFromSignIn";

  const VerifyPhoneFromSignIn({super.key});

  @override
  State<VerifyPhoneFromSignIn> createState() => _VerifyPhoneFromSignInState();
}

class _VerifyPhoneFromSignInState extends State<VerifyPhoneFromSignIn> {
  bool enabledBio = false;
  late final LocalAuthentication auth;
  // bool _supportState = false;
  final TextEditingController _pinController = TextEditingController();

  bool obscureText = true;
  bool loading = false;
  Map<String, dynamic>? selectedCountry;
  Duration timetoresend = Duration(minutes: 0);
  String phone = "";
  TextEditingController _controller = TextEditingController();

  void _showSuccessModal() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          // Adjust the height and decoration of the bottom sheet
          height: MediaQuery.of(context).size.height * .5,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            // border: Border.all(color: Colors.grey, width: 1.0),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Container(
                // width: 200,
                child: Text(
                  "Successfully enabled",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Inter",
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SvgPicture.asset("images/success_circle.svg"),
              SizedBox(
                height: 20,
              ),
              Container(
                // width: 200,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Authentication codes for logging in will be sent to the number provided.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter",
                    color: Color(0xff5E6D85),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PropStockButton(
                  disabled: false,
                  onPressed: () {
                    Provider.of<Auth>(context, listen: false)
                        .setTempPassword("");
                    // Navigator.;(context);
                    Navigator.popUntil(
                        context, (route) => route.settings.name == Security.id);
                    // Navigator.popUntil(context, newRouteName, (route) => false)
                    // Navigator.pop(context);
                  },
                  text: "Done",
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState

    // initStateOfCountry();
    super.initState();
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Before you sign in...",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff1D3354),
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 11,
                  ),
                  child: Text(
                    "Enter the 5-digit verification code sent to your mobile number",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff5E6D85),
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Pinput(
                    onChanged: (String val) {},
                    // obscureText: true,
                    defaultPinTheme: defaultPinTheme,
                    controller: _pinController,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    errorPinTheme: errorPinTheme,
                    length: 5,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onCompleted: (pin) async {
                      try {
                        // print(
                        //     "this is line 163: $email ${_pinController.text}");

                        setState(() {
                          loading = true;
                        });
                        await Provider.of<Auth>(context, listen: false)
                            .verify2fa(_pinController.text);

                        // _showSuccessModal();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoadingScreen()));
                      } catch (e) {
                        print(e);
                        showErrorDialog(e.toString(), context);
                        _pinController.clear();
                      } finally {
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                if (loading)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: LinearProgressIndicator(),
                  ),
                SizedBox(
                  height: 15,
                ),
                if (timetoresend.inSeconds > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Text(
                          "You have to wait to resend the code again",
                          style: TextStyle(
                            color: MyColors.neutral,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        CountdownTimer(
                          duration: timetoresend, // Set the initial duration
                          onFinish: () {
                            print('Countdown finished!');

                            setState(() {
                              timetoresend = Duration.zero;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                if (timetoresend.inSeconds <= 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Text(
                          "Didn’t receive code?",
                          style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff5E6D85)),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: () async {
                            try {
                              setState(() {
                                loading = true;
                              });
                              await Provider.of<Auth>(context, listen: false)
                                  .enable2fa(
                                      "${Provider.of<Auth>(context, listen: false).phoneFor2fa}");

                              setState(() {
                                timetoresend = Duration(minutes: 2);
                              });
                            } catch (e) {
                              showErrorDialog(e.toString(), context);
                            } finally {
                              setState(() {
                                loading = false;
                              });
                            }
                          },
                          child: Text(
                            "Resend",
                            style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: MyColors.primary),
                          ),
                        )
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CountdownTimer extends StatefulWidget {
  final Duration duration;
  final Function onFinish;

  const CountdownTimer({required this.duration, required this.onFinish});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late int _secondsRemaining;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.duration.inSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer.cancel();
        widget.onFinish();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;

    return Text('$minutes:${seconds.toString().padLeft(2, '0')}',
        style: TextStyle(
            fontSize: 14, color: MyColors.primary, fontFamily: "Inter"));
  }
}
