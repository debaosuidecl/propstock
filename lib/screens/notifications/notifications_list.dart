import 'package:flutter/material.dart';
import 'package:propstock/models/notification.dart';
import 'package:propstock/screens/notifications/notification_item.dart';

class NotificationsList extends StatelessWidget {
  List<NotificationModel> notifications;
  final void Function(String?)? execute;

  NotificationsList(
      {super.key, required this.notifications, required this.execute});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        NotificationModel notif = notifications[index];
        return NotificationItem(
          notif: notif,
          execute: (String? createdAt) => execute!(createdAt),
        );
      },
    );
  }
}
