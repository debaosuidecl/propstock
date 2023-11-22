import 'package:flutter/material.dart';

class GotVerificationMail extends StatefulWidget {
  const GotVerificationMail({super.key});

  static const id = "got_verification_mail";

  @override
  State<GotVerificationMail> createState() => _GotVerificationMailState();
}

class _GotVerificationMailState extends State<GotVerificationMail> {
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
                SizedBox(
                  height: 20,
                ),
                const Text(
                  "You’ve got mail",
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
                  "Click on the link we sent you to verify it’s you.",
                  style: TextStyle(
                    color: Color(0xff5E6D85),
                    // height: 25.6,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w100,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
