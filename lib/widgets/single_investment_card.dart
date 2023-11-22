import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/providers/investments.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/investments/investment_details.dart';
import 'package:propstock/widgets/overlappeditemlist.dart';
import 'package:provider/provider.dart';

class SingleInvestmentCard extends StatelessWidget {
  final Property property;
  final UserInvestment investment;
  SingleInvestmentCard(
      {super.key, required this.property, required this.investment});
  @override
  Widget build(BuildContext context) {
    double valueAtPurchase = investment.pricePerUnitAtPurchase;
    double currentPropertyValue = property.pricePerUnit;
    double percentageChange =
        (currentPropertyValue - valueAtPurchase) / valueAtPurchase;

    return GestureDetector(
      onTap: () {
        Provider.of<PropertyProvider>(context, listen: false)
            .setSelectedProperty(property);
        Provider.of<InvestmentsProvider>(context, listen: false)
            .setSelectedInvestment(investment);
        Navigator.pushNamed(
          context,
          InvestmentDetails.id,
        ).then((value) => {
              // reloadPage
            });
      },
      child: Container(
        // height: ,
        margin: EdgeInsets.only(bottom: 25),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          // vertical: 0,
        ),
        decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xffCBDFF7),
              width: 1.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .331,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0), // Rounded corners
                  child: Image.network(
                    property.propImage, // Replace with your image URL
                    width: 120, // Adjust the width of the displayed image
                    height: 120, // Adjust the height of the displayed image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Container(
                // color: Colors.green,
                // height: 160,
                padding: EdgeInsets.symmetric(vertical: 20),

                width: MediaQuery.of(context).size.width * .4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      property.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Color(
                          0xff011936,
                        ),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Inter",
                      ),
                    ),
                    Text(
                      property.location,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Color(
                          0xff5E6D85,
                        ),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Inter",
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      investment.quantity == 1
                          ? "${investment.quantity} Unit"
                          : "${investment.quantity} Units",
                      style: const TextStyle(
                        color: Color(
                          0xff011936,
                        ),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter",
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_upward,
                              size: 16,
                              color: percentageChange < 0
                                  ? MyColors.error
                                  : MyColors.success,
                            ),
                            Text(
                              "${(percentageChange * 100).toStringAsFixed(2)}%",
                              style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: MyColors.success),
                            )
                          ],
                        ),
                        Container(
                          // color: Colors.green,
                          width: MediaQuery.of(context).size.width * .2,
                          // width: Medi,

                          height: 40,
                          alignment: Alignment.topRight,
                          child: OverLappedItemList(
                            radius: 12,
                            users: investment.coInvestors,
                            offset: 15,
                            isRight: true,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
