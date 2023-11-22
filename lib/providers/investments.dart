import 'dart:convert';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:propstock/models/asset_distribution.dart';
import 'package:propstock/models/profit_rev_profile_investment.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/models/user_bank_account.dart';
import 'package:propstock/models/user_investment.dart';
// import 'package:propstock/models/wallet.dart';

import 'package:shared_preferences/shared_preferences.dart';

class InvestmentsProvider with ChangeNotifier {
  final String _serverName = "https://jawfish-good-lioness.ngrok-free.app";

  UserInvestment? _selectedInvestment;
  UserBankAccount? _selectedBankAccount;

  String? _currency;
  double _amountToWithdraw = 0.0;
  double _unitsToSellMarketPlace = 0;
  double _priceToSellMarketPlace = 0;
  bool _allowCoInvestProperty = false;

  /// getters
  ///
  UserInvestment? get selectedInvestment {
    return _selectedInvestment;
  }

  UserBankAccount? get selectedBankAccount {
    return _selectedBankAccount;
  }

  double get unitsToSellMarketPlace {
    return _unitsToSellMarketPlace;
  }

  double get amountToWithdraw {
    return _amountToWithdraw;
  }

  String? get currency {
    return _currency;
  }

  double get priceToSellMarketPlace {
    return _priceToSellMarketPlace;
  }

  bool get allowCoInvestProperty {
    return _allowCoInvestProperty;
  }

  // setters
  void setSelectedUserBankAccount(UserBankAccount userBankAccount) {
    _selectedBankAccount = userBankAccount;
    notifyListeners();
  }

  void setPriceAndUnitsAndAllowCoInvestToSellMarketPlace(
    double price,
    double units,
    bool allowCoInvest,
  ) {
    _unitsToSellMarketPlace = units;
    _priceToSellMarketPlace = price;
    _allowCoInvestProperty = allowCoInvest;
    notifyListeners();
  }

  void setSelectedInvestment(UserInvestment? sel) {
    _selectedInvestment = sel;
  }

  void setAmountToWithdraw(double amount) {
    _amountToWithdraw = amount;
    print("699999 | $_amountToWithdraw |$amount");
    notifyListeners();
  }

  Future<dynamic> uploadPropertyToMarketPlace(
    UserInvestment investment,
  ) async {
    // print("hit here ${investment.id}");

    String url =
        "$_serverName/api/investments/marketplace/upload/${investment.id}";
    try {
      print("hit here $investment");
      final token = await gettoken();
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "units": _unitsToSellMarketPlace,
          "price": _priceToSellMarketPlace,
          "allowCoInvest": _allowCoInvestProperty,
        }),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"];

      // print(responseData);
      return responseData;
      // notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> giftEntireInvestmentToFriend(User? friend, String pin,
      {String? isPass}) async {
    String url =
        "$_serverName/api/investments/gift/${_selectedInvestment!.id}/${friend!.id}?ispass=$isPass";
    try {
      print("hit here $_selectedInvestment");
      final token = await gettoken();
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({"pin": pin}),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"];

      // print(responseData);
      return responseData;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Property formatProperty(dynamic propItem) {
    return Property(
      id: propItem["_id"].toString(),
      about: propItem["about"].toString(),
      name: propItem["name"].toString(),
      propImage: propItem["imagesList"]![0].toString(),
      imagesList: propItem["imagesList"] as List<dynamic>,
      location: propItem["location"].toString(),
      pricePerUnit: propItem["pricePerUnit"].toDouble(),
      volatility: propItem["volatility"].toString(),
      currency: propItem["currency"].toString(),
      amountFunded: propItem["amountFunded"].toDouble(),
      bedNumber: propItem["bedNumber"].toInt(),
      bathNumber: propItem["bathNumber"].toInt(),
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
      tags: propItem["tags"] as List<dynamic>,
      latitude: propItem["latitude"].toDouble(),
      plotNumber: propItem["plotNumber"].toInt(),
      totalAmountToFund: propItem["totalAmountToFund"].toDouble(),
      propertyType: propItem["propertyType"].toString(),
      investmentType: propItem["investmentType"].toString(),
      maturitydate: propItem["maturitydate"].toInt(),
      status: propItem["status"].toString(),
    );
  }

  Future<dynamic> fetchInvestments(String q, int page, int limit,
      {String? propSearch}) async {
    String url =
        "$_serverName/api/investments?q=$q&page=$page&limit=$limit&prp=$propSearch";
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

      // print(responseData);

      List<UserInvestment> userInvestments = [];

      for (int i = 0; i < responseData.length; i++) {
        dynamic userInvItem = responseData[i];
        final userCoInvestorsItem = userInvItem["coInvestors"] as List<dynamic>;
        List<User> coInvestors = [];
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

        if (i == 0) {
          _currency = userInvItem["property"]['currency'];
        }
        UserInvestment userInv = UserInvestment(
          amountWithdrawn: userInvItem["amountWithdrawn"].toDouble(),
          id: userInvItem["_id"].toString(),
          property: formatProperty(
            userInvItem["property"],
          ),
          isCoInvestor: userInvItem["isCoInvestor"] == "true",
          isInitiatorOfCoInvestment:
              userInvItem['isInitiatorOfCoInvestment'] == "true",
          propertyType: userInvItem["propertyType"].toString(),
          coInvestAmount: userInvItem["coInvestAmount"].toDouble(),
          coInvestors: coInvestors,
          maturityDate: userInvItem["maturityDate"].toInt(),
          quantity: userInvItem["quantity"].toInt(),
          pricePerUnitAtPurchase:
              userInvItem["pricePerUnitAtPurchase"].toDouble(),
        );
        userInvestments.add(userInv);
      }

      return userInvestments;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> fetchMatureInvestmentsWithAvailableBalance(
      String q, int page, int limit,
      {String? propSearch}) async {
    String url =
        "$_serverName/api/investments/with-available-balance?q=$q&page=$page&limit=$limit";
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

      List<UserInvestment> userInvestments = [];

      for (int i = 0; i < responseData.length; i++) {
        dynamic userInvItem = responseData[i];
        final userCoInvestorsItem = userInvItem["coInvestors"] as List<dynamic>;
        List<User> coInvestors = [];
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

        if (i == 0) {
          _currency = userInvItem["property"]['currency'];
        }
        UserInvestment userInv = UserInvestment(
          amountWithdrawn: userInvItem["amountWithdrawn"].toDouble(),
          id: userInvItem["_id"].toString(),
          property: formatProperty(
            userInvItem["property"],
          ),
          isCoInvestor: userInvItem["isCoInvestor"] == "true",
          isInitiatorOfCoInvestment:
              userInvItem['isInitiatorOfCoInvestment'] == "true",
          propertyType: userInvItem["propertyType"].toString(),
          coInvestAmount: userInvItem["coInvestAmount"].toDouble(),
          coInvestors: coInvestors,
          maturityDate: userInvItem["maturityDate"].toInt(),
          quantity: userInvItem["quantity"].toInt(),
          pricePerUnitAtPurchase:
              userInvItem["pricePerUnitAtPurchase"].toDouble(),
        );
        userInvestments.add(userInv);
      }

      return userInvestments;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> fetchProfitOnInvestment() async {
    String url =
        "$_serverName/api/investments/profit-rev/${_selectedInvestment!.id}";
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

      // List<UserInvestment> userInvestments = [];

      double profit = responseData['profit'].toDouble();
      double revenue = responseData['revenue'].toDouble();

      ProfitRevProfileInvestment profitRev = ProfitRevProfileInvestment(
        profit: profit,
        revenue: revenue,
        notmature: responseData["notmature"].toString(),
      );

      return profitRev;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // HELPER FUNCTIONS
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

  bool hasBadRequestError(String body) {
    if (json.decode(body)['error'] == true) {
      return true;
    }
    return false;
  }
}
