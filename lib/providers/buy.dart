import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:propstock/models/property.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/models/user_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyPropertyProvider with ChangeNotifier {
  final String _serverName = "https://jawfish-good-lioness.ngrok-free.app";
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

  UserPurchase? userPurchase;

  List<Property> get buyProperties {
    return _buyProperties;
  }

  Property formatProperty(dynamic propItem) {
    return Property(
      id: propItem["_id"].toString(),
      about: propItem["about"].toString(),
      name: propItem["name"].toString(),
      propImage: propItem["propImage"].toString(),
      imagesList: propItem["imagesList"] as List<dynamic>,
      location: propItem["location"].toString(),
      pricePerUnit: propItem["pricePerUnit"].toDouble(),
      volatility: propItem["volatility"].toString(),
      currency: propItem["currency"].toString(),
      amountFunded: propItem["amountFunded"].toDouble(),
      bedNumber: propItem["bedNumber"].toInt(),
      bathNumber: propItem["bathNumber"].toInt(),
      landSize: propItem["landSize"],
      facilities: propItem['facilities'] as List<dynamic>,
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

  void setUserPurchase(UserPurchase? up) {
    userPurchase = up;
  }

  void removeFromAllProp(String prop) {
    selectedFurnitures.remove(prop);
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

  void setJustBought(jb) {
    justbought = jb;
  }

  void setPropertyPurchased(Property? prop) {
    propsuccess = prop;
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

  Future<dynamic> getBuyProperties(
    int page, {
    String? propertyType,
  }) async {
    String url =
        "$_serverName/api/buy?page=$page&minPrice=$minPrice&maxPrice=$maxPrice";
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
      final factor2 = json.decode(response.body)["factor"].toDouble();
      final currency2 = json.decode(response.body)["currency"].toString();

      factor = factor2;
      currency = currency2;

      final responseData = json.decode(response.body)["data"] as List<dynamic>;
      print(responseData);
      List<Property> properties = [];
      for (var i = 0; i < responseData.length; i++) {
        dynamic propItem = responseData[i]['friend'];
        try {
          Property property = formatProperty(propItem);
          properties.add(property);
        } catch (e) {
          print(e);
        }
        // print(propItem["name"]);
      }

      _buyProperties = properties;

      return properties;
      // return accessCode;
      // notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // giftEntirePurchaseToFriend
  Future<dynamic> giftEntirePurchaseToFriend(User? friend, String pin,
      {String? isPass}) async {
    String url =
        "$_serverName/api/buy/gift/${userPurchase!.id}/${friend!.id}?isPass=$isPass";
    try {
      print("hit here $userPurchase");
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

  List<String> _selectedFilters = [];

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
