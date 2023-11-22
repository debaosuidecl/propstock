import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';

class NotificationsPage extends StatefulWidget {
  static const id = "notification_page";
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsState();
}

class _NotificationsState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SvgPicture.asset("images/back_arrow.svg"),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Notifications",
                  style: TextStyle(
                    color: MyColors.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    fontFamily: "Inter",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
