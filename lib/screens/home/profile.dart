import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/assets/assets.dart';
import 'package:propstock/screens/contactus/contactus.dart';
import 'package:propstock/screens/delete_account/delete_account.dart';
import 'package:propstock/screens/edit_profile/edit_profile.dart';
import 'package:propstock/screens/faqs.dart';
import 'package:propstock/screens/loading_screen.dart';
import 'package:propstock/screens/notifications_profile/notifications_profile.dart';
import 'package:propstock/screens/payment_method/payment_method.dart';
import 'package:propstock/screens/preferences/preferences.dart';
import 'package:propstock/screens/privacy_and_safety/privacy_and_safety.dart';
import 'package:propstock/screens/privacy_policy.dart';
import 'package:propstock/screens/security/security.dart';
import 'package:propstock/screens/terms_and_conditions.dart';
import 'package:propstock/screens/verify_identity/verify_identity.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  static const id = "user_profile";

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    // final User user = ModalRoute.of(context)!.settings.arguments as User;
    // print(user.avatar);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 184,
                  decoration: BoxDecoration(color: Color(0xffCBDFF7)),
                ),
                Positioned(
                  bottom: -50,
                  child: Container(
                      height: 120,
                      width: 120,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffeeeeee),
                      ),
                      child: Provider.of<Auth>(context, listen: true)
                              .profilepic!
                              .isNotEmpty
                          ? Image.network(
                              "${Provider.of<Auth>(context, listen: true).profilepic}",
                            )
                          : Container()),
                ),
              ],
            ),
            SizedBox(
              height: 60,
            ),
            Text(
              "${Provider.of<Auth>(context, listen: true).firstname} ${Provider.of<Auth>(context, listen: true).lastname}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: "Inter",
                fontSize: 20,
              ),
            ),
            if (Provider.of<Auth>(context, listen: true).email != null)
              Text(
                "@${Provider.of<Auth>(context, listen: true).email!.split("@")[0]}",
                style: TextStyle(
                  color: MyColors.neutralblack,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Inter",
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, EditProfile.id);
              },
              child: Container(
                width: 112,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color(0xff37B34A).withOpacity(.1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    )),
                child: Text(
                  "Edit Profile",
                  style: TextStyle(
                    color: Color(0xff37B34A),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                "Personal",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color(0xff1D3354),
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  fontFamily: "Inter",
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ProfileItem(
              title: "Preferences",
              image: "images/preferences.svg",
              onTap: () {
                // go to preferences
                Navigator.pushNamed(context, Preferences.id);
              },
            ),
            ProfileItem(
              title: "I.D Verification",
              image: "images/UserFocusb.svg",
              onTap: () {
                // go to preferences
                Navigator.pushNamed(context, VerifyIdentity.id);
              },
            ),
            ProfileItem(
              title: "Payment",
              image: "images/CreditCardb.svg",
              onTap: () {
                // go to preferences
                Navigator.pushNamed(context, PaymentMethodProfile.id);
              },
            ),
            ProfileItem(
              title: "Assets",
              image: "images/houseb.svg",
              onTap: () {
                // go to preferences
                Navigator.pushNamed(context, Assets.id);
              },
            ),
            ProfileItem(
              title: "Saved",
              image: "images/savedb.svg",
              onTap: () {
                // go to preferences
              },
            ),
            ProfileItem(
              title: "Log Out",
              color: Colors.red,
              image: "images/SignOut.svg",
              onTap: () async {
                // go to preferences
                await Provider.of<Auth>(context, listen: false).logout();
                Navigator.pushNamed(context, LoadingScreen.id);
              },
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                "Account",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color(0xff1D3354),
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  fontFamily: "Inter",
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ProfileItem(
              title: "Notifications",
              image: "images/bellb.svg",
              onTap: () {
                // go to preferences
                Navigator.pushNamed(context, NotificationsProfile.id);
              },
            ),
            ProfileItem(
              title: "Security",
              image: "images/securityb.svg",
              onTap: () {
                // go to preferences
                Navigator.pushNamed(context, Security.id);
              },
            ),
            ProfileItem(
              title: "Privacy and Safety",
              image: "images/Keyhole.svg",
              onTap: () {
                // go to preferences
                Navigator.pushNamed(context, PrivacyAndSafety.id);
              },
            ),
            ProfileItem(
              title: "Delete Account",
              image: "images/HeartBreak.svg",
              onTap: () {
                // go to preferences
                Navigator.pushNamed(context, DeleteAccount.id);
              },
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                "Propstock",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color(0xff1D3354),
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  fontFamily: "Inter",
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ProfileItem(
              title: "Terms & Conditions",
              image: "images/Scroll.svg",
              onTap: () {
                // go to preferences
                Navigator.pushNamed(context, TermsAndConditions.id);
              },
            ),
            ProfileItem(
              title: "Privacy Policy",
              image: "images/ShieldCheck.svg",
              onTap: () {
                // go to preferences
                Navigator.pushNamed(context, PrivacyPolicy.id);
              },
            ),
            ProfileItem(
              title: "FAQs",
              image: "images/Question.svg",
              onTap: () {
                // go to preferences
                Navigator.pushNamed(context, FAQs.id);
              },
            ),
            ProfileItem(
              title: "Contact Us",
              image: "images/Phone.svg",
              onTap: () {
                // go to preferences
                Navigator.pushNamed(context, ContactUs.id);
              },
            ),
            SizedBox(
              height: 40,
            ),
            SvgPicture.asset("images/pstock.svg"),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final String title;
  final String image;
  Color? color;
  final void Function()? onTap;
  ProfileItem({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: Color(0xffeeeeee)),
          ),
        ),
        child: ListTile(
          // titleAlignment: ListTileTitleAlignment.center,
          contentPadding: EdgeInsets.zero,
          leading: Padding(
            padding: const EdgeInsets.only(
              bottom: 0.0,
              top: 2,
            ),
            child: SvgPicture.asset(image),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 16,
              color: color ?? color,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: SvgPicture.asset("images/direction_right.svg"),
        ),
      ),
    );
  }
}
