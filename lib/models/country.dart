import 'package:flutter/material.dart';

class Country {
  String flag;
  String name;
  String? currency;
  String? code;

  Country(
      {@required required this.flag,
      @required required this.name,
      this.code,
      this.currency});
}
