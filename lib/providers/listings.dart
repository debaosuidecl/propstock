import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
// import 'package:propstock/models/Faqs.dart';
import 'package:mime/mime.dart'; // Import for MIME type detection

import 'package:propstock/models/property.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/models/user_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart'; // Import for MediaType

class ListingsProvider with ChangeNotifier {
  final String _serverName = "https://app.propstock.tech";

  String listingType = "";

  String description = "";
  String name = "";
  String uses = "";
  String why = "";
  String address = "";
  String country = "";
  String state = "";
  String housename = "";
  String duplextype = "";
  List<String> houseFeatures = [];
  List<String> titleDocuments = [];
  List<PlatformFile> titleDocumentFiles = [];
  String toilet = "";
  String price = "";
  String squaremeter = "";
  String currency = "";
  String bedroom = "";
  String floor = "";
  List<File> selectedPropertyImages = [];

  void setHouseFeatures(List<String> features) {
    houseFeatures = features;
    notifyListeners();
  }

  void setTitleDocuments(List<String> titledocuments) {
    titleDocuments = titledocuments;
    notifyListeners();
  }

  void removeHouseFeatures(String feature) {
    houseFeatures.remove(feature);
    notifyListeners();
  }

  void removeTitleDocuments(String title) {
    titleDocuments.remove(title);
    notifyListeners();
  }

  Property formatProperty(dynamic propItem) {
    return Property(
      id: propItem["_id"].toString(),
      about: propItem["about"].toString(),
      name: propItem["name"].toString(),
      titledocuments: propItem["titleDocuments"] as List<dynamic>,
      docupaths: propItem["docupaths"] as List<dynamic>,
      propImage: propItem["imagesList"]![0].toString(),
      imagesList: propItem["imagesList"] as List<dynamic>,
      location: propItem["location"].toString(),
      pricePerUnit: propItem["pricePerUnit"].toDouble(),
      volatility: propItem["volatility"].toString(),
      currency: propItem["currency"].toString(),
      amountFunded: 0.00001,
      published: propItem["published"],
      housename: propItem["housename"],
      floor: propItem["floor"],
      landSize: propItem["landSize"],
      country: propItem["country"],
      bedNumber: propItem["bedNumber"].toInt(),
      facilities: propItem["facilities"],
      bathNumber: propItem["bathNumber"].toInt(),
      // longitude: propItem["longitude"].toDouble(),
      // availableUnit: propItem["availableUnit"].toInt(),
      // totalUnits: propItem["totalUnits"].toInt(),
      // leverage: propItem["leverage"].toInt(),
      // minHoldingTime: propItem["minHoldingTime"].toInt(),
      // certificateOfOccupancy: propItem["certificateOfOccupancy"].toString(),
      // governorConsent: propItem["governorConsent"].toString(),
      // probateLetterOfAdministration:
      //     propItem["probateLetterOfAdministration"].toString(),
      // excisionGazette: propItem["excisionGazette"].toString(),
      tags: propItem["tags"] as List<dynamic>,
      // latitude: propItem["latitude"].toDouble(),
      // plotNumber: propItem["plotNumber"].toInt(),
      totalAmountToFund: 0.00000002,
      propertyType: propItem["propertyType"].toString(),
      duplexType: propItem["duplextype"].toString(),
      investmentType: "",
      maturitydate: 0,
      status: propItem["status"].toString(),
    );
  }

  /*
    for (var image in _images) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'images',
          image.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    // Add PDF files to the request
    for (var pdf in _pdfs) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'pdfs',
          pdf.path,
          contentType: MediaType('application', 'pdf'),
        ),
      );
    }
  */
  MediaType getMediaType(String filePath) {
    final mimeType = lookupMimeType(filePath);
    final mimeParts = mimeType?.split('/');
    if (mimeParts != null && mimeParts.length == 2) {
      return MediaType(mimeParts[0], mimeParts[1]);
    }
    return MediaType('application', 'octet-stream'); // default fallback
  }

  Future<dynamic> upload() async {
    String url = "$_serverName/api/affiliate/createlisting";
    try {
      final token = await gettoken();

      // var response = await http.post(
      //   Uri.parse(url),
      //   body: json.encode({
      //     "listingType": listingType,
      //     "description": description,
      //     "uses": uses,
      //     "why": why,
      //     "address": address,
      //     "country": country,
      //     "state": state,
      //     "housename": housename,
      //     "duplextype": duplextype,
      //     "houseFeatures": houseFeatures,
      //     "titleDocuments": titleDocuments,
      //     "toilet": toilet,
      //     "price": price,
      //     "currency": currency,
      //     "bedroom": bedroom,
      //     "floor": floor,
      //   }),
      //   headers: {"Content-Type": "application/json", "x-auth-token": token},
      // );
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      );
      request.headers['x-auth-token'] = token;

      request.fields['listingType'] = listingType;
      request.fields['description'] = description;
      request.fields['name'] = name;
      request.fields['uses'] = uses;
      request.fields['why'] = why;
      request.fields['address'] = address;
      request.fields['country'] = country;
      request.fields['state'] = state;
      request.fields['housename'] = housename;
      request.fields['duplextype'] = duplextype;
      request.fields['houseFeatures'] = json.encode(houseFeatures);
      request.fields['titleDocuments'] = json.encode(titleDocuments);
      request.fields['toilet'] = toilet;
      request.fields['price'] = price;
      request.fields['squaremeter'] = squaremeter;
      request.fields['currency'] = currency;
      request.fields['bedroom'] = bedroom;
      request.fields['floor'] = floor;

      for (var image in selectedPropertyImages) {
        final mediaType = getMediaType(image.path);

        request.files.add(
          await http.MultipartFile.fromPath(
            'images',
            image.path,
            contentType: mediaType,
          ),
        );
      }

      // Add PDF files to the request
      for (var pdf in titleDocumentFiles) {
        final mediaType = getMediaType(pdf.path!);

        request.files.add(
          await http.MultipartFile.fromPath(
            'pdfs',
            pdf.path!,
            contentType: mediaType,
          ),
        );
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully');

        //  final responseData = json.decode(response);
        var streamedResponse = await http.Response.fromStream(response);
        // Decode the JSON data from the response body
        var responseData = json.decode(streamedResponse.body);
        return responseData;
      } else {
        print(response.statusCode);
        print('Failed to upload image');
        throw ("Failed to upload image");
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Property>> fetchListings(
      {String? search, int? page, String? propertyType}) async {
    String url =
        "$_serverName/api/affiliate/listings?name=$search&page=$page&propertyType=$propertyType";
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

      return properties;
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
