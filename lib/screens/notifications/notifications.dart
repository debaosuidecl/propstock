import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/notification.dart';
import 'package:propstock/providers/notifications.dart';
import 'package:propstock/screens/notifications/notifications_list.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  static const id = "notification_page";
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsState();
}

class _NotificationsState extends State<NotificationsPage> {
  List<NotificationModel> _notifications = [];
  String activeTab = "All";
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initNotifications();
  }

  Future<dynamic> initNotifications() async {
    try {
      setState(() {
        loading = true;
        _notifications = [];
      });
      final List<NotificationModel> notifications =
          await Provider.of<NotificationProvider>(context, listen: false)
              .fetchNotifications(
        0,
        20,
        deadline: activeTab,
      );

      setState(() {
        _notifications = notifications;
      });
    } catch (e) {
      showErrorDialog(e.toString(), context);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset("images/back_arrow.svg")),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Notifications",
                    style: TextStyle(
                      color: MyColors.secondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      fontFamily: "Inter",
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  decoration:
                      BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color(0xffeeeeee),
                      blurRadius: 2,
                      offset: Offset(0, 3),
                    )
                  ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            activeTab = "All";
                          });

                          initNotifications();
                        },
                        child: Column(
                          children: [
                            Text(
                              "All",
                              style: TextStyle(
                                color: activeTab == "All"
                                    ? MyColors.primary
                                    : MyColors.neutral,
                                fontSize: 18,
                                fontWeight: activeTab == "All"
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Container(
                              height: 2.0, // Adjust the height of the line
                              width: 35,
                              color: activeTab == "All"
                                  ? MyColors.primary
                                  : Colors.white, // Set the color of the line
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            activeTab = "Deadlines";
                          });
                          initNotifications();
                        },
                        child: Column(
                          children: [
                            Text(
                              "Deadlines",
                              style: TextStyle(
                                color: activeTab == "Deadlines"
                                    ? MyColors.primary
                                    : MyColors.neutral,
                                fontSize: 18,
                                fontWeight: activeTab == "Deadlines"
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Container(
                              height: 2.0, // Adjust the height of the line
                              width: 95,
                              color: activeTab == "Deadlines"
                                  ? MyColors.primary
                                  : Colors.white, // Set the color of the line
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                if (loading) Center(child: CircularProgressIndicator()),
                Expanded(
                  child: NotificationsList(
                    notifications: _notifications,
                    execute: (String? createdAt) {
                      print("executing $createdAt");

                      final snackBar = SnackBar(
                        content: Text('${createdAt!.split("xxxxxx")[1]}'),
                        duration: Duration(
                            seconds: 3), // Adjust the duration as needed
                      );

                      // Find the Scaffold in the widget tree and use it to show a SnackBar
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      setState(() {
                        _notifications = _notifications.map((notif) {
                          if (notif.createdAt ==
                              createdAt!.split("xxxxxx")[0]) {
                            print("is equal at some point");
                            notif.executed = true;
                            return notif;
                          }
                          return notif;
                        }).toList();
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
