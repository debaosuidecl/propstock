import 'package:flutter/material.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/buy_property/buy_property_units_page.dart';
import 'package:propstock/screens/buy_property/co_buy.dart';
import 'package:propstock/screens/invest/buy_units_invest_page.dart';
import 'package:propstock/screens/invest/co_invest.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class BuyButtons extends StatelessWidget {
  final Property? property;
  const BuyButtons({super.key, this.property});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Color(0xff2286FE),
            ),
            onPressed: () async {
              Navigator.pushNamed(
                context,
                BuyPropertyUnitsPage.id,
                arguments: property,
              );
            },
            child: Text("Buy"),
          ),
        )),
        Expanded(
            child: Container(
          // decoration: BoxDecoration(
          //     border: Border.all(color: Color(0xff2286fe))),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: ElevatedButton(
            onPressed: () async {
              Navigator.pushNamed(
                context,
                CoBuy.id,
                arguments: property,
              ).then((res) {
                Provider.of<PropertyProvider>(context, listen: false)
                    .setCoInvestors([]);
                Provider.of<PropertyProvider>(context, listen: false)
                    .setUserShareInCoInvestment(0);
                Provider.of<PropertyProvider>(context, listen: false)
                    .setFriendAsGift(null);
              });
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              side: BorderSide(
                  color: Color(
                0xff2286fe,
              )),
              backgroundColor: Color(0xffffffff),
            ),
            child: Text(
              "Buy with friends",
              style: TextStyle(
                color: Color(0xff2286fe),
              ),
            ),
          ),
        )),
      ],
    );
  }
}
