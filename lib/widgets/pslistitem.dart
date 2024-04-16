import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/screens/affiliate/affiliate.dart';

class PSListItem extends StatelessWidget {
  final String img;
  final String title;
  final String desc;
  final Color color;
  final String actionText;
  final void Function()? action;
  const PSListItem({
    super.key,
    required this.img,
    required this.title,
    required this.desc,
    required this.actionText,
    required this.color,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == "Become an affiliate") {
          Navigator.of(context).push(new PageRouteBuilder(
              opaque: true,
              transitionDuration: const Duration(milliseconds: 100),
              pageBuilder: (BuildContext context, _, __) {
                return new AffiliatePage();
              },
              transitionsBuilder:
                  (_, Animation<double> animation, __, Widget child) {
                return new SlideTransition(
                  child: child,
                  position: new Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation),
                );
              }));
        }
      },
      child: Container(
        // width: MediaQuery.of(context).size.width * .4,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        // height: 250,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: const Color(0xffEBEDF0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(img),
            const SizedBox(
              height: 14,
            ),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              desc,
              style: TextStyle(
                color: Color(0xff8E99AA),
                fontSize: 12,
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
                child: SizedBox(
              height: 0,
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  actionText,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SvgPicture.asset("images/drb.svg")
              ],
            )
          ],
        ),
      ),
    );
  }
}
