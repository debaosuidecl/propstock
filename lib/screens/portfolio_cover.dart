import 'package:flutter/material.dart';
import 'package:propstock/screens/dashboard.dart';
import 'package:propstock/screens/investment_portfolio/investment_portolio_sub_screen.dart';

class PortfolioCover extends StatefulWidget {
  const PortfolioCover({super.key});
  static const id = "portfolio_cover";
  @override
  State<PortfolioCover> createState() => _PortfolioCoverState();
}

class _PortfolioCoverState extends State<PortfolioCover> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            bool isLastPage = !Navigator.canPop(context);
            print("is last page: $isLastPage");
            if (isLastPage) {
              Navigator.pushNamedAndRemoveUntil(
                  context, Dashboard.id, (route) => false);
            } else {
              Navigator.pop(context);
            }
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        // title: Text(""),
      ),
      body: SafeArea(child: InvestmentPortfolioSubScreen()),
    );
  }
}
