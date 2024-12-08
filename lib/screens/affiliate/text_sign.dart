import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';

class TextSignAffiliate extends StatefulWidget {
  const TextSignAffiliate({super.key});
  static const id = "TextSignAffiliate";

  @override
  State<TextSignAffiliate> createState() => _TextSignAffiliateState();
}

class _TextSignAffiliateState extends State<TextSignAffiliate> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            // height: 30,
            width: 80,
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                // Navigator
                // print("hey");
                Navigator.pop(context, _controller.text);
              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                width: 80,
                alignment: Alignment.center,
                height: 30,
                decoration: BoxDecoration(
                  color: MyColors.primary,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Text(
                  "Done",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(
                  fontFamily: "Creation",
                  fontSize: 40,
                ),
                expands: true,
                controller: _controller,
                maxLines: null,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Type something here...',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
