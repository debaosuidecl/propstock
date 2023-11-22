import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';

class SuccessTopUpAsset extends StatelessWidget {
  const SuccessTopUpAsset({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Text(
            "Top Up Successful",
            style: TextStyle(
              color: MyColors.secondary,
              fontFamily: "Inter",
              fontSize: 26,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Image(
            image: AssetImage("images/successcircle.png"),
            height: 150,
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
                  Navigator.pop(context, "success");
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
    );
  }
}
