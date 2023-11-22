import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';

class SuccessGiftPageGifters extends StatefulWidget {
  const SuccessGiftPageGifters({
    super.key,
  });

  @override
  State<SuccessGiftPageGifters> createState() => _SuccessGiftPageGiftersState();
}

class _SuccessGiftPageGiftersState extends State<SuccessGiftPageGifters> {
  // Property? _property;

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
                        "Gift Sent",
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
                        "You will be notified once they accept the gift",
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
                              print("going back");
                              Navigator.pop(context, "send_gift");
                            },
                            child: Text(
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
