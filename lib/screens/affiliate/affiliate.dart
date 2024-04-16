import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/screens/affiliate/affiliate_video.dart';
import 'package:video_player/video_player.dart';

class AffiliatePage extends StatefulWidget {
  static const id = "affiliate_page";
  const AffiliatePage({super.key});

  @override
  State<AffiliatePage> createState() => _AffiliatePageState();
}

class _AffiliatePageState extends State<AffiliatePage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        _controller.play();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          // height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset("images/close_icon.svg")),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                height: 80,
                width: 80,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: MyColors.primary.withOpacity(.2),
                    shape: BoxShape.circle),
                child: Container(
                  height: 56,
                  child: SvgPicture.asset(
                    "images/ph_handshake.svg",
                    height: 56,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Become an affiliate",
                style: TextStyle(
                  color: MyColors.secondary,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Join our Real Estate Affiliate Program today and  earn a 5% commission on every property sale. Partner with us to access a world of real estate opportunities!",
                style: TextStyle(
                  color: MyColors.neutral,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              // this is the progress list tile:
              Container(
                // color: Colors.green,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 48,
                          padding: EdgeInsets.all(10),
                          width: 48,
                          decoration: BoxDecoration(
                            color: MyColors.primary.withOpacity(.2),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset("images/check1.svg"),
                        ),
                        Container(
                          height: 48,
                          width: 2,
                          color: Color(0xffEBEDF0),
                        ),
                        Container(
                          height: 48,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          width: 48,
                          decoration: BoxDecoration(
                            color: Color(0xffEBEDF0),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "2",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          height: 62,
                          width: 2,
                          color: Color(0xffEBEDF0),
                        ),
                        Container(
                          height: 48,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          width: 48,
                          decoration: BoxDecoration(
                            color: Color(0xffEBEDF0),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "3",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Verify Account",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            RichText(
                              text: const TextSpan(
                                text: 'Verify your propstock account ',
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xffbbbbbb)),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "here",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 48,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Become an active user",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .7,
                              child: Text(
                                "Have at least one active investment plan to be eligible to earn",
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xffbbbbbb)),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 48,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Start marketing",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .7,
                              child: Text(
                                "Go to any property you want to market and tap share, a special link will be generated for you which users can use to buy",
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xffbbbbbb)),
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              // this is the video tile

              SizedBox(
                height: 30,
              ),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(new PageRouteBuilder(
                      opaque: true,
                      transitionDuration: const Duration(milliseconds: 100),
                      pageBuilder: (BuildContext context, _, __) {
                        return new AffiliateVideoPlayer();
                      },
                      transitionsBuilder:
                          (_, Animation<double> animation, __, Widget child) {
                        return new SlideTransition(
                          child: child,
                          position: new Tween<Offset>(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).animate(animation),
                        );
                      }));
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      // clipBehavior: Clip.hardEdge,
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.all(Radius.circular(20)),

                      child: _controller.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            )
                          : Container(),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.width *
                          .7 /
                          _controller.value.aspectRatio *
                          .5,
                      left: MediaQuery.of(context).size.width * .7 * .5 + 18,
                      child: Container(
                        height: 42,
                        width: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.3),
                          shape: BoxShape.circle,
                          border: Border.all(width: 1, color: Colors.white),
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
