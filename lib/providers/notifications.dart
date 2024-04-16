import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:propstock/models/notification.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/models/user_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider with ChangeNotifier {
  final String _serverName = "https://jawfish-good-lioness.ngrok-free.app";

  Future<dynamic> fetchNotifications(int page, int limit,
      {String? deadline}) async {
    String url =
        "$_serverName/api/notifications?page=$page&limit=$limit&deadline=$deadline";
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

      print(responseData);

      List<NotificationModel> userNotifications = [];

      for (int i = 0; i < responseData.length; i++) {
        dynamic userNotItem = responseData[i];

        final receivedFromRaw = userNotItem["receivedFrom"] as dynamic;

        NotificationModel userNot = NotificationModel(
          type: userNotItem["type"].toString(),
          text: userNotItem["text"].toString(),
          receivedFrom: receivedFromRaw != null
              ? User(
                  firstName: receivedFromRaw["firstName"],
                  lastName: receivedFromRaw["lastName"],
                  userName: receivedFromRaw["email"],
                  id: receivedFromRaw["_id"],
                  avatar: receivedFromRaw["avatar"],
                )
              : null,
          deadline: userNotItem["deadline"]?.toInt(),
          userid: userNotItem["user_id"].toString(),
          assetid: userNotItem["asset_id"]?.toString(),
          executed: userNotItem["executed"],
          subtext: userNotItem["subtext"]?.toString(),
          createdAt: userNotItem['createdAt'].toString(),
        );

        userNotifications.add(userNot);
      }

      return userNotifications;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> acceptOrRejectGift(
      String status, String giftrequesterid, String? assetid) async {
    String url =
        "$_serverName/api/friend/accept-gift/$assetid?giftrequesterid=$giftrequesterid&status=$status";
    try {
      final token = await gettoken();

      var response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"] as dynamic;

      print(responseData);

      return responseData;
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
