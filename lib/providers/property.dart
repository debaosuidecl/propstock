import 'dart:convert';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:propstock/models/assets.dart';
// import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:propstock/models/property.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:propstock/models/user.dart';
import 'package:propstock/providers/assets.dart';
import 'package:provider/provider.dart';
// import 'package:propstock/services/crypto.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PropertyProvider with ChangeNotifier {
  final String _serverName = "https://app.propstock.tech";
  // final String _serverName =
  //     Platform.isIOS ? "http://0.0.0.0:5100" : "http://10.0.2.2:5100";
  String selectedInvestmentId = "";

  Property? _selected_property;
  List<Property> _recommended = [];
  bool isFinalPayment = false;
  bool _isCoInvestorPayAfterInitialCoInvestment = false;
  List<Property> _filteredProperties = [];
  bool _filterMode = false;
  double _userShareInCoInvestment = 0;
  Map<String, List<Property>> allPropList = {
    "Rental Income": [],
    "Contract Investment": [],
    "Buy to Resell": [],
  };

  List<String> selectedPropertyOptions = ["Land", "Residential"];

  List<String> selectedInvestmentTypeOptions = [
    "Rental Income",
    "Buy to Resell",
    "Contract Investment",
  ];

  List<String> selectedStatus = [
    "Partly funded",
    "Fully funded",
    "Not funded",
  ];

  List<Property> _seeAllProperties = [];

  String selectedCountry = "";

  String selectedState = "";
  String selectedCurrency = "USD";
  String selectedInvestmentType = "";
  double maxPrice = 400000;
  double minPrice = 0;

  AssetModel? assetToGift;

  User? friendAsGift;

  List<User> _coInvestors = [];

  Property? get selectedProperty {
    return _selected_property;
  }

  double get userShareInCoInvestment {
    return _userShareInCoInvestment;
  }

  bool get isCoInvestorPayAfterInitialCoInvestment {
    return _isCoInvestorPayAfterInitialCoInvestment;
  }

  List<User> get coInvestors {
    return _coInvestors;
  }

  List<Property> get recommended {
    return _recommended;
  }

  List<Property> get seeAllProperties {
    return _seeAllProperties;
  }

  List<Property> get filteredProperties {
    return _filteredProperties;
  }

  bool get filterMode {
    return _filterMode;
  }

// setters
  void setSelectedProperty(Property prop) {
    _selected_property = prop;
  }

  void setUserShareInCoInvestment(double share) {
    _userShareInCoInvestment = share;
  }

  void setIsCoInvestorPayAfterInitialCoInvestment(bool response) {
    _isCoInvestorPayAfterInitialCoInvestment = response;
  }

  void setCoInvestors(List<User> coinv) {
    _coInvestors = coinv;
    // notifyListeners();
  }

  void setFriendAsGift(User? user) {
    friendAsGift = user;
  }

  void setAssetToGift(AssetModel? asset) {
    assetToGift = asset;
  }

  void clearFilter() {
    _filterMode = false;

    selectedPropertyOptions = ["Land", "Residential"];

    selectedInvestmentTypeOptions = [
      "Rental Income",
      "Buy to Resell",
      "Contract Investment",
    ];

    selectedStatus = [
      "Partly funded",
      "Fully funded",
      "Not funded",
    ];

    selectedCountry = "";

    selectedState = "";
    selectedCurrency = "USD";
    maxPrice = 400000;
    minPrice = 0;
    notifyListeners();
  }

  void setFilters(
    List<String> propertyOptions,
    List<String> investmentTypeOptions,
    List<String> status,
    String country,
    String state,
    mxPrice,
    double mnPrice,
  ) {
    selectedPropertyOptions = propertyOptions;
    selectedInvestmentTypeOptions = investmentTypeOptions;
    selectedStatus = status;
    selectedCountry = country;
    selectedState = state;
    maxPrice = mxPrice;
    minPrice = mnPrice;
    _filterMode = true;
    notifyListeners();
  }

  void setCurrency(String currency) {
    selectedCurrency = currency;
    notifyListeners();
  }

  void setInvestmentType(String itype) {
    selectedInvestmentType = itype;
    notifyListeners();
  }

  Future<dynamic> fetchFriends(String query) async {
    String url = "$_serverName/api/property/friends?friend=$query";
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

      List<User> users = [];

      for (int i = 0; i < responseData.length; i++) {
        dynamic useritem = responseData[i];
        print(useritem);
        User user = User(
          firstName: useritem["firstName"].toString(),
          lastName: useritem["lastName"].toString(),
          userName: useritem["email"].toString(),
          avatar: useritem['avatar'].toString(),
          id: useritem['_id'].toString(),
        );

        users.add(user);
      }
      // User user = User(firstName: responseData["firstName"].toString())
      return users;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> fetchPropertyPriceData(
      String id, String searchcriteria) async {
    String url =
        "$_serverName/api/property/price/$id?searchcriteria=$searchcriteria";
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
      List<FlSpot> priceData = [];

      for (var i = 0; i < responseData.length; i++) {
        dynamic propdataItem = responseData[i];
        selectedCurrency = propdataItem['currency'].toString();
        double price = propdataItem["price"].toDouble();
        double date = propdataItem["timeOfData"].toDouble();
        priceData.add(FlSpot(date, price));
      }
      print("success");
      return priceData;
      // _recommended = properties;

      // notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  printlargetring(String largeString) {
    int chunkSize = 100;

    // Iterate over the string and print it in chunks
    for (int i = 0; i < largeString.length; i += chunkSize) {
      // Calculate the end of the current chunk
      int end = (i + chunkSize < largeString.length)
          ? i + chunkSize
          : largeString.length;

      // Extract and print the current chunk
      String chunk = largeString.substring(i, end);
      print(chunk);
    }
  }

  Property formatProperty(dynamic propItem) {
    printlargetring(propItem.toString());
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
      // longitude: propItem["longitude"].toDouble(),
      availableUnit: 1000,
      totalUnits: 1000,
      // leverage: propItem["leverage"].toInt(),
      // minHoldingTime: propItem["minHoldingTime"].toInt(),
      certificateOfOccupancy: propItem["certificateOfOccupancy"].toString(),
      governorConsent: propItem["governorConsent"].toString(),
      probateLetterOfAdministration:
          propItem["probateLetterOfAdministration"].toString(),
      excisionGazette: propItem["excisionGazette"].toString(),
      tags: propItem["tags"] as List<dynamic>,
      // latitude: propItem["latitude"].toDouble(),
      // plotNumber: propItem["plotNumber"].toInt(),
      totalAmountToFund: propItem["totalAmountToFund"].toDouble(),
      propertyType: propItem["propertyType"].toString(),
      investmentType: propItem["investmentType"].toString(),
      // maturitydate: propItem["maturitydate"].toInt(),
      maturitydate: 0,
      status: propItem["status"].toString(),
    );
  }

  Future<dynamic> fetchUserInvestmentByPropertyId(String id) async {
    String url = "$_serverName/api/property/investment/$id";
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
      if (responseData == null) return null;
      Property prop = formatProperty(responseData["property"]);
      return prop;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // Main functions
  Future<void> fetchSeeAllProperty(int limit, int page) async {
    String url = selectedInvestmentType == "Recommended"
        ? "$_serverName/api/property/recommended?limit=$limit&page=$page"
        : "$_serverName/api/property?investmentType=$selectedInvestmentType&limit=$limit&page=$page";
    ;
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
      List<Property> properties = [];

      for (var i = 0; i < responseData.length; i++) {
        dynamic propItem = responseData[i];
        try {
          Property property = formatProperty(propItem);
          properties.add(property);
        } catch (e) {
          print(e);
        }
        // print(propItem["name"]);
      }
      print("success");
      _seeAllProperties = properties;

      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> getRecommended() async {
    String url = "$_serverName/api/property/recommended";
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
      List<Property> properties = [];

      for (var i = 0; i < responseData.length; i++) {
        dynamic propItem = responseData[i];
        try {
          Property property = formatProperty(propItem);
          properties.add(property);
        } catch (e) {
          print(e);
        }
        // print(propItem["name"]);
      }
      print("success");
      _recommended = properties;

      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> queryProperty(String investmentType) async {
    String url = "$_serverName/api/property";
    try {
      final token = await gettoken();
      var response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      // print(response.body);
      // print("line 545");

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"] as List<dynamic>;

      print(responseData);
      List<Property> properties = [];

      for (var i = 0; i < responseData.length; i++) {
        dynamic propItem = responseData[i];
        Property property = formatProperty(propItem);

        properties.add(property);
      }

      return properties;
      // print("success");
      // allPropList["$investmentType"] = properties;

      // notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> queryPropertyWithFilter(int limit, int page) async {
    String url = "$_serverName/api/property?page=$page&limit=$limit";
    try {
      final token = await gettoken();
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json", "x-auth-token": token},
          body: json.encode({
            "investmentTypeOptions": selectedInvestmentTypeOptions,
            "propertyTypeOptions": selectedPropertyOptions,
            "statusOptions": selectedStatus,
            "country": selectedCountry,
            "state": selectedState,
            "maxPrice": maxPrice,
            "minPrice": minPrice,
          }));

      // print(response.body);
      // print("line 545");

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"] as List<dynamic>;
      // print(responseData);
      List<Property> properties = [];

      for (var i = 0; i < responseData.length; i++) {
        dynamic propItem = responseData[i];
        Property property = formatProperty(propItem);

        properties.add(property);
      }
      print("success");

      _filteredProperties = _filteredProperties + properties;

      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> initializePaystackPayment(
      Property? selectedProperty,
      int quantity,
      double coInvestAmount,
      List<User> coInvestors,
      User? friendAsGift,
      String? paystackType,
      {String? investmentId}) async {
    String url = "$_serverName/api/property/paystack/payments/initialize";

    if (paystackType == "buy" || paystackType == "cobuy") {
      url = "$_serverName/api/property/paystack/payments/buy/initialize";
    }

    // if(isCoInvestorPayAfterInitialCoInvestment){
    print(
        " this is the investmen id on property provider: $selectedInvestmentId");
    // }
    try {
      final token = await gettoken();
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "property_id": selectedProperty!.id,
          "quantity": quantity,
          "friend_to_gift_username":
              friendAsGift != null ? friendAsGift.id : "",
          "coInvestors": coInvestors.map((e) => e.id).toList(),
          "coInvestAmount": coInvestAmount,
          "isCoInvestorPayAfterInitialCoInvestment":
              isCoInvestorPayAfterInitialCoInvestment,
          "currency": selectedCurrency,
          "selected_investment_id": selectedInvestmentId,
          "is_final_payment": isFinalPayment,

          // ""
        }),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final accessCode = json.decode(response.body)["data"] as String;
      return accessCode;
      // notifyListeners();
    } catch (e) {
      print("error at this level");
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
