import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/wallet.dart';

class HomeCard extends StatelessWidget {
  final Wallet? wallet;
  final String title;
  final double diff;
  final void Function()? topupHandler;
  final void Function()? withdrawHandler;
  final Color color;
  const HomeCard(
      {super.key,
      required this.wallet,
      this.topupHandler,
      this.withdrawHandler,
      required this.title,
      required this.color,
      required this.diff});

  double getMoneyAddition(double amount, double diff) {
    // diff = (x - amount)/(x+1)
    // xdiff +diff = x- amount;
    // x - xdiff = amount + diff

    //x = (amount + diff)/ (1-diff)

    double preprice = (amount + diff) / (1 - diff);

    return preprice - amount;
  }

  @override
  Widget build(BuildContext context) {
    String curr = wallet!.currency == "NGN" ? "N" : wallet!.currency;

    NumberFormat formatter =
        NumberFormat.currency(locale: 'en_US', symbol: "${curr}");
    print(wallet!.currency);
    return Container(
      clipBehavior: Clip.hardEdge,
      height: 214,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(
            16,
          ),
        ),
      ),
      child: Stack(
        children: [
          // MyShape(),
          Positioned(
            left: 0,
            child: SvgPicture.asset("images/card_paint_1.svg"),
          ),
          Positioned(
            left: 0,
            child: SvgPicture.asset("images/card_paint_2.svg"),
          ),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontFamily: "Inter",
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .6,
                      child: Text(formatter.format(wallet!.amount),
                          // overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Inter",
                          )),
                    ),
                    // Container(
                    //   height: 37.5,
                    //   width: 37.5,
                    //   clipBehavior: Clip.hardEdge,
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //   ),
                    //   child: Image.network(
                    //     "${wallet!.flagurl}",
                    //     fit: BoxFit.fill,
                    //   ),
                    // )
                  ],
                ),

                SizedBox(
                  height: 10,
                ),

                Row(
                  children: [
                    SvgPicture.asset("images/upd.svg"),
                    SizedBox(
                      width: 15,
                    ),
                    Text("${diff.toStringAsFixed(2)}%",
                        // overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Inter",
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        "(${curr} ${getMoneyAddition(wallet!.amount, diff).toStringAsFixed(2)} this week)",
                        // overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Inter",
                        )),
                  ],
                ),
                // Container(
                //   height: 37.5,
                //   width: 37.5,
                //   clipBehavior: Clip.hardEdge,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //   ),
                //   child: Image.network(
                //     "${wallet!.flagurl}",
                //     fit: BoxFit.fill,
                //   ),

                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: withdrawHandler,
                          child: Container(
                            alignment: Alignment.center,
                            // width: 158,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  8,
                                ),
                              ),
                              border: Border.all(
                                color: Colors.white,
                              ),
                              color: Colors.transparent,
                            ),
                            child: Text(
                              "Top up",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
