import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/notification.dart';
import 'package:propstock/models/user.dart';
import 'package:timeago/timeago.dart' as timeago;

class PendingPaymentPurchaseNotification extends StatelessWidget {
  final NotificationModel notif;
  final void Function(String?)? execute;

  const PendingPaymentPurchaseNotification(
      {super.key, required this.notif, required this.execute});
  String _addDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  @override
  Widget build(BuildContext context) {
    User? receivedFrom = notif.receivedFrom;

    // Convert epoch timestamp to DateTime
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse("${notif.deadline}"));

    // Format the DateTime
    String formattedDate = DateFormat('MMM y').format(dateTime);

    // Add the suffix to the day
    String dayWithSuffix = _addDaySuffix(dateTime.day);

    // Create the final formatted date string
    String finalFormattedDate = '$dayWithSuffix $formattedDate';

    DateTime createdAt = DateTime.parse(notif.createdAt).toLocal();
    ;

    // print(timeago.format(fifteenAgo));
    return Container(
      // width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            clipBehavior: Clip.hardEdge,
            // width: 40,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: receivedFrom != null
                ? Image.network(
                    "${receivedFrom.avatar}",
                    height: 40,
                  )
                : Icon(Icons.person),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pending Payment",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter",
                    ),
                  ),
                  Text(
                    " on property",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Inter",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width *
                        .8), // Adjust the max width as needed

                child: RichText(
                  text: TextSpan(
                    text:
                        'You have a pending Payment to make on this Purchase. Deadline for payment is ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                      fontFamily: "Inter",
                      color: MyColors.neutral,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: finalFormattedDate,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MyColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                timeago.format(createdAt),
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 12,
                  fontWeight: FontWeight.w200,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: MyColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(
                          8,
                        ))),
                    child: Text(
                      "Pay Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
