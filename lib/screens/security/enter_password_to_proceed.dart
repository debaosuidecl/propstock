import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/forgot_password.dart';
import 'package:propstock/screens/security/add_phone_number.dart';
import 'package:propstock/screens/security/reset_password_final.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnterPasswordToProceed extends StatefulWidget {
  static const id = "enter_password_to_proceed_security";
  const EnterPasswordToProceed({super.key});

  @override
  State<EnterPasswordToProceed> createState() => _EnterPasswordToProceedState();
}

class _EnterPasswordToProceedState extends State<EnterPasswordToProceed> {
  bool enabledBio = false;
  late final LocalAuthentication auth;
  // bool _supportState = false;
  bool obscureText = true;
  bool loading = false;
  String password = "";
  TextEditingController _controller = TextEditingController();

  Future<void> _authenticate() async {
    try {
      setState(() {
        loading = true;
      });

      String? email = Provider.of<Auth>(context, listen: false).email;
      final response = await Provider.of<Auth>(context, listen: false)
          .signin("", "", "$email", password);

      Provider.of<Auth>(context, listen: false).setTempPassword(password);
      print("response: success");

      print("response: success");

      Navigator.pushNamed(context, AddPhoneNumber2fa.id);

      // print(response);
    } catch (e) {
      showErrorDialog(e.toString(), context);
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
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Input Password",
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
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Enter your password to begin",
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _controller,
                      // keyboardType: TextInputType.text,
                      onChanged: (String val) {
                        setState(() {
                          // firstName = val;
                          password = val;
                          // _fetchFaq();
                        });
                      },
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        hintText: "Password",

                        suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            child: obscureText
                                ? Icon(Icons.remove_red_eye)
                                : Icon(Icons.remove_red_eye_outlined)),
                        prefixIconColor: Color(0xffB0B0B0),
                        filled: true,
                        fillColor: Color(0xffffffff),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        // label: Text('First Name'),
                        hintStyle: TextStyle(
                          color: Color(0xffB0B0B0),
                          fontSize: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xffCBDFF7),
                          ), // Use the hex color
                          borderRadius: BorderRadius.circular(
                              8), // You can adjust the border radius as needed
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xffCBDFF7),
                          ), // Use the hex color
                          borderRadius: BorderRadius.circular(
                              8), // You can adjust the border radius as needed
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 140,
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (loading)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: LinearProgressIndicator(),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: PropStockButton(
                      text: "Continue",
                      disabled: password.isEmpty,
                      onPressed: _authenticate),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
