import 'package:flutter/material.dart';

class Country {
  String flag;
  String name;
  String? currency;

  Country(
      {@required required this.flag,
      @required required this.name,
      this.currency});
}
