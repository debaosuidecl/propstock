import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:propstock/models/contact_chat_message.dart';
// import 'package:propstock/models/Faqs.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/models/user_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactProvider with ChangeNotifier {
  final String _serverName = "https://jawfish-good-lioness.ngrok-free.app";

  Future<dynamic> getMessages(int page) async {
    String url = "$_serverName/api/contacts/chat/get-messages?page=$page";
    try {
      final token = await gettoken();

      var response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"] as List<dynamic>;
      final customerServiceData =
          json.decode(response.body)["customerServiceAccount"] as dynamic;

      print(customerServiceData);

      print(responseData);

      final User CustomerServiceDataReal = User(
        firstName: customerServiceData["firstName"].toString(),
        lastName: customerServiceData["lastName"].toString(),
        userName: customerServiceData["email"].toString(),
        id: customerServiceData["_id"].toString(),
        avatar: customerServiceData['avatar'],
      );
      print(43);
      final List<ContactChatMessage> messages = [];

      for (int i = 0; i < responseData.length; i++) {
        dynamic message = responseData[i];

        User sentBy = User(
          firstName: message['sentBy']['firstName'],
          lastName: message['sentBy']['lastName'],
          userName: message['sentBy']['email'],
          id: message['sentBy']['_id'],
        );
        print(56);

        ContactChatMessage newMessage = ContactChatMessage(
          room_id: message['room_id'],
          sentBy: sentBy,
          message: message['message'],
          sent: true,
          date: message['date'],
        );

        messages.add(newMessage);
      }

      print(66);

      print(responseData);
      // print(62);
      dynamic chatObject = {
        "messages": messages,
        "customer_service": CustomerServiceDataReal,
      };

      print(chatObject);
      return chatObject;

      // return responseData;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> sendMessage(ContactChatMessage message) async {
    String url = "$_serverName/api/contacts/chat/sendmessage";
    try {
      final token = await gettoken();
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json", "x-auth-token": token},
          body: json.encode({
            "message": message.message,
            "room_id": message.room_id,
            "sentBy": message.sentBy.id,
            "encryptedId": message.encryptedId,
          }));

      // print(response.body);
      // print("line 545");

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"] as dynamic;
      // print(responseData);

      ContactChatMessage messageSaved = ContactChatMessage(
          room_id: responseData["room_id"],
          sentBy: message.sentBy,
          message: message.message,
          date: message.date,
          encryptedId: message.encryptedId,
          sent: true);
      return responseData;

      // notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<String> gettoken() async {
    String token = "";

    try {
      final prefs = await SharedPreferences.getInstance();

      // return true;
      if (!prefs.containsKey('userData')) {
        throw "no user data";
      }
      final extractedUserData =
          json.decode(prefs.getString('userData') as String)
              as Map<String, dynamic>;

      token = extractedUserData['token'] as String;
    } catch (e) {
      print(e);
    }
    return token;
  }

  bool hasAuthError(String body) {
    if (json.decode(body)['message'] == "Auth Error" ||
        json.decode(body)['message'] == "Invalid Token") {
      return true;
    }

    return false;
  }

  bool hasBadRequestError(String body) {
    if (json.decode(body)['error'] == true) {
      return true;
    }
    return false;
  }
}
