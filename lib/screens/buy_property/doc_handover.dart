import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/providers/buy.dart';
import 'package:propstock/screens/primary_goal.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class DocumentHandover extends StatefulWidget {
  const DocumentHandover({super.key});
  static const id = "dochandover";

  @override
  State<DocumentHandover> createState() => _DocumentHandoverState();
}

class _DocumentHandoverState extends State<DocumentHandover> {
  Property? _property;
  String option = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPropertySaleData();
  }

  void _initPropertySaleData() {
    _property =
        Provider.of<BuyPropertyProvider>(context, listen: false).propsuccess;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: SvgPicture.asset("images/close_icon.svg"),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Document Handover",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: MyColors.primaryDark,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      "Select what way you would like to receive your property documents.",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        fontFamily: "Inter",
                        color: Color(0xff5E6D85),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .04,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // _investmentExpereince = "Novice";
                        option = "Soft copy documents";
                      });
                    },
                    child: OptionItem(
                      title: "Soft copy documents",
                      description: "This requires only your e-signature",
                      selected: option == "Soft copy documents",
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .04,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // _investmentExpereince = "Novice";
                        option = "Schedule a day for office collection";
                      });
                    },
                    child: OptionItem(
                      title: "Schedule a day for office collection",
                      description:
                          "Pick up all property documents from our office closest to you. All signatures required will be taken at the office.",
                      selected:
                          option == "Schedule a day for office collection",
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .04,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // _investmentExpereince = "Novice";
                        option = "Receive via DHL";
                      });
                    },
                    child: OptionItem(
                      title: "Receive via DHL",
                      description:
                          "All property documents will be sent to the address provided by you via DHL. This option will require an E-signature from the legal owner.",
                      selected: option == "Receive via DHL",
                    ),
                  ),
                ],
              ),
            ),
            PropStockButton(
                text: "Continue", disabled: option == "", onPressed: () {}),
            SizedBox(
              height: 20,
            )
          ],
        ),
      )),
    );
  }
}
