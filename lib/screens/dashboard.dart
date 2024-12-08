import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/buy_property/buy_property.dart';
import 'package:propstock/screens/home/app_home.dart';
import 'package:propstock/screens/invest.main.dart';
import 'package:propstock/screens/loading_screen.dart';
import 'package:propstock/screens/marketplace/market_place.dart';
import 'package:propstock/screens/portfolio_cover.dart';
import 'package:propstock/screens/wallet/wallet.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  static const id = "dashboard";
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int pageIndex = 0;
  final pages = [
    const AppHome(),
    const Invest(),
    const WalletPage(),
    const PortfolioCover(),
    const MarketPlace(),
  ];
  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 90,
      padding: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color(0xffeeeeee), spreadRadius: 4, blurRadius: 6),
        ],

        // borderRadius: const BorderRadius.only(
        //   topLeft: Radius.circular(20),
        //   topRight: Radius.circular(20),
        // ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            // enableFeedback: false,
            onTap: () {
              setState(() {
                pageIndex = 0;
              });
            },
            child: pageIndex == 0
                ? Container(
                    width: MediaQuery.of(context).size.width / 5,
                    // color: Colors.green,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "images/House.svg",
                          height: 24,
                          semanticsLabel: 'Acme Logo',
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue),
                        )
                        // Text("Home")
                      ],
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width / 5,
                    // color: Colors.green,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "images/House_outline.svg",
                          height: 24,
                          semanticsLabel: 'Acme Logo',
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                            color: Color(0xff8E99AA),
                          ),
                        )
                      ],
                    ),
                  ),
          ),
          GestureDetector(
            // enableFeedback: false,
            onTap: () {
              setState(() {
                pageIndex = 1;
              });
            },
            child: pageIndex == 1
                ? Container(
                    width: MediaQuery.of(context).size.width / 5,
                    // color: Colors.green,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "images/Invest.svg",
                          height: 16.5,
                          semanticsLabel: 'Acme Logo',
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue),
                        )
                        // Text("Home")
                      ],
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width / 5,
                    // color: Colors.green,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "images/Invest_outline.svg",
                          height: 24,
                          semanticsLabel: 'Acme Logo',
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Invest",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                            color: Color(0xff8E99AA),
                          ),
                        )
                      ],
                    ),
                  ),
          ),
          GestureDetector(
            // enableFeedback: false,
            onTap: () {
              setState(() {
                pageIndex = 2;
              });
            },
            child: pageIndex == 2
                ? Container(
                    width: MediaQuery.of(context).size.width / 5,
                    // color: Colors.green,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "images/Wallet.svg",
                          height: 18.5,
                          semanticsLabel: 'Acme Logo',
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue),
                        )
                        // Text("Home")
                      ],
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width / 5,
                    // color: Colors.green,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "images/Wallet_outline.svg",
                          height: 24,
                          semanticsLabel: 'Acme Logo',
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Wallet",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                            color: Color(0xff8E99AA),
                          ),
                        )
                      ],
                    ),
                  ),
          ),
          GestureDetector(
            // enableFeedback: false,
            onTap: () {
              setState(() {
                pageIndex = 3;
              });
            },
            child: pageIndex == 3
                ? Container(
                    width: MediaQuery.of(context).size.width / 5,
                    // color: Colors.green,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "images/ShoppingBagOpen.svg",
                          height: 24,
                          semanticsLabel: 'Acme Logo',
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue),
                        )
                        // Text("Home")
                      ],
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width / 5,
                    // color: Colors.green,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "images/ShoppingBagOpen_outline.svg",
                          height: 24,
                          semanticsLabel: 'Acme Logo',
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Portfolio",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                            color: Color(0xff8E99AA),
                          ),
                        )
                      ],
                    ),
                  ),
          ),
          GestureDetector(
            // enableFeedback: false,
            onTap: () {
              setState(() {
                pageIndex = 4;
              });
            },
            child: pageIndex == 4
                ? Container(
                    width: MediaQuery.of(context).size.width / 5,
                    // color: Colors.green,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image(
                        //   image: AssetImage(
                        //     "images/Storefront.png",
                        //   ),
                        //   height: 35,
                        // ),
                        SvgPicture.asset(
                          "images/Storefront.svg",
                          height: 24,
                          semanticsLabel: 'Acme Logo',
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue),
                        )
                        // Text("Home")
                      ],
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width / 5,
                    // color: Colors.green,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "images/Storefront_outline.svg",
                          height: 24,
                          semanticsLabel: 'Acme Logo',
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Market",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                            color: Color(0xff8E99AA),
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: buildMyNavBar(context),
      body: pages[pageIndex],
    );
  }
}
