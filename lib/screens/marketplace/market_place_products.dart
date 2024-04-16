import 'package:flutter/material.dart';
import 'package:propstock/models/market_place.dart';
import 'package:propstock/widgets/market_product_card.dart';

class MarketPlaceProducts extends StatefulWidget {
  final List<MarketPlaceProduct> marketplist;
  const MarketPlaceProducts({super.key, required this.marketplist});

  @override
  State<MarketPlaceProducts> createState() => _MarketPlaceProductsState();
}

class _MarketPlaceProductsState extends State<MarketPlaceProducts> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.marketplist.length,
        itemBuilder: (BuildContext ctx, int index) {
          return MarketProductCard(
            property: widget.marketplist[index].property,
            marketplace: widget.marketplist[index],
          );
        });
  }
}
