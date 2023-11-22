import 'package:flutter/material.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/invest/buy_units_invest_page.dart';
import 'package:propstock/screens/invest/co_invest.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class InvestButtons extends StatelessWidget {
  final Property? property;
  const InvestButtons({super.key, this.property});

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
              final Property? propSingle =
                  await Provider.of<PropertyProvider>(context, listen: false)
                      .fetchUserInvestmentByPropertyId(property!.id.toString());

              if (propSingle == null) {
                Navigator.pushNamed(
                  context,
                  BuyUnitsInvestPage.id,
                  arguments: property,
                ).then((res) {
                  Provider.of<PropertyProvider>(context, listen: false)
                      .setCoInvestors([]);
                  Provider.of<PropertyProvider>(context, listen: false)
                      .setUserShareInCoInvestment(0);
                  Provider.of<PropertyProvider>(context, listen: false)
                      .setFriendAsGift(null);
                });
              } else {
                if (int.parse("${propSingle.availableUnit}") <= 0) {
                  showErrorDialog(
                      "This property has no units available", context);
                } else {
                  Navigator.pushNamed(
                    context,
                    BuyUnitsInvestPage.id,
                    arguments: property,
                  ).then((res) {
                    Provider.of<PropertyProvider>(context, listen: false)
                        .setCoInvestors([]);
                    Provider.of<PropertyProvider>(context, listen: false)
                        .setUserShareInCoInvestment(0);
                    Provider.of<PropertyProvider>(context, listen: false)
                        .setFriendAsGift(null);
                  });
                }
              }
            },
            child: Text("Invest"),
          ),
        )),
        Expanded(
            child: Container(
          // decoration: BoxDecoration(
          //     border: Border.all(color: Color(0xff2286fe))),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: ElevatedButton(
            onPressed: () async {
              final Property? propSingle =
                  await Provider.of<PropertyProvider>(context, listen: false)
                      .fetchUserInvestmentByPropertyId(property!.id);

              if (propSingle == null) {
                Navigator.pushNamed(
                  context,
                  CoInvest.id,
                  arguments: property,
                ).then((res) {
                  Provider.of<PropertyProvider>(context, listen: false)
                      .setCoInvestors([]);
                  Provider.of<PropertyProvider>(context, listen: false)
                      .setUserShareInCoInvestment(0);
                  Provider.of<PropertyProvider>(context, listen: false)
                      .setFriendAsGift(null);
                });

                // Navigator.pushNamed(
                //   context,
                //   BuyUnitsInvestPage.id,
                //   arguments: widget.property,
                // );
              } else {
                if (int.parse("${propSingle.availableUnit}") <= 0) {
                  showErrorDialog(
                      "This property has no units available", context);
                } else {
                  Navigator.pushNamed(
                    context,
                    CoInvest.id,
                    arguments: property,
                  ).then((res) {
                    Provider.of<PropertyProvider>(context, listen: false)
                        .setCoInvestors([]);
                    Provider.of<PropertyProvider>(context, listen: false)
                        .setUserShareInCoInvestment(0);
                    Provider.of<PropertyProvider>(context, listen: false)
                        .setFriendAsGift(null);
                  });
                }
              }
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
              "Invest with friends",
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
