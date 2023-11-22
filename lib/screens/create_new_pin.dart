// import 'dart:convert';

// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:propstock/providers/auth.dart';
// import 'package:propstock/screens/confirm_pin.dart';
import 'package:propstock/screens/create_new_pin_confirm.dart';

import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

class CreateNewPin extends StatefulWidget {
  static const id = 'CreateNewPin';
  const CreateNewPin({super.key});

  @override
  State<CreateNewPin> createState() => _CreateNewPinState();
}

class _CreateNewPinState extends State<CreateNewPin> {
  final TextEditingController _pinController = TextEditingController();

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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: MediaQuery.of(context).size.height * .8,
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
                                "Create New Pin",
                                style: const TextStyle(
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
                            "Come up with a 4-digit pin that you can use for all your transactions",
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
                              pinputAutovalidateMode:
                                  PinputAutovalidateMode.onSubmit,
                              showCursor: true,
                              closeKeyboardWhenCompleted: true,
                              onCompleted: (pin) async {
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
                        ]),
                  ),
                ),
                //  SUBMIT BUTTON
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () async {
                      Provider.of<Auth>(context, listen: false)
                          .setPin(_pinController.text);

                      Navigator.pushNamed(context, CreateNewPinConfirm.id);

                      // try {
                      //   if (_loading) return;
                      //   setState(() {
                      //     _loading = true;
                      //   });
                      //   await Provider.of<Auth>(context, listen: false)
                      //       .signup(firstName, lastName, emailAddress, password);

                      //   // push to fix pin
                      //   print("done");

                      //   await Navigator.pushNamed(context, EmailCodeVerify.id);
                      // } catch (e) {
                      //   showErrorDialog(e.toString(), context);
                      // } finally {
                      //   setState(() {
                      //     _loading = false;
                      //   });
                      // }
                    },
                    child: Text("Create Pin"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: _canCreatePin()
                            ? Color(0xff2386fe)
                            : Color(0xffbbbbbb),
                        padding: EdgeInsets.all(15),
                        elevation: 0),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
