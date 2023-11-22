import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/widgets/propstock_button.dart';

class InvestmentCardTopup extends StatelessWidget {
  final UserInvestment investment;
  final void Function()? onPressed;
  const InvestmentCardTopup({
    super.key,
    required this.investment,
    required this.onPressed,
  });

  String getAvailableBalance() {
    double doublebalance = 0;
    String balance = "";
    NumberFormat formatter = NumberFormat.currency(
        locale: 'en_US', symbol: "${investment.property.currency} ");

    // balance = formatter.format()
    if (investment.maturityDate > DateTime.now().millisecondsSinceEpoch) {
      // if it's not mature
      doublebalance = ((investment.property.pricePerUnit -
                  investment.pricePerUnitAtPurchase) *
              investment.quantity) -
          investment.amountWithdrawn;
    } else {
      doublebalance = (investment.property.pricePerUnit * investment.quantity) -
          investment.amountWithdrawn;
    }

    balance = formatter.format(doublebalance);
    return balance;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 248,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(24),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        border: Border.all(
          color: Color(0xffCBDFF7),
        ),
      ),
      child: Column(children: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                // padding: EdgeInsets.symmetric(vertical: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  child: Image.network(
                    investment
                        .property.propImage, // Replace with your image URL
                    width: 128, // Adjust the width of the displayed image
                    height: 128, // Adjust the height of the displayed image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    investment.property.name,
                    style: TextStyle(
                      color: MyColors.secondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      fontFamily: "Inter",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    investment.property.location,
                    style: TextStyle(
                      color: MyColors.neutral,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      fontFamily: "Inter",
                    ),
                  ),

                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .4,
                    child: FittedBox(
                      child: Text(
                        "Avail Bal: ${getAvailableBalance()} ",
                        style: TextStyle(
                          color: MyColors.neutral,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),
                  ),
                  // Text(investment.property.location),
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 14,
        ),
        PropStockButton(text: "Withdraw", disabled: false, onPressed: onPressed)
      ]),
    );
  }
}
