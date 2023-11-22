// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:propstock/providers/auth.dart';
// import 'package:propstock/screens/create_new_pin.dart';
// import 'package:propstock/screens/email_code_verify.dart';
import 'package:propstock/screens/got_verification_mail.dart';
// import 'package:propstock/screens/loading_screen.dart';
import 'package:propstock/screens/onboarding.dart';
// import 'package:propstock/screens/signup.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:convert';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  static const id = "ForgotPassword";
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  String password = "";
  // bool? _isChecked = false;
  bool obscuringText = true;
  bool _loading = false;

  bool _canResetPassword() {
    if (_loading) {
      return false;
    }
    if (password.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Image(
                      height: 32,
                      image: AssetImage('images/close_icon.png'),
                    ),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * .78,
                // color: Colors.green,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Enter your E-mail",
                        style: TextStyle(
                            color: Color(0xff1D3354),
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                            fontSize: 30),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Enter your verified e-mail address and we will send you a link",
                        style: TextStyle(
                          color: Color(0xff5E6D85),
                          // height: 25.6,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w100,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextField(
                        controller: _emailController,
                        // obscureText: obscuringText,
                        onChanged: (String val) {
                          setState(() {
                            password = val;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          label: Text('E-mail Address'),
                          hintStyle: TextStyle(color: Color(0xffbbbbbb)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xffCBDFF7),
                            ), // Use the hex color
                            borderRadius: BorderRadius.circular(
                                8), // You can adjust the border radius as needed
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ]),
              ),
              // if (_loading) LinearProgressIndicator(),
              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    // Navigator.pushNamed(context, LocationSelect.id);

                    try {
                      if (_loading) return;
                      setState(() {
                        _loading = true;
                      });

                      await Provider.of<Auth>(context, listen: false)
                          .sendVerificationLink(_emailController.text);

                      // push to fix pin
                      print("done");

                      // if(mounted)

                      await Navigator.pushNamedAndRemoveUntil(
                          context, GotVerificationMail.id, (route) {
                        return route.settings.name == OnBoarding.id;
                      });
                    } catch (e) {
                      showErrorDialog(e.toString(), context);
                      setState(() {
                        _loading = false;
                      });
                    } finally {}
                  },
                  child: Text("Continue"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _canResetPassword()
                          ? Color(0xff2386fe)
                          : Color(0xffbbbbbb),
                      padding: EdgeInsets.all(15),
                      elevation: 0),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
