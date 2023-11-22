class UserWalletTransaction {
  String title;
  String currency;
  double amount;
  int createdAt;

  UserWalletTransaction(
      {required this.title,
      required this.currency,
      required this.amount,
      required this.createdAt});
}
