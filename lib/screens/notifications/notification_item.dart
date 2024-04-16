import 'package:flutter/material.dart';
import 'package:propstock/models/notification.dart';
import 'package:propstock/screens/notifications/PendingPaymentBuyNotification.dart';
import 'package:propstock/screens/notifications/PendingPaymentInvestmentNotifcation.dart';
import 'package:propstock/screens/notifications/receivedGiftBuyNotification.dart';
import 'package:propstock/screens/notifications/receivedGiftInvestmentNotification.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notif;
  final void Function(String?)? execute;

  const NotificationItem(
      {super.key, required this.notif, required this.execute});

  @override
  Widget build(BuildContext context) {
    if (notif.type == "received_gift_investment") {
      return ReceivedGiftInvestmentNotification(
        notif: notif,
        execute: (String? createdAt) => execute!(createdAt),
      );
    }
    if (notif.type == "received_gift_buy") {
      return ReceivedGiftBuy(
        notif: notif,
        execute: (String? createdAt) => execute!(createdAt),
      );
    }
    if (notif.type == "pending_payment_buy") {
      return PendingPaymentPurchaseNotification(
        notif: notif,
        execute: (String? createdAt) => execute!(createdAt),
      );
    }
    if (notif.type == "pending_payment_invest") {
      return PendingPaymentInvestmentNotification(
        notif: notif,
        execute: (String? createdAt) => execute!(createdAt),
      );
    }

    return Container(
      child: Text(""),
    );
  }
}
