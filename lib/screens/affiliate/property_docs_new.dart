import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDocsNew extends StatefulWidget {
  final Property? property;
  const PropertyDocsNew({super.key, required this.property});

  @override
  State<PropertyDocsNew> createState() => _PropertyDocsNewState();
}

class _PropertyDocsNewState extends State<PropertyDocsNew> {
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
          Wrap(
            children: widget.property!.titledocuments!.asMap().entries.map((e) {
              var newone = e.value;
              int idx = e.key;

              return Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      newone,
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w200,
                        fontSize: 16,
                        color: MyColors.neutral,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _openDocs(
                          "${widget.property!.docupaths![idx] != null ? widget.property!.docupaths![idx] : widget.property!.docupaths![0]}"),
                      child: SvgPicture.asset(
                        "images/ArrowSquareOut.svg",
                        height: 20,
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
