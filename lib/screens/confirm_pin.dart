import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/dashboard.dart';
import 'package:propstock/screens/intro_survey_page.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class ConfirmPin extends StatefulWidget {
  const ConfirmPin({super.key});

  @override
  State<ConfirmPin> createState() => _ConfirmPinState();
}

class _ConfirmPinState extends State<ConfirmPin> {
  final TextEditingController _pinController = TextEditingController();
  bool _error = false;
  bool _sendingRequest = false;

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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Confirm PIN",
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
                const Text(
                  "Re-type pin",
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
                    onChanged: (String val) {
                      if (_error && _pinController.text.length != 0) {
                        setState(() {
                          _error = false;
                        });
                      }
                    },
                    defaultPinTheme: defaultPinTheme,
                    forceErrorState: _error,
                    controller: _pinController,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    errorPinTheme: errorPinTheme,
                    length: 4,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onCompleted: (pin) async {
                      try {
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Dashboard()));
                        }
                      } catch (e) {
                        print(e);

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
                        style:
                            TextStyle(color: Colors.red, fontFamily: "Inter")),
                  ),
              ]),
        ),
      ),
    );
  }
}
