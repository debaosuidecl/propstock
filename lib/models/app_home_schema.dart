import 'package:flutter/material.dart';

class AppHomeSchema {
  String title;
  double amount;
  String currency;
  double? percentChange;
  Color cardColor;
  double diff;
  // String? flagurl;
  // String? userid;

  AppHomeSchema({
    required this.title,
    required this.amount,
    required this.currency,
    this.percentChange,
    required this.cardColor,
    required this.diff,
  });
}
