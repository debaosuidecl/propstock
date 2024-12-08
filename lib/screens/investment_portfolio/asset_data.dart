import 'package:flutter/material.dart';
import 'package:propstock/models/asset_distribution.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/providers/portfolio.dart';
import 'package:propstock/screens/investment_portfolio/pie_chart.dart';
import 'package:propstock/screens/investments/investements.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/loading_bar_pure.dart';
import 'package:provider/provider.dart';

class AssetData extends StatefulWidget {
  const AssetData({super.key});

  @override
  State<AssetData> createState() => _AssetDataState();
}

class _AssetDataState extends State<AssetData> {
  AssetDistribution _assetDistribution = AssetDistribution(
    landCount: 1,
    rentalCount: 1,
    commercialCount: 1,
    residentialCount: 1,
    sum: 1,
  );

  // double fraction = 0;
  @override
  void initState() {
    super.initState();
    _initAssetData();
  }

  Future<void> _initAssetData() async {
    try {
      final assetData =
          await Provider.of<PortfolioProvider>(context, listen: false)
              .fetchAssetDistribution();

      print(assetData);
      setState(() {
        _assetDistribution = assetData;
      });
    } catch (e) {
      showErrorDialog("Could not load asset distribution", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double assetdistributionsum = _assetDistribution.residentialCount +
        _assetDistribution.commercialCount +
        _assetDistribution.landCount +
        _assetDistribution.rentalCount;
    double residentialFraction =
        _assetDistribution.residentialCount / assetdistributionsum;
    double commercialFraction =
        _assetDistribution.commercialCount / assetdistributionsum;
    double landCountFraction =
        _assetDistribution.landCount / assetdistributionsum;
    double rentalCountFraction =
        _assetDistribution.rentalCount / assetdistributionsum;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Your Assets",
              style: TextStyle(
                color: MyColors.primaryDark,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
                fontSize: 20,
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Investments.id);
                  },
                  child: Text(
                    "See investments",
                    style: TextStyle(
                      color: MyColors.primary,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      fontFamily: "Inter",
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 14,
                  color: MyColors.primary,
                ),
              ],
            )
          ],
        ),
        PropStockPieChart(
          assetdist: _assetDistribution,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Land",
              style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: MyColors.neutral,
              ),
            ),
            Row(
              children: [
                LoadingBarPure(
                  fraction: _assetDistribution.sum == 0 ? 0 : landCountFraction,
                  filledColor: MyColors.primary,
                  barHeight: 4.0,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 50,
                  child: Text(
                    _assetDistribution.sum == 0
                        ? "0.00%"
                        : "${(landCountFraction * 100).toStringAsFixed(2)}%",
                    style: TextStyle(
                      color: MyColors.primary,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        //Rental Property
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Rental Property",
              style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: MyColors.neutral,
              ),
            ),
            Row(
              children: [
                LoadingBarPure(
                  fraction: rentalCountFraction,
                  filledColor: MyColors.primaryDark,
                  barHeight: 4.0,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 50,
                  child: Text(
                    "${(rentalCountFraction * 100).toStringAsFixed(2)}%",
                    style: TextStyle(
                      color: MyColors.primaryDark,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
// COMMERCIAL PROPERTY
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Commercial Property",
              style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: MyColors.neutral,
              ),
            ),
            Row(
              children: [
                LoadingBarPure(
                  fraction: commercialFraction,
                  filledColor: Color(0xffF55D3E),
                  barHeight: 4.0,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 50,
                  child: Text(
                    "${(commercialFraction * 100).toStringAsFixed(2)}%",
                    style: TextStyle(color: Color(0xffF55D3E)),
                  ),
                )
              ],
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),

        // RESIDENTIAL PROPERTY
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Residential Property",
              style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: MyColors.neutral,
              ),
            ),
            Row(
              children: [
                LoadingBarPure(
                  fraction: residentialFraction,
                  filledColor: Color(0xff1A936F),
                  barHeight: 4.0,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 50,
                  child: Text(
                    "${(residentialFraction * 100).toStringAsFixed(2)}%",
                    style: TextStyle(color: Color(0xff1A936F)),
                  ),
                )
              ],
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
