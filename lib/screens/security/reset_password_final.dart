import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/forgot_password.dart';
import 'package:propstock/screens/security/security.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordFinal extends StatefulWidget {
  static const id = "reset_password_final_security";
  const ResetPasswordFinal({super.key});

  @override
  State<ResetPasswordFinal> createState() => _ResetPasswordFinalState();
}

class _ResetPasswordFinalState extends State<ResetPasswordFinal> {
  bool enabledBio = false;
  late final LocalAuthentication auth;
  String _tp = "";
  // bool _supportState = false;
  bool obscureText = true;
  ScrollController _scrollController = ScrollController();
  FocusNode _focusNode = FocusNode();
  bool obscureTextConfirm = true;
  bool loading = false;
  String password = "";
  String newpassword = "";
  String newpasswordconfirm = "";

  bool isGreaterThanOrEqualTo8Characters = false;
  bool usesBothUpperAndLowerCase = false;
  bool symbolsAreNotAllowed = true;
  TextEditingController _newpasswordcontroller = TextEditingController();
  TextEditingController _newpasswordconfirmcontroller = TextEditingController();
  TextEditingController _controller = TextEditingController();

  bool disabledFunc() {
    return !isGreaterThanOrEqualTo8Characters ||
        !usesBothUpperAndLowerCase ||
        !symbolsAreNotAllowed ||
        newpassword.isEmpty ||
        (newpassword != newpasswordconfirm);
  }

  Future<void> _loadState() async {
    try {
      // setState(() {
      //   loading = true;
      // });

      String? tp = Provider.of<Auth>(context, listen: false).tempPassword;

      // final response = await Provider.of<Auth>(context, listen: false)
      //     .signin("", "", "$email", password);

      // Provider.of<Auth>(context, listen: false).setTempPassword(password);
      // print("response: success");

      // print(response);

      _controller.setText(tp);

      setState(() {
        _tp = tp;
      });
    } catch (e) {
      showErrorDialog(e.toString(), context);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void _showSuccessModal() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          // Adjust the height and decoration of the bottom sheet
          height: 300,

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
                width: 200,
                child: Text(
                  "Password change successful!",
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

  Future<void> _changePassword() async {
    try {
      setState(() {
        loading = true;
      });

      // String? tp = Provider.of<Auth>(context, listen: false).tempPassword;

      await Provider.of<Auth>(context, listen: false)
          .changePassword(newpassword);

      // bring up the modal
      _showSuccessModal();
    } catch (e) {
      showErrorDialog(e.toString(), context);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadState();

    // _focusNode
  }

  bool containsUpperAndLowerCase(String text) {
    // Regex pattern to match strings containing at least one uppercase and one lowercase character
    RegExp regex = RegExp(r'(?=.*[a-z])(?=.*[A-Z])');
    return regex.hasMatch(text);
  }

  bool containsSymbol(String text) {
    RegExp regex = RegExp(r'[^\w\s]');
    return regex.hasMatch(text);
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
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Reset Password",
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
                      "Confirm old password",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xff1D3354),
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Enter your previous password, if you do not remember click on forgot password",
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
                      enabled: false,
                      // keyboardType: TextInputType.text,
                      onChanged: (String val) {
                        setState(() {
                          // firstName = val;
                          _tp = val;
                          // _fetchFaq();
                        });
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "confirm password",

                        suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            child: Icon(Icons.remove_red_eye)),
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, ForgotPassword.id);
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: MyColors.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      "Create new password",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Color(0xff1D3354),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      "Enter a new password different from the one used previously",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color(0xff5E6D85),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _newpasswordcontroller,
                      // keyboardType: TextInputType.text,
                      onChanged: (String val) {
                        setState(() {
                          // firstName = val;
                          newpassword = val;

                          // _fetchFaq();
                        });

                        if (val.length < 8 || val.length > 16) {
                          setState(() {
                            isGreaterThanOrEqualTo8Characters = false;
                          });
                        } else {
                          setState(() {
                            isGreaterThanOrEqualTo8Characters = true;
                          });
                        }

                        if (containsUpperAndLowerCase(val)) {
                          setState(() {
                            usesBothUpperAndLowerCase = true;
                          });
                        } else {
                          setState(() {
                            usesBothUpperAndLowerCase = false;
                          });
                        }
                        if (containsSymbol(val)) {
                          setState(() {
                            symbolsAreNotAllowed = false;
                          });
                        } else {
                          setState(() {
                            symbolsAreNotAllowed = true;
                          });
                        }
                      },
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        hintText: "Enter new password",

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

                  // extra stuff

                  if (!isGreaterThanOrEqualTo8Characters)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 6,
                            color: MyColors.neutralGrey,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "Password should be 8 to 16 characters",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: MyColors.neutralGrey,
                            ),
                          )
                        ],
                      ),
                    ),
                  if (!usesBothUpperAndLowerCase)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 6,
                            color: MyColors.neutralGrey,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "Use both uppercase and lowercase",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: MyColors.neutralGrey,
                            ),
                          )
                        ],
                      ),
                    ),
                  if (!symbolsAreNotAllowed)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 6,
                            color: MyColors.neutralGrey,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "Symbols are not allowed",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: MyColors.neutralGrey,
                            ),
                          )
                        ],
                      ),
                    ),

                  SizedBox(
                    height: 20,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Focus(
                      onFocusChange: (bool hasFocus) {
                        if (hasFocus) {
                          // Scroll to the bottom when the TextField is focused
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                      },
                      child: TextField(
                        focusNode: _focusNode,

                        controller: _newpasswordconfirmcontroller,
                        // keyboardType: TextInputType.text,
                        onChanged: (String val) {
                          setState(() {
                            // firstName = val;
                            newpasswordconfirm = val;
                            // _fetchFaq();
                          });
                        },
                        obscureText: obscureTextConfirm,
                        decoration: InputDecoration(
                          hintText: "Confirm new password",

                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  obscureTextConfirm = !obscureTextConfirm;
                                });
                              },
                              child: obscureTextConfirm
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
                  ),
                  SizedBox(
                    height: 140,
                  )
                ],
              ),
            ),
            if (MediaQuery.of(context).viewInsets.bottom <= 0)
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (loading) LinearProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: PropStockButton(
                        text: "Continue",
                        disabled: disabledFunc(),
                        onPressed: _changePassword),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
