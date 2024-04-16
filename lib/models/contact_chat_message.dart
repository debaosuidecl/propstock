import 'package:flutter/material.dart';
import 'package:propstock/models/user.dart';

class ContactChatMessage {
  String room_id;
  User sentBy;
  String message;
  int date;
  bool sent;
  String? encryptedId;

  // String? flagurl;
  // String? userid;

  ContactChatMessage({
    required this.room_id,
    required this.sentBy,
    required this.message,
    required this.date,
    required this.sent,
    this.encryptedId,
  });
}
