import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/dashboard.dart';
import 'package:propstock/screens/filter_dashboard.dart';
import 'package:propstock/screens/invest.subscreen.dart';
import 'package:propstock/screens/investment_portfolio/investment_portolio_sub_screen.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class Invest extends StatefulWidget {
  const Invest({super.key});
  static const id = "invest_main";

  @override
  State<Invest> createState() => _InvestState();
}

class _InvestState extends State<Invest> {
  int _pageIndex = 0;
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
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: Platform.isIOS
                      ? null
                      : [
                          BoxShadow(
                              color: Color(0xffeeeeee),
                              spreadRadius: 3,
                              blurRadius: 5)
                        ]),
              padding: const EdgeInsets.symmetric(
                // horizontal: 8.0,
                vertical: 10.0,
              ),
              // width: MediaQuery.of(context).size.w,
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 18.0,
                          ),
                          child: Text(
                            "Invest",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Inter",
                              color: Color(0xff011936),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, PageFilter.id)
                                .then((value) async {
                              try {
                                await Provider.of<PropertyProvider>(context,
                                        listen: false)
                                    .queryPropertyWithFilter(20, 0);
                              } catch (e) {
                                showErrorDialog(
                                    "Could not fetch filtered results",
                                    context);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: SvgPicture.asset(
                              "images/FunnelSimple.svg",
                              height: 24,
                              semanticsLabel: 'Acme Logo',
                            ),
                          ),
                        ),
                      ]),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            if (_pageIndex == 0)
              const Expanded(child: InvestSubscreen())
            else
              const Expanded(
                child: InvestmentPortfolioSubScreen(),
              )
          ],
        ),
      ),
    );
  }
}
