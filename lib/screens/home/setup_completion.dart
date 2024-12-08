import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/home/profile.dart';
import 'package:propstock/screens/verify_identity/verify_identity.dart';
import 'package:propstock/screens/wallet/wallet.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/loading_bar_pure.dart';
import 'package:provider/provider.dart';

class CompleteSetupHome extends StatefulWidget {
  const CompleteSetupHome({super.key});
  static const id = "complete_setup_home";

  @override
  State<CompleteSetupHome> createState() => _CompleteSetupHomeState();
}

class _CompleteSetupHomeState extends State<CompleteSetupHome> {
  bool loading = true;
  double completefraction = 0;

  Future<void> _initSetup() async {
    setState(() {
      loading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).tryAutoLogin();
      double newfraction = 1;
      double totalComplete = 4;
      if (Provider.of<Auth>(context, listen: false).hasToppedUpWallet == true) {
        newfraction = newfraction + 1;
      }
      if (Provider.of<Auth>(context, listen: false).isDocuVerified == true) {
        newfraction = newfraction + 1;
      }
      if (Provider.of<Auth>(context, listen: false).basicInformationComplete ==
          true) {
        newfraction = newfraction + 1;
      }

      setState(() {
        // listOfSchema = _listOfSchema;
        // _friends = _listOfFriends;
        completefraction = newfraction / totalComplete;
        loading = false;
      });
    } catch (e) {
      showErrorDialog("could not get set up details", context);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSetup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Complete Set-up",
          style: TextStyle(
            color: Color(0xff1D3354),
            fontWeight: FontWeight.w500,
            fontSize: 18,
            fontFamily: "Inter",
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: MyColors.neutralGrey,
          ),
        ),
      ),

      backgroundColor: Colors.white,
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                          "${(completefraction * 100).toStringAsFixed(2)}% complete",
                          style: TextStyle(
                            color: MyColors.primary,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: LoadingBarPure(
                    fraction: completefraction,
                    filledColor: MyColors.primary,
                    barHeight: 5,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                if (Provider.of<Auth>(context, listen: false).isDocuVerified !=
                    true)
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, VerifyIdentity.id);
                        },
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            child: Text(
                              "I.D Verification",
                              style: TextStyle(
                                color: Color(0xff303030),
                                fontSize: 16,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          isThreeLine: true,
                          subtitle: Text(
                              "We need to verify your identity before actions can be completed.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff8E99AA),
                                fontFamily: "Inter",
                              )),
                          trailing: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: SvgPicture.asset("images/right_dir.svg"),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (Provider.of<Auth>(context, listen: false)
                        .hasToppedUpWallet !=
                    true)
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, WalletPage.id);
                        },
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            child: Text(
                              "Fund Wallet",
                              style: TextStyle(
                                color: Color(0xff303030),
                                fontSize: 16,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          isThreeLine: true,
                          subtitle: Text(
                              "Start your real estate journey by funding your wallet",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff8E99AA),
                                fontFamily: "Inter",
                              )),
                          trailing: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: SvgPicture.asset("images/right_dir.svg"),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (Provider.of<Auth>(context, listen: false)
                        .basicInformationComplete !=
                    true)
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Profile.id);
                        },
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            child: Text(
                              "Profile Information",
                              style: TextStyle(
                                color: Color(0xff303030),
                                fontSize: 16,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          isThreeLine: true,
                          subtitle: Text(
                              "Fill out the information form in your profile. This helps us customize your account",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff8E99AA),
                                fontFamily: "Inter",
                              )),
                          trailing: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: SvgPicture.asset("images/right_dir.svg"),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            )),
      // body: ,
    );
  }
}
