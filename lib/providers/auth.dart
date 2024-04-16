import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:propstock/models/country.dart';
import 'package:propstock/models/friendActivity.dart';
import 'package:propstock/models/user.dart';

import '../utils/showErrorDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  // DateTime _expiryDate;
  String? _userId;

  String? _gender;
  String? _primaryLanguage;
  List<dynamic>? _preferredStates;
  String? _maritalStatus;
  String? _religion;
  bool? _hasPets;
  List<dynamic>? _personalityTypes;
  bool? _twofaenabled;
  bool? _requirestwofa;
  bool? _emailnotify;
  bool? _pushnotify;
  String? _userType;
  int? _dateOfBirth;
  String? _dailingcode;
  String? _fullName;
  String? _firstName;
  String? _lastName;
  String? _companyName;
  String? _countrystring;
  String? _companyAddress;
  String? _loginMethod;
  String? _userName;
  String? _email;
  String? _phoneFor2fa;
  String _tempPassword = "";
  String? _phone;
  String? _profilepic;
  int? _regStep;
  bool? _regComplete;
  bool? _isVerified;
  String? _pin;
  String? _loginPin;
  Country? _country = Country(flag: "", name: "");
  String? _investmentExperience = "";
  String? _incomeRange = "";
  List<dynamic> _stateList = [];
  List<String> _stateListString = [];
  List<dynamic> _dynamicStateList = [];
  List<String> _dynamicStateListString = [];
  List<dynamic>? _propertyTypes = [];
  String? _newPin;
  String _selectedState = "";
  String _selectedCurrency = "USD";
  List<dynamic>? _primaryGoals = [];
  bool? _profileSurveyShown;
  bool _isDocuVerified = false;
  // Timer _authTimer;
  final String _serverName = "https://jawfish-good-lioness.ngrok-free.app";
  // final String _serverName =
  //     Platform.isIOS ? "http://0.0.0.0:5100" : "http://10.0.2.2:5100";
  bool get isAuth {
    print(_token);
    return _token != null;
  }

  bool get isDocuVerified {
    return _isDocuVerified;
  }

  String? get investmentExperience {
    return _investmentExperience;
  }

  List<dynamic>? get propertyTypes {
    return _propertyTypes;
  }

  String? get newPin {
    return _newPin;
  }

  String? get incomeRange {
    return _incomeRange;
  }

  int? get dateOfBirth {
    return _dateOfBirth;
  }

  bool? get twofaenabled {
    return _twofaenabled;
  }

  bool? get requirestwofa {
    return _requirestwofa;
  }

  bool? get getemailnotify {
    return _emailnotify;
  }

  bool? get getpushnotify {
    return _pushnotify;
  }

  // String? _gender;
  // String? _primaryLanguage;
  // String? _maritalStatus;
  // String? _religion;
  // bool? _hasPets;
  // List<dynamic>? _personalityTypes;
  String? get phoneFor2fa {
    return _phoneFor2fa;
  }

  List<dynamic>? get preferredStates {
    return _preferredStates;
  }

  String? get gender {
    return _gender;
  }

  String? get primaryLanguage {
    return _primaryLanguage;
  }

  String? get maritalStatus {
    return _maritalStatus;
  }

  String? get religion {
    return _religion;
  }

  bool? get hasPets {
    return _hasPets;
  }

  List<dynamic>? get personalityTypes {
    return _personalityTypes;
  }

  String get selectedState {
    return _selectedState;
  }

  bool get isVerified {
    print(_isVerified);
    return _isVerified == true;
  }

  bool? get profileSurveyShown {
    return _profileSurveyShown;
  }

  String? get companyName {
    return _companyName;
  }

  List<dynamic> get stateList {
    return _stateList;
  }

  List<String> get stateListString {
    return _stateListString;
  }

  List<String> get dynamicStateListString {
    return _dynamicStateListString;
  }

  List<dynamic> get dynamicStateList {
    return _dynamicStateList;
  }

  String? get pin {
    return _pin;
  }

  String? get companyAddress {
    return _companyAddress;
  }

  Country? get country {
    return _country;
  }

  String? get countrystring {
    return _countrystring;
  }

  String? get _ {
    return _serverName;
  }

  String? get profilepic {
    return _profilepic;
  }

  bool? get regComplete {
    return _regComplete;
  }

  String? get dailingCode {
    return _dailingcode;
  }

  String? get email {
    return _email;
  }

  String? get token {
    if (_token != null) {
      return _token;
    }
    return '';
  }

  String? get userId {
    return _userId;
  }

  String get tempPassword {
    return _tempPassword;
  }

  void setNewPin(String pin) {
    _newPin = pin;
    notifyListeners();
  }

  void setTempPassword(String tp) {
    _tempPassword = tp;
    notifyListeners();
  }

  void setCountry(Country countryData) {
    _country = countryData;
    notifyListeners();
  }

  void setInvestmentExpereince(String exp) {
    _investmentExperience = exp;
    notifyListeners();
  }

  void setIncomeRange(String irange) {
    _incomeRange = irange;
    notifyListeners();
  }

  void setStateOfCountry(String state) {
    _selectedState = state;
    notifyListeners();
  }

  void setPhoneFor2fa(String phone) {
    _phoneFor2fa = phone;
    notifyListeners();
  }

  void setPrimaryGoals(List<String> goals) {
    _primaryGoals = goals;
    notifyListeners();
  }

  List<dynamic>? get primaryGoals {
    return _primaryGoals;
  }

  bool logintest(String email, String password) {
    // print(email);
    // print(password);
    return false;
  }

  String get selectedCurrency {
    return _selectedCurrency;
  }

  void setCurrency(String currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }

  void signuptest(String fullName, String email, String password) {
    print(email);
    print(password);
    print(fullName);
  }

  String? get loginPin {
    return _loginPin;
  }

  String? get firstname {
    return _firstName;
  }

  String? get fullName {
    return _fullName;
  }

  String? get lastname {
    return _lastName;
  }

  String? get phone {
    return _phone;
  }

  String? get username {
    return _userName;
  }

  int? get regstep {
    return _regStep;
  }

  Future<String?> tokenExtract() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      throw "user not authenticated";
    }
    final extractedUserData = json.decode(prefs.getString('userData') as String)
        as Map<String, String>;

    return extractedUserData["token"];
  }

  void setPin(String logpin) {
    _loginPin = logpin;
  }

  bool confirmPin(String logpin) {
    return _loginPin == logpin;
  }

  void showStateList(String stateInput) {
    if (stateInput.isEmpty) {
      _dynamicStateList = _stateList;
    } else {
      _dynamicStateList = _stateList
          .where((state) =>
              state.toString().toLowerCase().contains(stateInput.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> submitQuiz(
      List<String> selectedStates, List<String> proptypes) async {
    String url = "$_serverName/api/user/quiz/submit";
    try {
      final token = await gettoken();

      // print(token);
      final response = await http.post(Uri.parse(url),
          headers: {
            'x-auth-token': token,
            "Content-Type": "application/json",
          },
          body: json.encode({
            "investmentExperience": _investmentExperience,
            "incomeRange": _incomeRange,
            "primaryGoals": _primaryGoals,
            "preferredCountry": _country!.name,
            "preferredStates": selectedStates,
            "propertyTypes": proptypes,
          }));

      final responseData = json.decode(response.body);
      print(response.body);
      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      print("success");
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> skipQuiz() async {
    String url = "$_serverName/api/user/quiz/skip";
    try {
      final token = await gettoken();

      // print(token);
      final response = await http.post(Uri.parse(url),
          headers: {
            'x-auth-token': token,
            "Content-Type": "application/json",
          },
          body: json.encode({}));

      final responseData = json.decode(response.body);
      print(response.body);
      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      print("success");
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void resetStateList() {
    _dynamicStateList = _stateList;
    notifyListeners();
  }

  Future<dynamic> _authenticate(String email, String password, bool isSignIn,
      String? firstName, String? lastName) async {
    print(email);
    print(password);
    final url =
        isSignIn ? "$_serverName/api/auth" : '$_serverName/api/auth/register';

    try {
      print(url);
      final prefs = await SharedPreferences.getInstance();

      final sendBody = json.encode(
        {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,

          // 'returnSecureToken': true,
        },
      );
      print(sendBody);
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            'email': email.trim(),
            'password': password.trim(),
            'lastName': lastName?.trim(),
            'firstName': firstName?.trim(),
            "country": country!.name.trim(),
            // 'phone': phone?.trim(),

            // 'firebaseToken': firebaseToken

            // 'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);

      print(response.body);

      print("line 76");

      if (json.decode(response.body)['errors'] != null) {
        throw (json.decode(response.body)['errors'][0]['msg']);
      }
      print("$_userId is the user id");

      _token = responseData['token'];
      _userId = responseData['_id'];
      print(_token);
      // if (responseData["regComplete"] == false) {
      //   print("not yet complete");
      // }

      // _regComplete = responseData["regComplete"] as bool;

      // _expiryDate = DateTime.now().add(
      //   Duration(
      //     seconds: int.parse(
      //       responseData['expiresIn'],
      //     ),
      //   ),
      // );
      // _autoLogout();

      notifyListeners();

      // final prefsb = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          // 'expiryDate': _expiryDate.toIso8601String(),
        },
      );

      final userDataForPin = json.encode(
          {"firstName": responseData["firstName"], "email": email?.trim()});
      prefs.setString('userData', userData);
      prefs.setString('userDataForPin', userDataForPin);
      // await tryAutoLogin();

      return responseData;
    } catch (error) {
      // print(error);
      // print("an error");
      notifyListeners();
      throw error;
    }
  }

  Future<void> signup(
      String firstName, String lastName, String email, String password) async {
    return _authenticate(email, password, false, firstName, lastName);
  }

  Future<void> signin(
      String firstName, String lastName, String email, String password) async {
    return _authenticate(email, password, true, firstName, lastName);
  }

  Future<void> getIP() async {
    final url = "https://ip.nf/me.json";
    final response = await http.get(Uri.parse(url));
    final responseData = json.decode(response.body);

    print(responseData["ip"]["country_code"]);

    final postresponse = await http.post(
      Uri.parse("$_serverName/api/auth/get_ip"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        {
          "country_code": responseData["ip"]["country_code"]
          // 'returnSecureToken': true,
        },
      ),
    );
    final dailingCodeData = json.decode(postresponse.body);
    print(dailingCodeData);
    _dailingcode = dailingCodeData['country_code'];
    // notifyListeners();
  }

  Future<void> logonlinetime() async {
    print("running every 60 seconds");
    await pingserver();
  }

  Future<void> pingserver() async {
    String url = "$_serverName/api/user/pingserver";
    try {
      final token = await gettoken();

      // print(token);
      final response =
          await http.get(Uri.parse(url), headers: {'token': token});
      final responseData = json.decode(response.body);
    } catch (e) {
      print(e);
    }
  }

  Future<void> changePassword(String password) async {
    String url = "$_serverName/api/user/change-password";
    try {
      final token = await gettoken();

      // print(token);
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json", 'x-auth-token': token},
          body: json.encode({"password": password}));

      final responseData = json.decode(response.body);
      print(response.body);
      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> enable2fa(String phone) async {
    String url = "$_serverName/api/user/enable2fa";
    try {
      final token = await gettoken();

      // print(token);
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json", 'x-auth-token': token},
          body: json.encode({"phonenumber": phone}));

      _phoneFor2fa = phone;
      final responseData = json.decode(response.body);
      print(response.body);
      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> verify2fa(String code) async {
    String url = "$_serverName/api/user/verify2fa";
    try {
      final token = await gettoken();

      // print(token);
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json", 'x-auth-token': token},
          body: json.encode({"code": code, "phonenumber": _phoneFor2fa}));

      // _phoneFor2fa = phone;
      final responseData = json.decode(response.body);
      _twofaenabled = true;
      print(response.body);
      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    String url = "$_serverName/api/user/deleteaccount";
    try {
      final token = await gettoken();

      // print(token);
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json", 'x-auth-token': token},
          body: json.encode({}));

      // _phoneFor2fa = phone;
      final responseData = json.decode(response.body);
      _twofaenabled = true;
      print(response.body);
      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    String url = "$_serverName/api/user/imageupload";

    try {
      print(imageFile);
      final token = await gettoken();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      );
      request.headers['x-auth-token'] = token;

      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Image uploaded successfully');

        //  final responseData = json.decode(response);
        var streamedResponse = await http.Response.fromStream(response);

        // Decode the JSON data from the response body
        var responseData = json.decode(streamedResponse.body);

        _profilepic = responseData["data"]["avatar"];

        print(_profilepic);

        notifyListeners();

        return profilepic;
      } else {
        print('Failed to upload image');
        throw ("Failed to upload image");
      }
    } catch (e) {
      print(e);

      rethrow;
    }
  }

  Future<void> updateAccount(
      {String? gender,
      String? investmentExperience,
      String? incomeRange,
      String? primaryLanguage,
      List<dynamic>? preferredStates,
      List<dynamic>? primaryGoals,
      String? maritalStatus,
      String? religion,
      bool? hasPets,
      String? email,
      String? firstName,
      String? lastName,
      String? phone,
      List<dynamic>? personalityTypes,
      List<String>? propertyTypes,
      int? dateOfBirth}) async {
    String url = "$_serverName/api/user/updateaccount";
    try {
      final token = await gettoken();

      // print(token);
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json", 'x-auth-token': token},
          body: json.encode({
            "gender": gender,
            "primaryLanguage": primaryLanguage,
            "maritalStatus": maritalStatus,
            "preferredStates": preferredStates,
            "religion": religion,
            "hasPets": hasPets,
            "email": email,
            "firstName": firstName,
            "investmentExperience": investmentExperience,
            "incomeRange": incomeRange,
            "primaryGoals": primaryGoals,
            "lastName": lastName,
            "phone": phone,
            "personalityTypes": personalityTypes,
            "propertyTypes": propertyTypes,
            "dateOfBirth": dateOfBirth,
          }));

      // _phoneFor2fa = phone;
      final responseData = json.decode(response.body)["data"];
      // print(responseData);

      _email = responseData['email'].toString();
      _firstName = responseData["firstName"].toString();
      _lastName = responseData["lastName"].toString();
      // _token = extractedUserData['token'] as String;
      _userId = responseData['_id'] as String;
      // _pin = responseData['pin'] as String?;
      // _isVerified = responseData['verified'] as bool;
      // _isVerified = responseData['verified'] as bool;
      _profilepic = responseData["avatar"] as String?;
      _phoneFor2fa = responseData["phone"] as String?;
      // _twofaenabled = responseData["twofaenabled"] as bool?;
      // _requirestwofa = responseData["requirestwofa"] as bool?;
      // _emailnotify = responseData["emailnotify"] as bool?;
      // _pushnotify = responseData["pushnotify"] as bool?;
      // _countrystring = responseData["country"] as String?;
      _gender = responseData["gender"] as String?;
      _primaryLanguage = responseData["primaryLanguage"] as String?;
      _investmentExperience = responseData["investmentExperience"] as String?;
      _incomeRange = responseData["incomeRange"] as String?;
      _maritalStatus = responseData["maritalStatus"] as String?;
      _religion = responseData["religion"] as String?;
      _hasPets = responseData["hasPets"] as bool?;
      _personalityTypes = responseData["personalityTypes"] as List<dynamic>?;
      _primaryGoals = responseData["primaryGoals"] as List<dynamic>?;
      _preferredStates = responseData["preferredStates"] as List<dynamic>?;
      _propertyTypes = responseData["propertyTypes"] as List<dynamic>?;
      _dateOfBirth = responseData["dateOfBirth"] as int?;

      // _isDocuVerified = responseData["isdocuverified"] as bool;
      // _profileSurveyShown = responseData["profileSurveyShown"] as bool?;
      notifyListeners();
      // _twofaenabled = true;
      print(response.body);
      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> disableTwofaphone() async {
    String url = "$_serverName/api/user/disabletwofaphone";
    try {
      final token = await gettoken();

      // print(token);
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json", 'x-auth-token': token},
          body: json.encode({}));

      // _phoneFor2fa = phone;
      final responseData = json.decode(response.body);

      print(response.body);
      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      _twofaenabled = false;

      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> setUserVerificationStatus(String code) async {
    String url = "$_serverName/api/user/verify-status";
    try {
      final token = await gettoken();

      // print(token);
      final response = await http.post(Uri.parse(url),
          headers: {'token': token}, body: json.encode({"code": code}));

      final responseData = json.decode(response.body);
      print(response.body);
      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getStatesByCountry(String country) async {
    String url = "$_serverName/api/user/states/$country";
    try {
      final token = await gettoken();

      // print(token);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'x-auth-token': token,
          "Content-Type": "application/json",
        },
      );

      final responseData = json.decode(response.body);
      print(response.body);
      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }

      final states = responseData["states"] as List<dynamic>;

      _stateList = states;
      _dynamicStateList = states;

      for (int i = 0; i < states.length; i++) {
        _stateListString.add(states[i].toString());
        _dynamicStateListString.add(states[i].toString());
      }
      // _stateListString = responseData["states"] as List<String>;
      // _dynamicStateListString = responseData["states"] as List<String>;
      _selectedState = "";
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, true, "", "");
  }

  Future<void> signInWithPin(String pin, String email) async {
    String url = "$_serverName/api/auth/signinwithpin";
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode({
            "pin": pin,
            "email": email,
          }));

      final responseData = json.decode(response.body);
      print(response.body);
      print("line 76");

      if (json.decode(response.body)['errors'] != null) {
        throw (json.decode(response.body)['errors'][0]['msg']);
      }

      print("success");
      print("$_userId is the user id");

      _token = responseData['token'];
      _userId = responseData['_id'];
      print(_token);

      notifyListeners();

      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          // 'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', userData);
      prefs.setString(
          'userDataForPin',
          json.encode(
            {
              'firstName': responseData["firstName"],
              'email': email,
              // 'expiryDate': _expiryDate.toIso8601String(),
            },
          ));
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> sendVerificationLink(String email) async {
    String url = "$_serverName/api/auth/forgot-password";
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode({
            // "pin": pin,
            "email": email,
          }));

      final responseData = json.decode(response.body);
      print(response.body);
      print("line 545");

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      print("success");
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

  Future<bool> checkIfOnboarded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('isOnboarded')) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
    // return token;
  }

  Future<void> setIsOnBoarded() async {
    final prefs = await SharedPreferences.getInstance();
    const onBoardData = 'onboard';
    prefs.setString('isOnboarded', onBoardData);
  }

  Future<bool> tryAutoLogin({bool? removeWaitTime}) async {
    final prefs = await SharedPreferences.getInstance();

    // return true;
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData = json.decode(prefs.getString('userData') as String)
        as Map<String, dynamic>;

    // final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    // if (expiryDate.isBefore(DateTime.now())) {
    //   return false;
    // }

    print(prefs);
    print(_token);
    print(extractedUserData);
    print(
        "THIS IS SUPPOSED TO BE THE USERID 399 ${extractedUserData['userId']}");
    // return true;
    try {
      final postresponse = await http.get(
        Uri.parse("$_serverName/api/auth/auto"),
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": extractedUserData['token'] as String,
        },
      );

      if (json.decode(postresponse.body)['message'] == "Auth Error" ||
          json.decode(postresponse.body)['message'] == "Invalid Token") {
        await Future.delayed(Duration(milliseconds: 2000));

        throw ("an Authentication Error occured");
      }

      print(371);
      print(
        json.decode(postresponse.body),
      );

      print("here");
      Map<String, dynamic> responseData = json.decode(postresponse.body);
      // _regComplete = responseData['regComplete'];
      _email = responseData['email'];
      _firstName = responseData["firstName"];
      _lastName = responseData["lastName"];
      _token = extractedUserData['token'] as String;
      _userId = responseData['_id'] as String;
      _pin = responseData['pin'] as String?;
      _isVerified = responseData['verified'] as bool;
      _isVerified = responseData['verified'] as bool;
      _profilepic = responseData["avatar"] as String?;
      _phoneFor2fa = responseData["phone"] as String?;
      _twofaenabled = responseData["twofaenabled"] as bool?;
      _requirestwofa = responseData["requirestwofa"] as bool?;
      _emailnotify = responseData["emailnotify"] as bool?;
      _pushnotify = responseData["pushnotify"] as bool?;
      _countrystring = responseData["country"] as String?;
      _gender = responseData["gender"] as String?;
      _investmentExperience = responseData["investmentExperience"] as String?;
      _incomeRange = responseData["incomeRange"] as String?;
      _primaryLanguage = responseData["primaryLanguage"] as String?;
      _preferredStates = responseData["preferredStates"] as List<dynamic>?;
      _primaryGoals = responseData["primaryGoals"] as List<dynamic>?;
      _maritalStatus = responseData["maritalStatus"] as String?;
      _religion = responseData["religion"] as String?;
      _hasPets = responseData["hasPets"] as bool?;
      _personalityTypes = responseData["personalityTypes"] as List<dynamic>?;
      _propertyTypes = responseData["propertyTypes"] as List<dynamic>?;
      _dateOfBirth = responseData["dateOfBirth"] as int?;

      _isDocuVerified = responseData["isdocuverified"] as bool;
      _profileSurveyShown = responseData["profileSurveyShown"] as bool?;
      // _phone = responseData["phone"] as String;
      print('$_userId is the user id');
      // _userId = extractedUserData['userId'] as String;

      print("387");

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          // 'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
      if (removeWaitTime == false || removeWaitTime == null) {
        await Future.delayed(Duration(milliseconds: 2000));
      }

      notifyListeners();
    } catch (e) {
      print("an error occured");
      print(e);
      throw e;
    }

    // _expiryDate = expiryDate;
    notifyListeners();
    // _autoLogout();
    return true;
  }

  Future<void> logout() async {
    final token = await gettoken();

    _token = null;
    _userId = null;
    //  _userId =;
    _userType = null;
    _dailingcode = null;
    _firstName = null;
    _lastName = null;
    _userName = null;
    _fullName = null;
    _email = null;
    _phone = null;
    _regStep = null;
    _regComplete = null;
    // _expiryDate = null;
    // if (_authTimer != null) {
    //   _authTimer.cancel();
    //   _authTimer = null;
    // }
    // if (_loginMethod == "facebook") {
    //   facebookLogin.logOut();
    // }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');

    String url = "$_serverName/api/user/logout";
    try {
      // print(token);
      final response = await http.post(Uri.parse(url),
          headers: {'x-auth-token': token, "Content-Type": "application/json"},
          body: json.encode({}));

      final responseData = json.decode(response.body);
      print(response.body);
      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
    } catch (e) {
      throw (e);
    }
    // prefs.clear();
  }

  Future<void> verifyUser(String code) async {
    String url = "$_serverName/api/auth/verify";
    try {
      final token = await gettoken();

      // print(token);
      final response = await http.post(Uri.parse(url),
          headers: {'x-auth-token': token, "Content-Type": "application/json"},
          body: json.encode({"code": code}));

      final responseData = json.decode(response.body);
      print(response.body);
      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<void> pushnotify(bool status) async {
    String url = "$_serverName/api/user/pushnotify";
    try {
      final token = await gettoken();

      // print(token);
      final response = await http.post(Uri.parse(url),
          headers: {'x-auth-token': token, "Content-Type": "application/json"},
          body: json.encode({}));

      final responseData = json.decode(response.body);

      print(response.body);
      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }

      _pushnotify = status;
    } catch (e) {
      throw (e);
    }
  }

  Future<void> emailnotify(bool status) async {
    String url = "$_serverName/api/user/emailnotify";
    try {
      final token = await gettoken();

      // print(token);
      final response = await http.post(Uri.parse(url),
          headers: {'x-auth-token': token, "Content-Type": "application/json"},
          body: json.encode({}));

      final responseData = json.decode(response.body);

      print(response.body);
      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }

      _emailnotify = status;
    } catch (e) {
      throw (e);
    }
  }

  Future<dynamic> getUserFriends(int page, int limit, {String? query}) async {
    String url =
        "$_serverName/api/friend?page=$page&limit=$limit&friend=$query";

    try {
      final token = await gettoken();

      // print(token);
      final response = await http.get(Uri.parse(url),
          headers: {'x-auth-token': token, "Content-Type": "application/json"});

      final responseData = json.decode(response.body)['data'] as List<dynamic>;
      print(response.body);
      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      List<User> _listOfFriends = [];

      for (int i = 0; i < responseData.length; i++) {
        dynamic friend = responseData[i]["friend"];

        User user = User(
          firstName: friend['firstName'].toString(),
          lastName: friend['lastName'].toString(),
          id: friend["_id"].toString(),
          userName: friend['email'].toString(),
          avatar: friend["avatar"].toString(),
        );

        _listOfFriends.add(user);
      }

      return _listOfFriends;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> unFriend(User friend) async {
    String url = "$_serverName/api/friend/unfriend/${friend.id}";

    try {
      final token = await gettoken();

      // print(token);
      final response = await http.get(Uri.parse(url),
          headers: {'x-auth-token': token, "Content-Type": "application/json"});

      final responseData = json.decode(response.body)['data'] as dynamic;
      print(response.body);
      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }

      return responseData;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> addFriend(User friend) async {
    String url = "$_serverName/api/friend/add/${friend.id}";

    try {
      final token = await gettoken();

      // print(token);
      final response = await http.get(Uri.parse(url),
          headers: {'x-auth-token': token, "Content-Type": "application/json"});

      final responseData = json.decode(response.body)['data'] as dynamic;
      print(response.body);
      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }

      return responseData;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> isUserFriend(User friend) async {
    String url = "$_serverName/api/friend/isfriend/${friend.id}";

    try {
      final token = await gettoken();

      // print(token);
      final response = await http.get(Uri.parse(url),
          headers: {'x-auth-token': token, "Content-Type": "application/json"});

      final responseData = json.decode(response.body)['data'] as dynamic;
      print(response.body);
      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }

      return responseData;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> searchFriendActivity(User friend, int page, int limit) async {
    String url =
        "$_serverName/api/friend/activity?page=$page&limit=$limit&friend=${friend.id}";

    try {
      final token = await gettoken();

      // print(token);
      final response = await http.get(Uri.parse(url),
          headers: {'x-auth-token': token, "Content-Type": "application/json"});

      final responseData = json.decode(response.body)['data'] as List<dynamic>;
      print(response.body);
      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      List<FriendActivity> listOfActivity = [];

      for (int i = 0; i < responseData.length; i++) {
        dynamic activity = responseData[i];

        FriendActivity fa = FriendActivity(
            activity_type: activity["activity_type"],
            giftedBy: activity["giftedBy"],
            giftedTo: activity['giftedTo'],
            date: activity['createdAt']);

        // User user = User(
        //   firstName: friend['firstName'].toString(),
        //   lastName: friend['lastName'].toString(),
        //   id: friend["_id"].toString(),
        //   userName: friend['email'].toString(),
        //   avatar: friend["avatar"].toString(),
        // );

        listOfActivity.add(fa);
      }

      return listOfActivity;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> resendCode() async {
    String url = "$_serverName/api/auth/resend-code";
    try {
      final token = await gettoken();

      // print(token);
      final response = await http.post(Uri.parse(url),
          headers: {'x-auth-token': token, "Content-Type": "application/json"},
          body: json.encode({}));

      // final responseData = json.decode(response.body);
      print(response.body);
      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<void> setPinForUser(String pinfinal) async {
    String url = "$_serverName/api/auth/save-user-pin";
    try {
      final token = await gettoken();
      final response = await http.post(Uri.parse(url),
          headers: {'x-auth-token': token, "Content-Type": "application/json"},
          body: json.encode({"pin": pinfinal}));
      print(response.body);
      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
    } catch (e) {
      throw (e);
    }
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

  Future<http.Response> requestmodule(
    String method,
    String url, {
    String? token,
    String? body,
  }) async {
    http.Response postresponse;
    if (method == "get") {
      postresponse = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "token": token != null ? token : "",
        },
      );
    } else {
      // post request.
      postresponse = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "token": token != null ? token : "",
          },
          body: body);
    }

    return postresponse;
  }
}
