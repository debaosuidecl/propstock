import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/wallet.dart';

class WalletCard extends StatelessWidget {
  final Wallet? wallet;
  final void Function()? topupHandler;
  final void Function()? withdrawHandler;
  const WalletCard({
    super.key,
    required this.wallet,
    this.topupHandler,
    this.withdrawHandler,
  });

  @override
  Widget build(BuildContext context) {
    NumberFormat formatter =
        NumberFormat.currency(locale: 'en_US', symbol: "${wallet!.currency} ");
    return Container(
      clipBehavior: Clip.hardEdge,
      // height: 214,
      // padding: EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: MyColors.primary,
          borderRadius: BorderRadius.all(Radius.circular(
            16,
          ))),
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
                  "Wallet Balance",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontFamily: "Inter",
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .4,
                      child: FittedBox(
                        child: Text(formatter.format(wallet!.amount),
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Inter",
                            )),
                      ),
                    ),
                    Container(
                      height: 37.5,
                      width: 37.5,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        "${wallet!.flagurl}",
                        fit: BoxFit.fill,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            onTap: topupHandler,
                            child: Container(
                              alignment: Alignment.center,
                              // width: Medi,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    8,
                                  ),
                                ),
                                color: Colors.white,
                              ),
                              child: Text(
                                "Top Up",
                                style: TextStyle(
                                  color: MyColors.primary,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
                                "Withdraw",
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
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
