import 'package:propstock/models/property.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/models/user_purchase.dart';

class MarketPlaceProduct {
  UserInvestment? investment;

  bool? allowCoInvest;

  String? investmentid;

  Property property;

  User? uploader;

  String? currency;

  int? units;
  String? productid;
  double? price;

  MarketPlaceProduct({
    required this.investment,
    this.investmentid,
    required this.property,
    required this.allowCoInvest,
    required this.uploader,
    required this.units,
    required this.price,
    required this.currency,
    this.productid,
  });
}
