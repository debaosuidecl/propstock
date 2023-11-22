import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user.dart';

class SelectedUser extends StatelessWidget {
  final void Function()? onTap;
  final User? user;
  final bool? hideNames;
  double? radius = 32;
  SelectedUser(
      {super.key,
      required this.onTap,
      required this.user,
      this.hideNames,
      this.radius});

  @override
  Widget build(BuildContext context) {
    // print(user?.avatar);
    return Column(
      children: [
        Stack(children: [
          ClipOval(
            child: CircleAvatar(
              radius: radius,
              backgroundColor: Color(0xffeeeeee),
              backgroundImage: NetworkImage("${user?.avatar}"),

              // child: user?.avatar != null
              //     ? Image.network("${user?.avatar}")
              //     : Icon(
              //         Icons.person_2,
              //         color: Color(0xffbbbbbb),
              //       ),
            ),
          ),
          if (onTap != null)
            Positioned(
              right: 0,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                    height: 17.14,
                    width: 17.14,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Colors.black26, shape: BoxShape.circle),
                    child: const Icon(
                      Icons.close,
                      size: 13,
                      color: Colors.white,
                    )),
              ),
            )
        ]),
        if (hideNames != true)
          Text(
            "${user?.firstName} ",
            style: TextStyle(
              color: MyColors.neutralblack,
              fontFamily: "Inter",
              fontSize: 12,
            ),
          ),
        if (hideNames != true)
          Text(
            "${user?.lastName} ",
            style: TextStyle(
              color: MyColors.neutralblack,
              fontFamily: "Inter",
              fontSize: 12,
            ),
          ),
      ],
    );
  }
}
