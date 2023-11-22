class Wallet {
  double amount;
  String currency;
  String? flagurl;
  String? userid;

  Wallet({
    required this.amount,
    required this.currency,
    this.flagurl,
    this.userid,
  });
}
