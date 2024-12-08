import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/affiliate/affiliate_terms_and_conditions.dart';
import 'package:propstock/screens/affiliate/affiliate_video.dart';
import 'package:propstock/screens/verify_identity/verify_identity.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class AffiliatePage extends StatefulWidget {
  static const id = "affiliate_page";
  const AffiliatePage({super.key});

  @override
  State<AffiliatePage> createState() => _AffiliatePageState();
}

class _AffiliatePageState extends State<AffiliatePage> {
  // late VideoPlayerController _controller;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.networkUrl(Uri.parse(
    //     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
    //   ..initialize().then((_) {
    //     _controller.play();
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
  }

  void _getKYC() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (ctx) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            height: 250,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Complete Tier 2 KYC",
                  style: TextStyle(
                    color: Color(0xff011936),
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    fontFamily: "Inter",
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "You are yet to complete your Tier 2 KYC, to become a affiliate you need to complete your KYC",
                  style: TextStyle(
                    color: Color(0xff5E6D85),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    fontFamily: "Inter",
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                PropStockButton(
                    text: "Complete KYC",
                    disabled: false,
                    onPressed: () async {
                      var res =
                          await Navigator.pushNamed(context, VerifyIdentity.id);

                      if (res == "success") {
                        Navigator.pop(context);
                      }
                    })
              ],
            ),
          );
        });
  }

  void _showWaitingOnKYC() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (ctx) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            height: 250,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Verification in Process",
                  style: TextStyle(
                    color: Color(0xff011936),
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    fontFamily: "Inter",
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Your document is being verified, you will be notified as soon as your are verified.",
                  style: TextStyle(
                    color: Color(0xff5E6D85),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    fontFamily: "Inter",
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                PropStockButton(
                    text: "Thank you",
                    disabled: false,
                    onPressed: () async {
                      Navigator.pop(context);
                    })
              ],
            ),
          );
        });
  }

  void _getStarted() {
    Navigator.pushNamed(context, AffiliateTermsAndConditions.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            // height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height * .95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: MyColors.neutralblack,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Become an affiliate with Propstock!",
                  style: TextStyle(
                    color: Color(0xff1D3354),
                    fontSize: 30,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "As an affiliate, You will to be able to upload properties, reach more prospects internationally, and sell faster.",
                  style: TextStyle(
                    color: Color(0xff5E6D85),
                    fontSize: 16,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w200,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("images/qill.svg"),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .15,
                ),
                if (loading)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: LinearProgressIndicator(),
                  ),
                PropStockButton(
                    text: "Get Started",
                    disabled: false,
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      try {
                        await Provider.of<Auth>(context, listen: false)
                            .tryAutoLogin();
                      } catch (e) {
                        showErrorDialog("could not get user status", context);
                      } finally {
                        setState(() {
                          loading = false;
                        });
                      }
                      if (Provider.of<Auth>(context, listen: false)
                              .beingDocVerified ==
                          true) {
                        _showWaitingOnKYC();
                      } else if (Provider.of<Auth>(context, listen: false)
                              .isDocuVerified !=
                          true) {
                        _getKYC();
                      } else {
                        _getStarted();
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
