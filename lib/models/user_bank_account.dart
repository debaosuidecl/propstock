import 'package:propstock/models/bank.dart';

class UserBankAccount {
  String accountNumber;
  String accountName;
  String bankid;
  Bank bank;
  String id;
  UserBankAccount({
    required this.accountNumber,
    required this.accountName,
    required this.bankid,
    required this.bank,
    required this.id,
  });
}
