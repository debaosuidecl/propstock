import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardHome extends StatelessWidget {
  final Color bg;
  final String assetPath;
  final Color headercolor;
  final String headertext;
  final String desc;
  const CardHome({
    super.key,
    required this.bg,
    required this.assetPath,
    required this.headertext,
    required this.desc,
    required this.headercolor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .45,
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: 153,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.all(
          Radius.circular(
            12,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          SvgPicture.asset(assetPath),
          SizedBox(
            height: 10,
          ),
          Text(
            headertext,
            style: TextStyle(
              color: headercolor,
              fontFamily: "Inter",
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            desc,
            style: TextStyle(
              color: Color(0xff8E99AA),
              fontFamily: "Inter",
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
