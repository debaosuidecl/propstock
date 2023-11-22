import 'package:propstock/models/user_investment.dart';
import 'package:propstock/models/user_purchase.dart';

class AssetModel {
  UserInvestment? userInvestment;

  UserPurchase? userPurchase;

  AssetModel({
    required this.userInvestment,
    required this.userPurchase,
  });
}
