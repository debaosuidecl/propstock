import 'package:propstock/models/property.dart';
import 'package:propstock/models/user.dart';

class UserInvestment {
  Property property;
  String id;
  bool? isCoInvestor;
  bool? isInitiatorOfCoInvestment;
  double coInvestAmount;
  String propertyType;
  List<User> coInvestors;
  int maturityDate;
  User? investor;
  int quantity;
  double pricePerUnitAtPurchase;
  double amountWithdrawn;
  int? createdAt;
  bool? complete;
  UserInvestment({
    required this.property,
    this.complete,
    this.isCoInvestor,
    this.investor,
    this.isInitiatorOfCoInvestment,
    required this.propertyType,
    required this.coInvestors,
    required this.coInvestAmount,
    required this.quantity,
    required this.maturityDate,
    required this.pricePerUnitAtPurchase,
    required this.id,
    required this.amountWithdrawn,
    this.createdAt,
  });
}
