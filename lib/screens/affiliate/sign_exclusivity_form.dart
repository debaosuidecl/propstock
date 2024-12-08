import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/affiliate/listing.dart';
import 'package:propstock/screens/affiliate/sign_exlusivity_form_action.dart';
import 'package:propstock/screens/dashboard.dart';
import 'package:propstock/screens/loading_screen.dart';
import 'package:propstock/screens/verify_identity/identityUpload.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class SignExclusivityForm extends StatefulWidget {
  static const id = "SignExclusivityForm";
  const SignExclusivityForm({super.key});

  @override
  State<SignExclusivityForm> createState() => _SignExclusivityFormState();
}

class _SignExclusivityFormState extends State<SignExclusivityForm> {
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
          child: Container(
            height: MediaQuery.of(context).size.height * .78,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Sign Exclusivity Form",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff1D3354),
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
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
                SizedBox(
                  height: 30,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "To add to listing as an Affiliate, you must sign the exclusivity form.",
                    style: TextStyle(
                      color: Color(0xff5E6D85),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, SignExclusivityFormAction.id);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffCBDFF7)),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: ListTile(
                      title: Text(
                        "Exclusivity Form Doc",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xff011936),
                        ),
                      ),
                      trailing: Provider.of<Auth>(context, listen: true)
                                  .exlusivityDocSigned ==
                              true
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset("images/goodcheck1.svg"),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "signed",
                                  style: TextStyle(
                                    color: Color(0xff2286FE),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              "sign",
                              style: TextStyle(
                                color: Color(0xff2286FE),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  // width: MediaQuery.of(context).size.width * .8,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset("images/infob.svg"),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          "This document is legal bind, kindly read thoroughly before signing. ",
                          style: TextStyle(
                            color: Color(0xff8E99AA),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 20,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: PropStockButton(
                      disabled: Provider.of<Auth>(context, listen: true)
                              .exlusivityDocSigned !=
                          true,
                      onPressed: () {
                        // Navigator.pushNamed(context, AffiliateListing.id);

                        //               Navigator.of(context).pushAndRemoveUntil(
                        //   MaterialPageRoute(builder: (context) => HomePage()),
                        //   (Route<dynamic> route) => false,
                        // );

                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => AffiliateListing()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      text: "Continue"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
