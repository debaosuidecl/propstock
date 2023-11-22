import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/confirm_pin.dart';
import 'package:provider/provider.dart';

class SetPin extends StatefulWidget {
  const SetPin({super.key});

  @override
  State<SetPin> createState() => _SetPinState();
}

class _SetPinState extends State<SetPin> {
  final TextEditingController _pinController = TextEditingController();

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
                  "Create a PIN",
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
                        Provider.of<Auth>(context, listen: false)
                            .setPin(_pinController.text);

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ConfirmPin()));
                      } catch (e) {
                        print(e);

                        _pinController.clear();
                      } finally {}
                    },
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
