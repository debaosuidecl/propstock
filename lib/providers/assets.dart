import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:propstock/models/assets.dart';
import 'package:propstock/models/notification.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/models/user_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssetsProvider with ChangeNotifier {
  final String _serverName = "https://jawfish-good-lioness.ngrok-free.app";

  Property formatProperty(dynamic propItem) {
    return Property(
      id: propItem["_id"].toString(),
      about: propItem["about"].toString(),
      name: propItem["name"].toString(),
      propImage: propItem["propImage"].toString(),
      imagesList: propItem["imagesList"] as List<dynamic>?,
      location: propItem["location"].toString(),
      pricePerUnit: propItem["pricePerUnit"].toDouble(),
      volatility: propItem["volatility"].toString(),
      currency: propItem["currency"].toString(),
      amountFunded: propItem["amountFunded"].toDouble(),
      bedNumber: propItem["bedNumber"].toInt(),
      bathNumber: propItem["bathNumber"].toInt(),
      landSize: propItem["landSize"],
      facilities: propItem['facilities'] as List<dynamic>?,
      availability: propItem['availability'].toString(),
      furniture: propItem['furniture'].toString(),
      longitude: propItem["longitude"].toDouble(),
      availableUnit: propItem["availableUnit"].toInt(),
      totalUnits: propItem["totalUnits"].toInt(),
      leverage: propItem["leverage"].toInt(),
      minHoldingTime: propItem["minHoldingTime"].toInt(),
      certificateOfOccupancy: propItem["certificateOfOccupancy"].toString(),
      governorConsent: propItem["governorConsent"].toString(),
      probateLetterOfAdministration:
          propItem["probateLetterOfAdministration"].toString(),
      excisionGazette: propItem["excisionGazette"].toString(),
      tags: propItem["tags"] as List<dynamic>?,
      latitude: propItem["latitude"].toDouble(),
      plotNumber: propItem["plotNumber"].toInt(),
      totalAmountToFund: propItem["totalAmountToFund"].toDouble(),
      propertyType: propItem["propertyType"].toString(),
      investmentType: propItem["investmentType"].toString(),
      maturitydate: propItem["maturitydate"].toInt(),
      status: propItem["status"].toString(),
    );
  }

  Future<dynamic> fetchAssets(
    String q,
    int page,
    int limit, {
    String? propSearch,
    String? status,
  }) async {
    String url =
        "$_serverName/api/property/assetspage?q=$q&page=$page&limit=$limit&prp=$propSearch&status=$status";
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

      // print(responseData);

      List<AssetModel> userAssets = [];

      for (int i = 0; i < responseData.length; i++) {
        dynamic userAssetItem = responseData[i];
        print("userassetitem ${userAssetItem['coBuyers']}");
        if (userAssetItem["isBuy"] == true) {
          List<User> coBuyers = [];
          if (userAssetItem["coBuyers"] != null) {
            final coBuyersItem = userAssetItem["coBuyers"] as List<dynamic>;
            for (int j = 0; j < coBuyersItem.length; j++) {
              dynamic cobuyer = coBuyersItem[j];

              User coBuy = User(
                firstName: cobuyer['firstName'].toString(),
                lastName: cobuyer['lastName'],
                userName: cobuyer['email'],
                avatar: cobuyer['avatar'],
                id: cobuyer['_id'],
              );

              coBuyers.add(coBuy);
            }
          }

          print("hit here for buy");
          UserPurchase userPurchase = UserPurchase(
            // amountWithdrawn: userAssetItem["amountWithdrawn"].toDouble(),
            id: userAssetItem["_id"].toString(),
            property: formatProperty(
              userAssetItem["property"],
            ),
            isCoBuyer: userAssetItem["isCoBuyer"] == "true",
            isInitiatorOfCoBuying:
                userAssetItem['isInitiatorOfCoBuying'] == "true",
            propertyType: userAssetItem["propertyType"].toString(),
            coBuyAmount: userAssetItem["coBuyAmount"].toDouble(),
            coBuyers: coBuyers,
            // maturityDate: userAssetItem["maturityDate"].toInt(),
            quantity: userAssetItem["quantity"].toInt(),
            createdAt: userAssetItem["createdAt"].toInt(),

            pricePerUnitAtPurchase:
                userAssetItem["pricePerUnitAtPurchase"].toDouble(),
          );
          userAssets.add(
              AssetModel(userInvestment: null, userPurchase: userPurchase));
        } else {
          print("hit here for inv  ${userAssetItem["coInvestors"]} $i");
          List<User> coInvestors = [];

          if (userAssetItem["coInvestors"] != null) {
            print("hit here at 190");
            final userCoInvestorsItem =
                userAssetItem["coInvestors"] as List<dynamic>;
            print("hit here for inv $userCoInvestorsItem");

            for (int j = 0; j < userCoInvestorsItem.length; j++) {
              dynamic coinvitem = userCoInvestorsItem[j];

              User coInv = User(
                firstName: coinvitem['firstName'].toString(),
                lastName: coinvitem['lastName'],
                userName: coinvitem['email'],
                avatar: coinvitem['avatar'],
                id: coinvitem['_id'],
              );

              coInvestors.add(coInv);
            }
          }

          print("even got here after the loop $coInvestors");

          // if (i == 0) {
          //   _currency = userAssetItem["property"]['currency'];
          // }
          UserInvestment userInv = UserInvestment(
            amountWithdrawn: userAssetItem["amountWithdrawn"].toDouble(),
            id: userAssetItem["_id"].toString(),
            property: formatProperty(
              userAssetItem["property"],
            ),
            isCoInvestor: userAssetItem["isCoInvestor"] == "true",
            isInitiatorOfCoInvestment:
                userAssetItem['isInitiatorOfCoInvestment'] == "true",
            propertyType: userAssetItem["propertyType"].toString(),
            coInvestAmount: userAssetItem["coInvestAmount"].toDouble(),
            coInvestors: coInvestors,
            maturityDate: userAssetItem["maturityDate"].toInt(),
            createdAt: userAssetItem["createdAt"].toInt(),
            quantity: userAssetItem["quantity"].toInt(),
            pricePerUnitAtPurchase:
                userAssetItem["pricePerUnitAtPurchase"].toDouble(),
          );
          print("even got here after append $userInv");

          userAssets
              .add(AssetModel(userInvestment: userInv, userPurchase: null));
        }
      }

      return userAssets;
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
