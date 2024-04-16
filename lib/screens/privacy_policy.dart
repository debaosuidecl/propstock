import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});
  static const id = "privacy_policy";

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                // height: 30,
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.2),
                    offset: Offset(0, 1),
                  )
                ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset("images/close_icon.svg")),
                    const Text(
                      "Privacy Policy",
                      style: TextStyle(
                        color: Color(0xff011936),
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter",
                      ),
                    ),
                    Image.asset("images/close_icon_white.png")
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SvgPicture.asset("images/chartb.svg"),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 250,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: Color(0xffCBDFF7)),
                child: const Text(
                  "Privacy Policy",
                  style: TextStyle(
                      color: Color(0xff011936),
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter"),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Lorem ipsum dolor sit amet consectetur. Mi adipiscing quam pellentesque phasellus nisl est sed. Varius et pretium eget pellentesque in magna. Sed quam eget scelerisque consectetur accumsan massa sit. Adipiscing nulla ipsum in eget sit pellentesque. Malesuada eleifend lacus quisque euismod enim fringilla arcu ut. Blandit proin morbi dui proin. Felis placerat nibh sed et volutpat bibendum scelerisque odio fringilla. Et leo congue elit nibh urna magna varius est et. Lectus diam sagittis pellentesque commodo duis. Erat ridiculus pulvinar morbi enim aliquet.Vestibulum facilisis nibh molestie quisque leo. Vitae accumsan id maecenas lectus quis quam aliquet blandit diam. Viverra phasellus amet porttitor tempus tempor. Duis ante nascetur risus neque lacinia. Lacus lobortis odio in dignissim pharetra ut. Amet lacus dui sit justo volutpat suspendisse nec quam dolor. Gravida dis metus ante urna massa dictum eleifend nibh. Amet ultrices ipsum vitae urna dui nunc mi. Scelerisque volutpat molestie augue aenean in pulvinar. Viverra porttitor lobortis id donec morbi. Eu pretium mauris pellentesque vestibulum augue commodo arcu cras. Commodo mattis vel dui semper cras lacus nisi accumsan.Cras turpis sed netus aenean euismod posuere semper in sodales. Sem quisque massa morbi nec interdum diam. Hendrerit ultricies risus vel sed. Pellentesque pretium venenatis non non orci adipiscing rutrum. Molestie integer proin lacinia feugiat neque netus integer. Vulputate non nulla interdum lectus id ac nulla sit. Gravida sit lacus arcu risus sed. Risus commodo faucibus iaculis tellus bibendum. At auctor nisl sit nunc ante dictum sed vulputate mi. Egestas rutrum hendrerit leo tellus ullamcorper ultrices in. Elementum tellus pellentesque varius tortor id cursus.In ultrices amet volutpat dignissim odio eget diam. Ut orci lacus enim sed orci sit. Leo maecenas at tellus habitant facilisis sit sed massa at. Velit nisi sem pulvinar etiam amet volutpat scelerisque non et. Massa laoreet id at enim faucibus facilisi in. Facilisis odio lorem vitae tortor est odio ullamcorper. Lectus ac interdum vulputate etiam tempor dolor. Vestibulum pretium ipsum sed enim eu. Augue diam vulputate convallis dui. Dui hac donec pretium eget nunc. Aenean turpis sodales amet dictum morbi a. A ipsum risus pharetra in et nibh fringilla est. Sagittis accumsan sed gravida ullamcorper nunc at vestibulum nibh auctor. Leo egestas libero placerat enim est amet.Pellentesque lectus venenatis felis libero cursus. Adipiscing dui felis gravida vulputate vulputate. Commodo diam leo non ut. Arcu malesuada amet et est mi. Velit ornare ipsum sit eu molestie consectetur molestie sed. Amet adipiscing id facilisis lacus. Sit pellentesque quisque pulvinar venenatis urna. Tincidunt egestas pretium ullamcorper tincidunt dictum.Leo dui morbi dictum in. Cras faucibus aliquam vitae semper. Scelerisque commodo nec velit volutpat tristique faucibus diam arcu dolor. Dictum ullamcorper amet arcu orci a egestas sed quisque. Ipsum enim vel vitae turpis a ac sed.",
                  style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color(0xff5E6D85),
                      height: 1.5),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
