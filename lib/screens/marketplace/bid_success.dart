import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';

import 'package:propstock/screens/assets/assets.dart';
import 'package:propstock/screens/dashboard.dart';
import 'package:propstock/screens/investments/investements.dart';

class BidSuccess extends StatefulWidget {
  BidSuccess({
    super.key,
  });

  @override
  State<BidSuccess> createState() => _BidSuccessState();
}

class _BidSuccessState extends State<BidSuccess> {
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
                        "Your bid has been placed successfully!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: MyColors.secondary,
                          fontFamily: "Inter",
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Image(
                        image: AssetImage("images/successcircle.png"),
                        // height: 190,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "You will be notified once the seller accepts your bid.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: MyColors.neutralGrey,
                            fontFamily: "Inter",
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyColors.primary,
                              elevation: 0,
                            ),
                            onPressed: () async {
                              // Navigator.popUntil(
                              //     context,
                              //     (route) =>
                              //         route.settings.name == Dashboard.id);

                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Dashboard.id,
                                ModalRoute.withName(Dashboard.id),
                              );
                            },
                            child: const Text(
                              "Done",
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
