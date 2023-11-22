import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/assets.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/providers/buy.dart';
import 'package:propstock/providers/investments.dart';

import 'package:propstock/providers/property.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/InvestAssetCard.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:propstock/widgets/purchaseAssetCard.dart';
import 'package:provider/provider.dart';

class FinalGiftingPage extends StatefulWidget {
  const FinalGiftingPage({super.key});

  @override
  State<FinalGiftingPage> createState() => _FinalGiftingPageState();
}

class _FinalGiftingPageState extends State<FinalGiftingPage> {
  bool _loading = false;
  String password = "";
  bool _obscureText = true;
  bool showSeeMore = true;
  String filter = "all";
  // List<AssetModel> _userAssets = [];
  AssetModel? assetModel;
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  User? friendToGift;

  @override
  initState() {
    super.initState();
    // _searchAssets("");

    _initGifter();
  }
  // initState

  void _initGifter() {
    setState(() {
      assetModel =
          Provider.of<PropertyProvider>(context, listen: false).assetToGift;
      friendToGift =
          Provider.of<PropertyProvider>(context, listen: false).friendAsGift;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      // Calculate available screen height
      // double screenHeight = constraints.maxHeight;

      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
            child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                height: _focusNode.hasFocus
                    ? MediaQuery.of(context).size.height
                    : MediaQuery.of(context).size.height * .8,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context, "send_gift");
                              },
                              child: SvgPicture.asset("images/back_arrow.svg")),
                          Expanded(
                            child: Text(
                              "Send Gift",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: MyColors.secondary,
                                fontSize: 20,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Do you want to send this asset as a gift to ${friendToGift!.firstName} ${friendToGift!.lastName}?",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: MyColors.neutral,
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (assetModel!.userInvestment != null)
                        InvestAssetCard(
                            userInvestment: assetModel!.userInvestment),
                      if (assetModel!.userPurchase != null)
                        PurchaseAssetCard(
                          userPurchase: assetModel!.userPurchase,
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      if (_loading) LinearProgressIndicator(),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _controller,
                        // focusNode: _focus,
                        onChanged: (String val) {
                          setState(() {
                            password = val;
                          });
                        },
                        focusNode: _focusNode,
                        obscureText: _obscureText,
                        // keyboardType: TextInputTyp,
                        // keyboardAppearance: K,

                        // keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          // prefixIcon: Icon(Icons.search),

                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              Icons.remove_red_eye,
                            ),
                          ),

                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          label: Text('Password',
                              style: TextStyle(fontFamily: "Inter")),
                          hintStyle: TextStyle(color: Color(0xffbbbbbb)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: MyColors.fieldDefault,
                            ), // Use the hex color
                            borderRadius: BorderRadius.circular(
                                8), // You can adjust the border radius as needed
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: MyColors.fieldDefault,
                            ), // Use the hex color
                            borderRadius: BorderRadius.circular(
                                8), // You can adjust the border radius as needed
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      PropStockButton(
                        text: "Send Gift",
                        disabled: password.isEmpty || _loading,
                        onPressed: () async {
                          try {
                            setState(() {
                              _loading = true;
                            });
                            if (assetModel!.userInvestment != null) {
                              Provider.of<InvestmentsProvider>(context,
                                      listen: false)
                                  .setSelectedInvestment(
                                      assetModel!.userInvestment);
                              await Provider.of<InvestmentsProvider>(context,
                                      listen: false)
                                  .giftEntireInvestmentToFriend(
                                friendToGift,
                                password,
                                isPass: "yes",
                              );

                              Provider.of<InvestmentsProvider>(context,
                                      listen: false)
                                  .setSelectedInvestment(null);

                              Navigator.pop(context, 'success');
                            }
                            if (assetModel!.userPurchase != null) {
                              Provider.of<BuyPropertyProvider>(context,
                                      listen: false)
                                  .setUserPurchase(assetModel!.userPurchase);
                              await Provider.of<BuyPropertyProvider>(context,
                                      listen: false)
                                  .giftEntirePurchaseToFriend(
                                friendToGift,
                                password,
                                isPass: "yes",
                              );

                              Provider.of<BuyPropertyProvider>(context,
                                      listen: false)
                                  .setUserPurchase(null);
                              Navigator.pop(context, 'success');
                            }
                          } catch (e) {
                            showErrorDialog(e.toString(), context);
                          } finally {
                            setState(() {
                              _loading = false;
                            });
                          }
                        },
                      )
                    ],
                  ),
                ))),
      );
    });
    ;
  }
}
