import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyMoreDocuments extends StatefulWidget {
  final Property? property;
  const PropertyMoreDocuments({super.key, required this.property});

  @override
  State<PropertyMoreDocuments> createState() => _PropertyMoreDocumentsState();
}

class _PropertyMoreDocumentsState extends State<PropertyMoreDocuments> {
  Future<void> _openDocs(String url) async {
    print(url);
    try {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      showErrorDialog("Error in launching url", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 70,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffeeeeee)),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        children: <Widget>[
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Documents",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Color(0xff1D3354),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_up_sharp,
                color: Color(0xffbbbbbb),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Certificate of Occupancy",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                  color: MyColors.neutral,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    _openDocs("${widget.property!.certificateOfOccupancy}"),
                child: SvgPicture.asset(
                  "images/ArrowSquareOut.svg",
                  height: 20,
                ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Governor's Consent",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                  color: MyColors.neutral,
                ),
              ),
              GestureDetector(
                onTap: () => _openDocs("${widget.property!.governorConsent}"),
                child: SvgPicture.asset(
                  "images/ArrowSquareOut.svg",
                  height: 20,
                ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Probate & Letter of administration",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                  color: MyColors.neutral,
                ),
              ),
              GestureDetector(
                onTap: () => _openDocs(
                    "${widget.property!.probateLetterOfAdministration}"),
                child: SvgPicture.asset(
                  "images/ArrowSquareOut.svg",
                  height: 20,
                ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Excision & Gazette",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                  color: MyColors.neutral,
                ),
              ),
              GestureDetector(
                onTap: () => _openDocs("${widget.property!.excisionGazette}"),
                child: SvgPicture.asset(
                  "images/ArrowSquareOut.svg",
                  height: 20,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
