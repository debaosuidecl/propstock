import 'package:propstock/models/user.dart';

class NotificationModel {
  String type;
  User? receivedFrom;
  int? deadline;
  String createdAt;
  String? userid;
  String text;
  String? assetid;
  bool? executed;
  String? subtext;
  NotificationModel({
    required this.type,
    this.receivedFrom,
    this.deadline,
    this.userid,
    required this.text,
    this.assetid,
    this.executed,
    this.subtext,
    required this.createdAt,
  });
}
