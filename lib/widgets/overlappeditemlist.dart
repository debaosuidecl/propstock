import 'package:flutter/material.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/widgets/selected_user.dart';

class OverLappedItemList extends StatelessWidget {
  final List<User> users;
  double? radius;
  double? offset = 30;
  bool? isRight;
  OverLappedItemList(
      {super.key, required this.users, this.radius, this.offset, this.isRight});

  @override
  Widget build(BuildContext context) {
    return Stack(
      // clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: users.asMap().entries.map((entry) {
        int index = entry.key;
        User user = entry.value;
        return Positioned(
          right: isRight == true ? index * double.parse("$offset") : null,
          left: isRight == true ? null : index * double.parse("$offset"),
          child: SelectedUser(
            onTap: null,
            user: user,
            hideNames: true,
            radius: radius,
          ),
        );
      }).toList(),
    );
  }
}
