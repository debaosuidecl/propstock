import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/filter_dashboard.dart';
import 'package:propstock/screens/invest.subscreen.dart';
import 'package:propstock/screens/investment_portfolio/investment_portolio_sub_screen.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class Invest extends StatefulWidget {
  const Invest({super.key});

  @override
  State<Invest> createState() => _InvestState();
}

class _InvestState extends State<Invest> {
  int _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Color(0xffeeeeee), spreadRadius: 3, blurRadius: 5)
              ]),
              padding: const EdgeInsets.symmetric(
                // horizontal: 8.0,
                vertical: 20.0,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _pageIndex = 0;
                          });
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            // color: Colors.green,
                            child: Text(
                              "Invest",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 18,
                                fontWeight: _pageIndex == 0
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: _pageIndex == 0
                                    ? const Color(0xff2286FE)
                                    : const Color(0xff5e6d85),
                              ),
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _pageIndex = 1;
                          });
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            // color: Colors.green,
                            child: Text(
                              "Portfolio",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 18,
                                fontWeight: _pageIndex == 1
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: _pageIndex == 1
                                    ? const Color(0xff2286FE)
                                    : const Color(0xff5e6d85),
                              ),
                            )),
                      ),
                      // Container(child: Text("Portfolio")),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Color(0xffEBEDF0),
              height: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 2,
                    width: MediaQuery.of(context).size.width / 10,
                    color: _pageIndex == 0 ? Colors.blue : Color(0xffebedf0),
                  ),
                  Container(
                    height: 12,
                    width: MediaQuery.of(context).size.width / 10,
                    color: _pageIndex == 1 ? Colors.blue : Color(0xffebedf0),
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
