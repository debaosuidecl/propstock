import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:signature/signature.dart';

class SignatureCanvasPage extends StatefulWidget {
  const SignatureCanvasPage({super.key});
  static const id = "SignatureCanvasPage";

  @override
  State<SignatureCanvasPage> createState() => _SignatureCanvasPageState();
}

class _SignatureCanvasPageState extends State<SignatureCanvasPage> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: MyColors.primaryDark,
    exportBackgroundColor: Colors.transparent,
  );
  bool clicked = false;

  // _controller

// INITIALIZE. RESULT IS A WIDGET, SO IT CAN BE DIRECTLY USED IN BUILD METHOD
// var _signatureCanvas =

  @override
  Widget build(BuildContext context) {
    _controller.onDrawStart = () {
      print("drawing start");
      setState(() {
        clicked = true;
      });
    };
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 72,
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: MyColors.primary,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: MyColors.primary,
                            fontFamily: "Inter",
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Add your signature",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Uint8List? sign = await _controller.toPngBytes();
                        Navigator.pop(context, sign);
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: Text(
                          "Save",
                          style: TextStyle(
                            color: MyColors.primary,
                            fontFamily: "Inter",
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            SizedBox(
              height: 50,
            ),
            Stack(
              children: [
                if (!clicked)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("images/signhand.svg"),
                            ],
                          ),
                          Text(
                            "Draw your signature here",
                            style: TextStyle(
                                color: Color(0xff8E99AA),
                                fontWeight: FontWeight.w200,
                                fontFamily: "Inter"),
                          ),
                        ],
                      ),
                    ],
                  ),
                if (!clicked)
                  SizedBox(
                    height: 5,
                  ),
                Signature(
                  controller: _controller,
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
            SvgPicture.asset("images/dividedot.svg"),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 80,
              child: PropStockButton(
                text: "Clear",
                onPressed: () {
                  _controller.clear();
                },
                disabled: false,
              ),
            )
          ],
        )),
      ),
    );
  }
}
