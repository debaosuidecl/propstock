import 'package:flutter/material.dart';

class MarketPlace extends StatefulWidget {
  static const id = "marketplace";
  const MarketPlace({super.key});

  @override
  State<MarketPlace> createState() => _MarketPlaceState();
}

class _MarketPlaceState extends State<MarketPlace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Market Place")),
    );
  }
}
