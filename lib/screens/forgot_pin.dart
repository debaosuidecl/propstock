import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/create_new_pin.dart';
import 'package:propstock/screens/email_code_verify.dart';
import 'package:propstock/screens/loading_screen.dart';
import 'package:propstock/screens/onboarding.dart';
import 'package:propstock/screens/signup.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class ForgotPin extends StatefulWidget {
  const ForgotPin({super.key});

  static const id = "forgotPin";
  @override
  State<ForgotPin> createState() => _ForgotPinState();
}

class _ForgotPinState extends State<ForgotPin> {
  final TextEditingController _passwordController = TextEditingController();

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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xff1D3354),
          ),
          onPressed: () {
            // Navigate back to the previous screen when the back button is pressed
            Navigator.pop(context);
          },
        ),
      ),
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
                        "Enter your password",
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
                        "Enter your propstock password to reset your PIN",
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
                        controller: _passwordController,
                        obscureText: obscuringText,
                        onChanged: (String val) {
                          setState(() {
                            password = val;
                          });
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscuringText = !obscuringText;
                              });
                            },
                            child: obscuringText
                                ? Icon(Icons.remove_red_eye)
                                : Icon(Icons.hide_source_sharp),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          label: Text('Password'),
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
                      GestureDetector(
                        onTap: () {
                          // take me to forgot password
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2286FE),
                          ),
                        ),
                      )
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
                      final prefs = await SharedPreferences.getInstance();
                      final userPinData =
                          prefs.getString("userDataForPin") as String;
                      await Provider.of<Auth>(context, listen: false)
                          .login(json.decode(userPinData)["email"], password);

                      // push to fix pin
                      print("done");

                      await Navigator.pushNamedAndRemoveUntil(
                          context, CreateNewPin.id, (route) {
                        return route.settings.name == OnBoarding.id;
                      });
                    } catch (e) {
                      showErrorDialog(e.toString(), context);
                    } finally {
                      setState(() {
                        _loading = false;
                      });
                    }
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
