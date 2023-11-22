import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/providers/investments.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/investments/pin_pre_purchase_modal_investments.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class FriendGiftFinalize extends StatefulWidget {
  static const id = "friend_gift_finalize";
  const FriendGiftFinalize({super.key});

  @override
  State<FriendGiftFinalize> createState() => _FriendGiftFinalizeState();
}

class _FriendGiftFinalizeState extends State<FriendGiftFinalize> {
  User? _friend;
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initFriend();
  }

  void _initFriend() {
    setState(() {
      _friend =
          Provider.of<PropertyProvider>(context, listen: false).friendAsGift;
      _loading = false;
    });
  }

  Future<void> _showBottomSheet(BuildContext context) async {
    var res = await showModalBottomSheet(
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return PinPrePurchaseInvestments();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserInvestment investment =
        ModalRoute.of(context)!.settings.arguments as UserInvestment;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(12.0),
            // margin: const EdgeInsets.symmetric(horizontal: 20),
            child: SvgPicture.asset("images/close_icon.svg"),
          ),
        ),
      ),
      body: _loading
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Container(
              height: MediaQuery.of(context).size.height * .8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 80,
                          width: 80,
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                              color: MyColors.primary.withOpacity(.2),
                              shape: BoxShape.circle),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              "images/Gift.svg",
                              // height: 2.3,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Text(
                            "${_friend!.firstName} ${_friend!.lastName}",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Text(
                            "You are about to send your ‘${investment.property.name}’ investment to ${_friend!.firstName} ${_friend!.lastName} as a gift.",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: MyColors.neutral,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Text(
                            "This means that all rights to this investment, including principal and returns, will be tranferred to them.",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: MyColors.neutral,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: PropStockButton(
                        text: "Send Gift",
                        disabled: false,
                        onPressed: () {
                          Provider.of<InvestmentsProvider>(context,
                                  listen: false)
                              .setSelectedInvestment(investment);
                          print("activate pin modal");
                          _showBottomSheet(context);
                        }),
                  )
                ],
              ),
            )),
    );
  }
}
