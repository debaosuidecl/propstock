import 'dart:convert';
import 'dart:async';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:propstock/models/bank.dart';
import 'package:propstock/models/card.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/models/user_bank_account.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/models/wallet.dart';
import 'package:propstock/services/crypto.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentProvider with ChangeNotifier {
  final String _serverName = "https://jawfish-good-lioness.ngrok-free.app";
  // final String _serverName =
  //     Platform.isIOS ? "http://0.0.0.0:5100" : "http://10.0.2.2:5100";

  Wallet? _wallet;
  List<CardModel> _cards = [];
  String _cardAuthCode = "";
  Property? _propertyToPay;
  double _topuppayment = 0;
  double _withdrawpayment = 0;
  int _quantityOfProperty = 0;
  Bank? _selectedBank;
  CardModel? _selectedCard;

  double get topuppayment {
    return _topuppayment;
  }

  double get withdrawpayment {
    return _withdrawpayment;
  }

  Bank? get selectedBank {
    return _selectedBank;
  }

  CardModel? get selectedCard {
    return _selectedCard;
  }

  int get quantityOfProperty {
    return _quantityOfProperty;
  }

  String get cardAuthCode {
    return _cardAuthCode;
  }

  Wallet? get wallet {
    return _wallet;
  }

  Property? get propertyToPay {
    return _propertyToPay;
  }

  List<CardModel> get userCards {
    return _cards;
  }

  String paymentOption = "";

  void setTopUpPayment(double tp) {
    _topuppayment = tp;
  }

  void setWithdrawPayment(double wp) {
    _withdrawpayment = wp;
  }

  void setCardAuthCode(String code) {
    print("setting auth code: $code");
    _cardAuthCode = code;
    notifyListeners();
  }

  void setSelectedBank(Bank? bank) {
    _selectedBank = bank;
    notifyListeners();
  }

  void setSelectedCard(CardModel? card) {
    _selectedCard = card;
    notifyListeners();
  }

  void setPropertyToPay(Property? prop, int number) {
    _quantityOfProperty = number;
    _propertyToPay = prop;
    notifyListeners();
  }

  void setPaymentOption(String po) {
    paymentOption = po;
  }

  Future<dynamic> initializePaystackPayment(int amount, {bool? verify}) async {
    String url = "$_serverName/api/payments/paystack/topup/initialize";
    try {
      final token = await gettoken();
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "amount": amount / 100,
          "verify": verify,
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
      print(e);
      rethrow;
    }
  }

  Future<dynamic> saveCustomerCard(PaymentCard card, bool isDefault) async {
    String url = "$_serverName/api/payments/paystack/card/create";
    try {
      final token = await gettoken();
      //  final secretKey = Secre/.fromUtf8('your_secret_key');

      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "number": CryptoService().encrypt("${card.number}"),
          "cvv": CryptoService().encrypt("${card.cvc}"),
          "expiry_month": CryptoService().encrypt("${card.expiryMonth}"),
          "expiry_year": CryptoService().encrypt("${card.expiryYear}"),
          "type": CryptoService().encrypt("${card.type}"),
          "isDefault": isDefault,
        }),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"] as String;

      print(responseData);
      return responseData;
      // notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> setCardAsDefault(CardModel card) async {
    String url = "$_serverName/api/payments/cards/setcardasdefault/${card.id}";
    try {
      final token = await gettoken();
      //  final secretKey = Secre/.fromUtf8('your_secret_key');

      var response = await http.post(
        Uri.parse(url),
        body: json.encode({}),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"] as String;

      print(responseData);
      return responseData;
      // notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> chargeAlreadyKnownCard(
      CardModel? card, int amount, pin) async {
    String url =
        "$_serverName/api/payments/paystack/chargealreadyexistingcard/${card!.id}";
    try {
      final token = await gettoken();
      //  final secretKey = Secre/.fromUtf8('your_secret_key');

      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "amount": amount,
          "pin": pin,
        }),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"];

      print(responseData);
      return responseData;
      // notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> investInProperty(
      Property? property,
      int quantity,
      String pin,
      User? friendAsGift,
      List<User> coInvestors,
      double userShareInCoInvestment,
      String type) async {
    String url =
        "$_serverName/api/property/$paymentOption/$type/${property!.id}";
    try {
      final token = await gettoken();
      //  final secretKey = Secre/.fromUtf8('your_secret_key');

      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          // "authCode": CryptoService().encrypt(authCode),
          "authCode": _cardAuthCode,
          "quantity": quantity,
          "pin": pin,
          "friend_to_gift_username": friendAsGift?.userName,

          "coInvestors": coInvestors.map((e) => e.id).toList(),
          "coInvestAmount": userShareInCoInvestment
          // "property_id":
        }),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"];

      print(responseData);
      return responseData;
      // notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> buyProperty(
    Property? property,
    int quantity,
    String pin,
    User? friendAsGift,
  ) async {
    String url = "$_serverName/api/property/$paymentOption/buy/${property!.id}";
    try {
      final token = await gettoken();
      //  final secretKey = Secre/.fromUtf8('your_secret_key');

      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          // "authCode": CryptoService().encrypt(authCode),
          "authCode": _cardAuthCode,
          "quantity": quantity,
          "pin": pin,
          "friend_to_gift_username": friendAsGift?.userName,
          // "property_id":
        }),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"];

      print(responseData);
      return responseData;
      // notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> fetchCustomerCard() async {
    String url = "$_serverName/api/payments/cards";
    try {
      final token = await gettoken();
      //  final secretKey = Secre/.fromUtf8('your_secret_key');

      var response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"] as List<dynamic>;

      List<CardModel> cards = [];

      for (int i = 0; i < responseData.length; i++) {
        dynamic cardItem = responseData[i];

        CardModel card = CardModel(
          last4digits: cardItem["last_4_digits"].toString(),
          token: cardItem['token'].toString(),
          bank: cardItem['bank'].toString(),
          type: cardItem['type'].toString(),
          isDefault: cardItem['isDefault'] as bool,
          id: cardItem["_id"].toString(),
        );

        cards.add(card);
      }
      _cards = cards;
      print(responseData);
      notifyListeners();
      return cards;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> fetchUserWallet() async {
    String url = "$_serverName/api/payments/wallet";
    try {
      final token = await gettoken();
      //  final secretKey = Secre/.fromUtf8('your_secret_key');

      var response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"] as dynamic;

      print(responseData);
      _wallet = Wallet(
          amount: responseData['amount'].toDouble(),
          currency: responseData["currency"].toString());

      // _cards = cards;
      notifyListeners();
      return _wallet;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> fetchBanks() async {
    String url = "$_serverName/api/payments/banks";
    try {
      final token = await gettoken();
      //  final secretKey = Secre/.fromUtf8('your_secret_key');

      var response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"] as List<dynamic>;

      print(responseData);
      List<Bank> bankList = [];
      for (int i = 0; i < responseData.length; i++) {
        dynamic bankitem = responseData[i];

        Bank bank = Bank(
          code: bankitem["code"].toString(),
          name: bankitem['name'].toString(),
        );
        bankList.add(bank);
      }
      return bankList;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> fetchAccounts() async {
    String url = "$_serverName/api/payments/bankaccounts";
    try {
      final token = await gettoken();
      //  final secretKey = Secre/.fromUtf8('your_secret_key');

      var response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"] as List<dynamic>;

      print(responseData);
      List<UserBankAccount> bankAccountList = [];
      for (int i = 0; i < responseData.length; i++) {
        dynamic accountItem = responseData[i];
        Bank bank = Bank(
          code: accountItem["bank_code"].toString(),
          name: accountItem['bank_name'].toString(),
        );
        UserBankAccount bankAccount = UserBankAccount(
            id: accountItem["_id"].toString(),
            accountNumber: accountItem["account_number"].toString(),
            accountName: accountItem["name"].toString(),
            bankid: accountItem["bank_code"].toString(),
            bank: bank);

        bankAccountList.add(bankAccount);
      }
      return bankAccountList;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> verifyBankAccount(Bank bank, String accountNumber) async {
    String url = "$_serverName/api/payments/verify-account";
    try {
      final token = await gettoken();
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "code": bank.code,
          "accountNumber": accountNumber,
        }),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"] as dynamic;

      print(responseData);
      UserBankAccount accountDetails = UserBankAccount(
          accountNumber: responseData["account_number"].toString(),
          accountName: responseData["account_name"].toString(),
          bankid: responseData["bank_id"].toString(),
          bank: bank,
          id: "123456789");

      return accountDetails;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> saveUserBankAccount(UserBankAccount bankAccount) async {
    String url = "$_serverName/api/payments/paystack/save-account";
    try {
      final token = await gettoken();
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "bank_code": bankAccount.bank.code,
          "account_number": bankAccount.accountNumber,
          "name": bankAccount.accountName,
          "type": "nuban",
          "bank_name": bankAccount.bank.name,
          // "currency": "NGN"
        }),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"] as dynamic;
      return responseData;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> setWithdrawalRequestOnInvestment(
      String pin,
      UserBankAccount? bankAccount,
      double amountToWithdraw,
      UserInvestment? userInvestment) async {
    String url =
        "$_serverName/api/payments/paystack/withdrawal/bankaccount/${bankAccount!.id}/${userInvestment!.id}";
    try {
      final token = await gettoken();
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          // "account_number": bankAccount.accountNumber,
          // "name": bankAccount.accountName,
          "withdrawal_type": "bank_transfer",
          "amountToWithdraw": amountToWithdraw,
          "pin": pin,
          // "bank_name": bankAccount.bank.name,
          // "currency": "NGN"
        }),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"] as dynamic;
      return responseData;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> withdrawFromWalletToBankAccount(
      String pin, UserBankAccount? bankAccount, double amountToWithdraw) async {
    String url =
        "$_serverName/api/payments/paystack/withdrawal/wallet/bankaccount/${bankAccount!.id}";
    try {
      final token = await gettoken();
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          // "account_number": bankAccount.accountNumber,
          // "name": bankAccount.accountName,
          "withdrawal_type": "bank_transfer",
          "amountToWithdraw": amountToWithdraw,
          "pin": pin,
          // "bank_name": bankAccount.bank.name,
          // "currency": "NGN"
        }),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"] as dynamic;
      return responseData;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> setInvestmentWithdrawalRequestToWallet(
      double amountToWithdraw, UserInvestment? userInvestment) async {
    String url =
        "$_serverName/api/payments/withdrawal/wallet/${userInvestment!.id}";
    try {
      final token = await gettoken();
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          // "account_number": bankAccount.accountNumber,
          // "name": bankAccount.accountName,
          "amountToWithdraw": amountToWithdraw,
          "withdrawal_type": "wallet_payment",

          // "bank_name": bankAccount.bank.name,
          // "currency": "NGN"
        }),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"] as dynamic;
      return responseData;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> topUpWithUSSD(String code, double topup) async {
    String url = "$_serverName/api/payments/paystack/topup/ussd";
    try {
      final token = await gettoken();
      //  final secretKey = Secre/.fromUtf8('your_secret_key');

      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "code": code,
          "amount": topup,

          // "property_id":
        }),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (hasBadRequestError(response.body)) {
        throw (json.decode(response.body)["message"]);
      }
      final responseData = json.decode(response.body)["data"];

      print(responseData);
      return responseData;
      // notifyListeners();
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
