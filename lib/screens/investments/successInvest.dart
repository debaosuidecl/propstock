import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';

import 'package:propstock/screens/assets/assets.dart';
import 'package:propstock/screens/dashboard.dart';
import 'package:propstock/screens/investments/investements.dart';

class SuccesInvest extends StatefulWidget {
  SuccesInvest({
    super.key,
  });

  @override
  State<SuccesInvest> createState() => _SuccesInvestState();
}

class _SuccesInvestState extends State<SuccesInvest> {
  Property? _property;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      // Calculate available screen height
      // double screenHeight = constraints.maxHeight;

      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Payment Successful",
                        style: TextStyle(
                          color: MyColors.secondary,
                          fontFamily: "Inter",
                          fontSize: 26,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Image(
                        image: AssetImage("images/successcircle.png"),
                        height: 150,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "You can find your Investments in your assets ",
                        style: TextStyle(
                          color: MyColors.neutralGrey,
                          fontFamily: "Inter",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyColors.primary,
                              elevation: 0,
                            ),
                            onPressed: () async {
                              // _showBottomSheet(context);
                              print("going to Assets");
                              Navigator.pushNamedAndRemoveUntil(
                                  context, Investments.id, (route) {
                                return route.settings.name == Dashboard.id;
                              });
                            },
                            child: Text(
                              "My Assets",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )),
                      )
                    ],
                  ),
                ))),
      );
    });
  }
}
