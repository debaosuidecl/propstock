import 'package:flutter/material.dart';

class AssetDistribution {
  double landCount;
  double rentalCount;
  double commercialCount;
  double residentialCount;
  double sum;

  AssetDistribution(
      {required this.landCount,
      required this.rentalCount,
      required this.commercialCount,
      required this.residentialCount,
      required this.sum});
}
