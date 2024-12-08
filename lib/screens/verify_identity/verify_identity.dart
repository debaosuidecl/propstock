import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:propstock/screens/verify_identity/identityUpload.dart';
import 'package:propstock/widgets/propstock_button.dart';

class VerifyIdentity extends StatefulWidget {
  static const id = "VerifyIdentity";
  const VerifyIdentity({super.key});

  @override
  State<VerifyIdentity> createState() => _VerifyIdentityState();
}

class _VerifyIdentityState extends State<VerifyIdentity> {
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  bool disabledFunc() {
    return false;
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
            Navigator.pop(context, 'success');
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Verify Identity",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xff1D3354),
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Text(
                  "Choose verification method",
                  style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff1D3354)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Text(
                  "Select the verification method you wish to verify your account.",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 16,
                    color: Color(0xff5E6D85),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  // Navigator.pushNamed(context, IdentityUpload.id,
                  //     arguments: "National Identity Number");
                  var res = await Navigator.pushNamed(
                      context, IdentityUpload.id,
                      arguments: "National Identity Number");

                  if (res == "success") {
                    Navigator.pop(context, 'success');
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffCBDFF7)),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: ListTile(
                    title: Text("National Identity Number"),
                    leading: Container(
                      height: 16,
                      width: 16,
                      margin: EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffCBDFF7)),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  var res = Navigator.pushNamed(context, IdentityUpload.id,
                      arguments: "International Passport");

                  if (res == "success") {
                    Navigator.pop(context, 'success');
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffCBDFF7)),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: ListTile(
                    title: Text("International Passport"),
                    leading: Container(
                      height: 16,
                      width: 16,
                      margin: EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffCBDFF7)),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  // Navigator.pushNamed(context, IdentityUpload.id,
                  //     arguments: "Drivers License");

                  // Navigator.pushNamed(context, IdentityUpload.id,
                  //     arguments: "National Identity Number");
                  var res = await Navigator.pushNamed(
                      context, IdentityUpload.id,
                      arguments: "Drivers License");

                  if (res == "success") {
                    Navigator.pop(context, 'success');
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffCBDFF7)),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: ListTile(
                    title: Text("Driver’s License"),
                    leading: Container(
                      height: 16,
                      width: 16,
                      margin: EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffCBDFF7)),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
              ),
              // if (loading)
              //   Padding(
              //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              //     child: LinearProgressIndicator(),
              //   ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 20),
              //   child: PropStockButton(
              //       text: "Continue",
              //       disabled: disabledFunc(),
              //       onPressed: () {
              //         // _updateProfile();
              //       }),
              // ),
              // SizedBox(
              //   height: 30,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
