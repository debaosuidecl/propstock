import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/screens/notifications/notifications.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required User? user,
  }) : _user = user;

  final User? _user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffeeeeee),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Hello",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: MyColors.neutral,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      "images/hi1.png",
                      height: 16,
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${_user!.firstName} ${_user!.lastName}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: MyColors.primaryDark,
                  ),
                )
              ],
            )
          ],
        ),
        Row(
          children: [
            SvgPicture.asset("images/Compass.svg"),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(new PageRouteBuilder(
                      opaque: true,
                      transitionDuration: const Duration(milliseconds: 100),
                      pageBuilder: (BuildContext context, _, __) {
                        return new NotificationsPage();
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
                child: SvgPicture.asset("images/Bell.svg")),
          ],
        )
      ],
    );
  }
}
