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
import 'package:propstock/screens/sign_in_pin.dart';
import 'package:propstock/screens/sign_in_with_password.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CreateNewPinConfirm extends StatefulWidget {
  static const id = 'CreateNewPinConfirm';
  const CreateNewPinConfirm({super.key});

  @override
  State<CreateNewPinConfirm> createState() => _CreateNewPinConfirmState();
}

class _CreateNewPinConfirmState extends State<CreateNewPinConfirm> {
  final TextEditingController _pinController = TextEditingController();
  bool _sendingRequest = false;
  bool _error = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _initUserState();
  }

  bool _canCreatePin() {
    return _pinController.text.length == 4;
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

    void _showModal(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext btx) {
          return WillPopScope(
              onWillPop: () async {
                // Return false to prevent the dialog from being dismissed with the back button
                return false;
              },
              child: AlertDialog(
                title: Text(
                  'PIN has been reset successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Color(0xff1D3354)
                      // height: 32,
                      ),
                ),
                content: Container(
                  height: 250,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Image(
                        image: AssetImage("images/success_circle_2.png"),
                        height: 100,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(btx).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SignInPin()));
                          },
                          child: Text("Done"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: _canCreatePin()
                                  ? Color(0xff2386fe)
                                  : Color(0xffbbbbbb),
                              padding: EdgeInsets.all(15),
                              elevation: 0),
                        ),
                      )
                    ],
                  ),
                ),
                // actions: <Widget>[
                //   TextButton(
                //     onPressed: () {
                //       // Close the modal
                //       Navigator.of(context).pop();
                //     },
                //     child: Text('Close'),
                //   ),
                // ],
              ));
        },
      );
    }

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
                  const Row(
                    children: [
                      Text(
                        "Confirm Pin",
                        style: TextStyle(
                          color: Color(0xff1D3354),
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Re-type Pin",
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
                      closeKeyboardWhenCompleted: true,
                      onCompleted: (pin) async {
                        try {
                          // return;

                          setState(() {
                            _sendingRequest = true;
                          });
                          bool pinsMatch =
                              Provider.of<Auth>(context, listen: false)
                                  .confirmPin(_pinController.text);
                          if (!pinsMatch) {
                            setState(() {
                              _error = true;
                            });
                            // showErrorDialog("Pins Do Not math", context);
                            // return;
                          } else {
                            await Provider.of<Auth>(context, listen: false)
                                .setPinForUser(_pinController.text);
                            _showModal(context);
                          }
                        } catch (e) {
                          print(e);

                          _pinController.clear();
                        } finally {
                          setState(() {
                            _sendingRequest = false;
                          });
                        }
                        // try {
                        //   await Provider.of<Auth>(context, listen: false)
                        //       .SignInWithPin(_pinController.text, email);

                        //   Navigator.of(context).push(MaterialPageRoute(
                        //       builder: (context) => LoadingScreen()));
                        // } catch (e) {
                        //   print(e);
                        //   showErrorDialog(e.toString(), context);
                        //   _pinController.clear();
                        // }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (_sendingRequest) LinearProgressIndicator(),
                  if (_error)
                    Container(
                      width: double.infinity,
                      child: const Text("Wrong code, try again",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.red, fontFamily: "Inter")),
                    ),
                ]),
          ),
        ),
      ),
    );
  }
}
