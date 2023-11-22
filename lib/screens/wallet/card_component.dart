import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:propstock/models/card.dart';
import 'package:propstock/models/colors.dart';

class CardComponent extends StatelessWidget {
  final CardModel card; // Replace with your base64 image string

  const CardComponent({super.key, required this.card});

  String cardLogoDetermine(type) {
    if (type == CardType.visa) {
      return CardModel.visaImage;
    }
    if (type == CardType.masterCard) {
      return CardModel.masterImage;
    }

    return CardModel.defaultCard;
  }

  Color cardColorDetermine(type) {
    if (type == CardType.visa) {
      return CardModel.visaColor;
    }
    if (type == CardType.masterCard) {
      return CardModel.normalColor;
    }

    return CardModel.normalColor;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              color: cardColorDetermine(card.type), shape: BoxShape.circle),
          child: Image.memory(
            Uint8List.fromList(base64Decode(cardLogoDetermine(card.type))),
            // fit: BoxFit.fill, // You can customize the Box
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              card.bank.isEmpty ? card.type : card.bank,
              style: TextStyle(
                color: MyColors.neutralblack,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
              ),
            ),
            SizedBox(
              height: 7,
            ),
            Text(
              "**** **** **** ${card.last4digits}",
              style: TextStyle(
                color: MyColors.neutral,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: "Inter",
              ),
            )
          ],
        )
      ],
    );
  }
}
