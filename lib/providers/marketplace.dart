import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:propstock/models/market_place.dart';
import 'package:propstock/models/notification.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/models/user_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarketPlaceProvider with ChangeNotifier {
  final String _serverName = "https://app.propstock.tech";
  bool filterMode = false;
  List<String> selectedPropertyTypes = ["All"];
  List<String> selectedFurnitures = ["All"];
  List<String> selectedavailabilitys = ["All"];
  List<String> selectedfacilities = ["All"];
  bool justbought = false;
  List<String> allProps = [];
  int bathNumber = 0;
  int bedNumber = 0;
  double minPrice = 0;
  double maxPrice = 500000;
  double factor = 700;
  String currency = "USD";
  String state = "";
  String? country = "";
  Property? propsuccess;
  List<Property> _buyProperties = [];

  void removeFromAllProp(String prop) {
    selectedFurnitures.remove(prop);

    if (prop.contains("min price")) {
      minPrice = 0;
    }
    if (prop.contains("max price")) {
      maxPrice = 500000;
    }
    if (selectedFurnitures.isEmpty) {
      selectedFurnitures = ["All"];
    }
    selectedPropertyTypes.remove(prop);
    if (selectedPropertyTypes.isEmpty) {
      selectedPropertyTypes = ["All"];
    }

    selectedavailabilitys.remove(prop);
    if (selectedavailabilitys.isEmpty) {
      selectedavailabilitys = ["All"];
    }
    selectedfacilities.remove(prop);

    if (selectedfacilities.isEmpty) {
      selectedfacilities = ["All"];
    }
    allProps.remove(prop);
    print("new all props");
    print(allProps);
  }

  void setFilters(
    List<String> sPropertyOptions,
    List<String> savailabilitys,
    List<String> sfurnitures,
    List<String> sfacilities,
    String? selectedCountry,
    String selectedState,
    double selectedMaxPrice,
    double selectedMinPrice,
    String sbedNumber,
    String sbathNumber,
    // RangeValues minMax
  ) {
    try {
      if (sbathNumber.isNotEmpty) {
        bathNumber = int.parse(sbathNumber);
      } else {
        bathNumber = 0;
      }
      if (sbedNumber.isNotEmpty) {
        bedNumber = int.parse(sbedNumber);
      } else {
        bedNumber = 0;
      }

      minPrice = selectedMinPrice / factor;
      maxPrice = selectedMaxPrice / factor;
      state = selectedState;
      country = selectedCountry;
      selectedPropertyTypes =
          sPropertyOptions.isEmpty ? ["All"] : sPropertyOptions;
      selectedavailabilitys = savailabilitys.isEmpty ? ["All"] : savailabilitys;
      selectedFurnitures = sfurnitures.isEmpty ? ["All"] : sfurnitures;
      selectedfacilities = sfacilities.isEmpty ? ["All"] : sfacilities;

      filterMode = true;
      allProps.removeWhere((element) =>
          element.contains("min price ") || element.contains("max price "));
      allProps.add("min price $currency${minPrice * factor}");
      allProps.add("max price $currency${maxPrice * factor}");

      if (selectedState.isNotEmpty) {
        allProps.add(selectedState);
      }
      if (selectedCountry != null) {
        allProps.add(selectedCountry);
      }

      if (!selectedPropertyTypes.contains("All")) {
        allProps = allProps + selectedPropertyTypes;
      }
      if (!selectedavailabilitys.contains("All")) {
        allProps = allProps + selectedavailabilitys;
      }
      if (!selectedFurnitures.contains("All")) {
        allProps = allProps + selectedFurnitures;
      }

      if (!selectedfacilities.contains("All")) {
        allProps = allProps + selectedfacilities;
      }
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

  Future<dynamic> fetchMarketPlace(int page, int limit,
      {String? propertyType}) async {
    String url =
        "$_serverName/api/marketplace?page=$page&limit=$limit&minPrice=$minPrice&maxPrice=$maxPrice";
    try {
      final token = await gettoken();

      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "propertyTypes":
              propertyType != null ? [propertyType] : selectedPropertyTypes,
          "furnitures": selectedFurnitures,
          "availabilitys": selectedavailabilitys,
          "facilities": selectedfacilities,
          "bathNumber": bathNumber,
          "country": country,
          "state": state,
          "bedNumber": bedNumber,
        }),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"] as List<dynamic>;
      final factor2 = json.decode(response.body)["factor"].toDouble();
      final currency2 = json.decode(response.body)["currency"].toString();

      factor = factor2;
      currency = currency2;
      // print(responseData[0]["investment"]["coInvestors"]);

      List<MarketPlaceProduct> marketPlaceProducts = [];

      for (int i = 0; i < responseData.length; i++) {
        dynamic marketPlaceProduct = responseData[i];

        final receivedFromRaw = marketPlaceProduct["uploader"] as dynamic;
        UserInvestment? userInv;
        if (marketPlaceProduct["investment"] != null) {
          print("hit here 76");
          dynamic userInvItem = marketPlaceProduct["investment"];
          final userCoInvestorsItem =
              marketPlaceProduct["investment"]["coInvestors"] as List<dynamic>;
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

          print('hit here 95');

          userInv = UserInvestment(
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
        }

        print('hit here 117');

        MarketPlaceProduct marketproduct = MarketPlaceProduct(
          // type: marketPlaceProduct["type"].toString(),
          // text: marketPlaceProduct["text"].toString(),
          uploader: receivedFromRaw != null
              ? User(
                  firstName: receivedFromRaw["firstName"],
                  lastName: receivedFromRaw["lastName"],
                  userName: receivedFromRaw["email"],
                  id: receivedFromRaw["_id"],
                  avatar: receivedFromRaw["avatar"],
                )
              : null,
          investment: userInv,

          investmentid: marketPlaceProduct["investment_id"],
          productid: marketPlaceProduct["_id"],

          property: formatProperty(marketPlaceProduct['property']),

          allowCoInvest: marketPlaceProduct['allowCoInvest'] == true,
          units: marketPlaceProduct["units"].toInt(),
          currency: marketPlaceProduct["currency"],
          price: marketPlaceProduct["price"].toDouble(),
        );

        marketPlaceProducts.add(marketproduct);
      }

      return marketPlaceProducts;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> placeBid(
      String amount, String? currency, String? marketplaceid) async {
    String url = "$_serverName/api/marketplace/place-bid/$marketplaceid";
    final token = await gettoken();

    try {
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({"amount": amount, "currency": currency}),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"];

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
