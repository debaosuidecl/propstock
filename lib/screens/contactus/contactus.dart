import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/screens/contactus/chat.dart';
import 'package:propstock/widgets/propstock_button.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});
  static const id = "contact_us";

  @override
  State<ContactUs> createState() => _ContactUsState();
}

void copyToClipboard(BuildContext context, String textToCopy) {
  Clipboard.setData(ClipboardData(text: textToCopy));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Text copied to clipboard')),
  );
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset("images/back_arrow.svg")),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              const Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Contact Us",
                  style: TextStyle(
                      color: Color(0xff1D3354),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              const Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "You can reach out to us at any time via our social media, phone or give us a visit.",
                  style: TextStyle(
                      color: Color(0xff5E6D85),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Inter"),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 160,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                decoration: BoxDecoration(
                  border: Border.all(color: MyColors.primary),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [
                  Container(
                    width: double.infinity,
                    child: const Text(
                      "Our Office",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    child: const Text(
                      "30, Adebisi close, off Cole Street,",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff5E6D85),
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: const Text(
                      "Victoria Island.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff5E6D85),
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: const Text(
                      "Lagos, Nigeria",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff5E6D85),
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
                ]),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "propstockinfo@gmail.com",
                      style: TextStyle(
                        color: MyColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Inter",
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          copyToClipboard(context, "propstockinfo@gmail.com");
                        },
                        child: SvgPicture.asset("images/Copy.svg"))
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "+234 902 234 2345",
                      style: TextStyle(
                        color: MyColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Inter",
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          copyToClipboard(context, "+234 902 234 2345");
                        },
                        child: SvgPicture.asset("images/Copy.svg"))
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Let’s get Social",
                  style: TextStyle(
                    color: Color(0xff1D3354),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Inter",
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    SvgPicture.asset("images/twitter.svg"),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Twitter",
                      style: TextStyle(
                        color: Color(0xff1D3354),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Inter",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    SvgPicture.asset("images/Facebook.svg"),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Facebook",
                      style: TextStyle(
                        color: Color(0xff1D3354),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Inter",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    SvgPicture.asset("images/instagram.svg"),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Instagram",
                      style: TextStyle(
                        color: Color(0xff1D3354),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Inter",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 163,
                    child: PropStockButton(
                        text: "Chat with Us",
                        disabled: false,
                        onPressed: () {
                          Navigator.pushNamed(context, ChatContactUs.id);
                        }),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
