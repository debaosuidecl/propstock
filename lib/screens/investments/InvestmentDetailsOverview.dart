import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
// import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/providers/investments.dart';
import 'package:propstock/screens/invest/send_investment_as_gifts.dart';
import 'package:propstock/screens/investments/AutoInvest.dart';
import 'package:propstock/screens/investments/UserActivityList.dart';
import 'package:propstock/screens/investments/friend_gift_finalize.dart';
import 'package:propstock/screens/investments/market_place_seller.dart';
import 'package:propstock/screens/investments/maturity_date_on_investment.dart';
import 'package:propstock/screens/property_detail/property_detail.about.dart';
import 'package:propstock/screens/property_detail/property_detail.location.dart';
import 'package:propstock/screens/verify_account/verify_account.dart';
import 'package:propstock/screens/verify_identity/verify_identity.dart';
import 'package:propstock/screens/withdrawals/amount_to_withdraw.dart';
import 'package:propstock/screens/withdrawals/amount_to_withdraw_b.dart';
import 'package:propstock/screens/withdrawals/pin_to_withdraw_to_bank.dart';
import 'package:propstock/screens/withdrawals/propstock_wallet_withdraw.dart';
import 'package:propstock/screens/withdrawals/select_a_bank.dart';
import 'package:propstock/screens/withdrawals/withdrawal_address.dart';
import 'package:propstock/screens/withdrawals/withdrawal_init.dart';
import 'package:propstock/utils/showErrorDialog.dart';
// import 'package:propstock/screens/property_detail/property_detail.tags.dart';
// import 'package:propstock/screens/property_detail/property_detail_documents.dart';
// import 'package:propstock/screens/property_detail/property_more_information.dart';
import 'package:propstock/widgets/direction_image_slider.dart';
import 'package:propstock/widgets/propstock_button.dart';
// import 'package:propstock/widgets/invest_buttons.dart';
import 'package:propstock/widgets/user_invest_actions.dart';
import 'package:provider/provider.dart';

class InvestmentDetailsOverview extends StatefulWidget {
  final Property? property;
  final UserInvestment? investment;
  const InvestmentDetailsOverview({
    super.key,
    required this.property,
    required this.investment,
  });

  @override
  State<InvestmentDetailsOverview> createState() =>
      _InvestmentDetailsOverviewState();
}

class _InvestmentDetailsOverviewState extends State<InvestmentDetailsOverview> {
  int imageIndex = 0;
  bool _active = false;
  String withdrawalkey = "withdrawal_init";

  Map<String, dynamic> withdrawalPages = {
    "withdrawal_init": const WithdrawalInit(),
    "amount_to_withdraw": AmountToWithdraw(),
    "amount_to_withdraw_mature": Container(
      child: Text("to be done"),
    ),
    "amount_to_withdraw_b": AmountToWithdrawB(),
    "withdrawal_address": WithdrawalAddress(),
    "select_a_bank": SelectABank(),
    "propstock_wallet_withdraw": PropstockWalletWithdraw(),
    "pin_to_bank": PinToWithdrawToBank()
  };

  Future<void> _showBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 350,
          child: Column(children: [
            SizedBox(
              height: 40,
            ),
            Text(
              "Sell this investment",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .8,
              child: Text(
                "You are about to start the process of selling your investment and uploading it onto the market place",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Inter",
                  color: MyColors.neutral,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
              child: PropStockButton(
                  text: "Continue",
                  disabled: false,
                  onPressed: () {
                    print(widget.investment!.coInvestors);
                    print("coin amount ${widget.investment!.coInvestAmount}");
                    if (widget.investment!.coInvestors.isNotEmpty &&
                        widget.investment!.coInvestAmount <= 0) {
                      return showErrorDialog(
                          "You can only sell an investment you co-invested in if your co-invested amount is greater than zero",
                          context);
                    }

                    final bool isDocuverified =
                        Provider.of<Auth>(context, listen: false)
                                .isDocuVerified ==
                            true;

                    if (!isDocuverified) {
                      Navigator.pop(context);
                      _showVerifyBottomSheet(context);
                      return;
                    }
                    Navigator.pushNamed(context, MarketPlaceSeller.id,
                        arguments: widget.investment);
                  }),
            )
          ]),
        );
      },
    );
  }

  Future<void> _showVerifyBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          child: Column(children: [
            SizedBox(
              height: 40,
            ),
            Text(
              "Verify Account",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
              ),
            ),
            SizedBox(
              height: 40,
            ),
            SvgPicture.asset("images/Warning.svg"),
            SizedBox(
              height: 40,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .8,
              child: Text(
                "Your account has to be verified for you to upload a property to the marketplace",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Inter",
                  color: MyColors.neutral,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
              child: PropStockButton(
                  text: "Verify Account",
                  disabled: false,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      VerifyIdentity.id,
                    );
                  }),
            )
          ]),
        );
      },
    );
  }

  Future<void> _showWithdrawalSheet(BuildContext context) async {
    final resultOfModal = await showModalBottomSheet(
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      context: context,
      builder: (BuildContext ctx) {
        return withdrawalPages[withdrawalkey];
      },
    );

    if (resultOfModal != null) {
      setState(() {
        withdrawalkey = resultOfModal;
      });

      await _showWithdrawalSheet(context);
    } else {
      setState(() {
        withdrawalkey = "withdrawal_init";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .7,
        // padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Stack(
                // fit: StackFit.expand,
                children: [
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 100),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: Image.network(
                      widget.property!.imagesList![imageIndex],
                      key: ValueKey<int>(imageIndex),
                      // width: double.infinity,
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 15,
                    top: 120,
                    child: GestureDetector(
                      onTap: () {
                        if (imageIndex ==
                            widget.property!.imagesList!.length - 1) {
                          setState(() {
                            imageIndex = 0;
                          });
                        } else {
                          setState(() {
                            imageIndex = imageIndex + 1;
                          });
                        }
                      },
                      child: DirectionImageSlider(
                        icon: const Icon(
                          Icons.chevron_right_sharp,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 15,
                    top: 120,
                    child: GestureDetector(
                      onTap: () {
                        if (imageIndex - 1 < 0) {
                          setState(() {
                            imageIndex = 0;
                          });
                        } else {
                          setState(() {
                            imageIndex = imageIndex - 1;
                          });
                        }
                      },
                      child: DirectionImageSlider(
                        icon: const Icon(
                          Icons.chevron_left_sharp,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                height: 20,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.property!.imagesList!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 5,
                        margin: EdgeInsets.only(right: 20),
                        width: 5,
                        decoration: BoxDecoration(
                          color: index == imageIndex
                              ? Color(0xff2286fe)
                              : Color(0xffbbbbbb),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 15,
              ),
              // InvestButtons(
              //   property: widget.property,
              // ),
              UserInvestActions(
                investment: widget.investment,
                withdrawaction: () {
                  if (widget.investment!.coInvestors.length > 0) {
                    showErrorDialog(
                        "You cannot withdraw a co investment", context);
                    return;
                  }
                  Provider.of<InvestmentsProvider>(context, listen: false)
                      .setSelectedInvestment(widget.investment);
                  _showWithdrawalSheet(context);
                },
                sellaction: () {
                  _showBottomSheet(context);
                },
                giftaction: () {
                  Navigator.pushNamed(context, SendInvestmentAsGift.id)
                      .then((value) {
                    print("sending to finalisation page");
                    print(value);
                    if (value != null) {
                      Navigator.pushNamed(context, FriendGiftFinalize.id,
                          arguments: widget.investment);
                    }
                  });
                },
              ),

              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: PropertyDetailAbout(property: widget.property),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: PropertyDetailLocation(property: widget.property),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: MaturityDateOnInvestment(investment: widget.investment),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: AutoInvest(
                    investment: widget.investment,
                    activeAutoInvest: _active,
                    changeAutoInvest: (p0) => setState(() {
                          _active = !_active;
                        })),
              ),

              SizedBox(
                height: 40,
              ),

              UserActivityInvestmentList(),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ));
  }
}
