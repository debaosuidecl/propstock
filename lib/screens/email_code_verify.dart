import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/enable_biometrics.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class EmailCodeVerify extends StatefulWidget {
  const EmailCodeVerify({super.key});

  static const id = "EmailCodeVerify";
  @override
  State<EmailCodeVerify> createState() => _EmailCodeVerifyState();
}

class _EmailCodeVerifyState extends State<EmailCodeVerify> {
  bool _loading = true;
  String? _email = "";
  bool _sendingRequest = false;
  final TextEditingController _pinController = TextEditingController();
  bool _error = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserDetails();
  }

  Future<void> _getUserDetails() async {
    try {
      await Provider.of<Auth>(context, listen: false).tryAutoLogin();
      _email = await Provider.of<Auth>(context, listen: false).email;
    } catch (e) {
      // showErrorDialog(e.toString(), context);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 37,
      height: 57,
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
              child: _loading
                  ? LinearProgressIndicator()
                  : Column(
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
                                  "Email confirmation",
                                  style: TextStyle(
                                    color: Color(0xff1D3354),
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 30,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                RichText(
                                  text: TextSpan(
                                    text:
                                        'Enter the 6-digit verification code sent to your email ',
                                    style: const TextStyle(
                                        fontSize: 15, color: Color(0xffbbbbbb)),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: _email,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Pinput(
                                    onChanged: (String val) {
                                      if (_error &&
                                          _pinController.text.length != 0) {
                                        setState(() {
                                          _error = false;
                                        });
                                      }
                                    },
                                    defaultPinTheme: defaultPinTheme,
                                    controller: _pinController,
                                    focusedPinTheme: focusedPinTheme,
                                    submittedPinTheme: submittedPinTheme,
                                    errorPinTheme: errorPinTheme,
                                    // validator: (s) {
                                    //   return "";
                                    // },
                                    forceErrorState: _error,
                                    length: 6,
                                    pinputAutovalidateMode:
                                        PinputAutovalidateMode.onSubmit,
                                    showCursor: true,
                                    onCompleted: (pin) async {
                                      print("sending request now");
                                      try {
                                        setState(() {
                                          _sendingRequest = true;
                                        });

                                        try {
                                          await Provider.of<Auth>(context,
                                                  listen: false)
                                              .verifyUser(_pinController.text);
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EnableBiometrics()));
                                        } catch (e) {
                                          showErrorDialog(
                                              e.toString(), context);
                                          throw (e);
                                        }
                                      } catch (e) {
                                        print(e);
                                        setState(() {
                                          _error = true;
                                        });
                                        _pinController.clear();
                                      } finally {
                                        setState(() {
                                          _sendingRequest = false;
                                        });
                                      }
                                    },
                                  ),
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
                                            color: Colors.red,
                                            fontFamily: "Inter")),
                                  ),
                                SizedBox(
                                  height: 50,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: "Didn't receive code? ",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Inter",
                                          color: Color(0xffbbbbbb)),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "Resend",
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              fontFamily: "Inter",
                                              fontSize: 15,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                print("resent");

                                                // return;
                                                try {
                                                  setState(() {
                                                    _sendingRequest = true;
                                                  });

                                                  try {
                                                    await Provider.of<Auth>(
                                                            context,
                                                            listen: false)
                                                        .resendCode();

                                                    _showDialog(context,
                                                        "Code resent to $_email");
                                                  } catch (e) {
                                                    showErrorDialog(
                                                        e.toString(), context);
                                                    throw (e);
                                                  }
                                                } catch (e) {
                                                  print(e);
                                                  setState(() {
                                                    _error = true;
                                                  });
                                                  _pinController.clear();
                                                } finally {
                                                  setState(() {
                                                    _sendingRequest = false;
                                                  });
                                                }
                                              })
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                        ),
                      ],
                    )),
        ),
      ),
    );
  }
}
