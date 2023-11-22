import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';

class VerifyAccount extends StatefulWidget {
  static const id = "verify_account";
  const VerifyAccount({super.key});

  @override
  State<VerifyAccount> createState() => _VerifyAccountState();
}

class _VerifyAccountState extends State<VerifyAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: MyColors.neutralblack,
          ),
        ),
        centerTitle: true,
        title: Text("Verify Account",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Inter",
              fontWeight: FontWeight.w400,
              fontSize: 22,
            )),
      ),
    );
  }
}
