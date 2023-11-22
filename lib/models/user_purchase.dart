import 'package:propstock/models/property.dart';
import 'package:propstock/models/user.dart';

class UserPurchase {
  Property property;
  String id;
  bool? isCoBuyer;
  bool? isInitiatorOfCoBuying;
  double coBuyAmount;
  String propertyType;
  List<User> coBuyers;
  int quantity;
  double pricePerUnitAtPurchase;
  // double amountWithdrawn;

  UserPurchase({
    required this.property,
    this.isCoBuyer,
    this.isInitiatorOfCoBuying,
    required this.propertyType,
    required this.coBuyers,
    required this.coBuyAmount,
    required this.quantity,
    required this.pricePerUnitAtPurchase,
    required this.id,
    // required this.amountWithdrawn,g
  });
}
