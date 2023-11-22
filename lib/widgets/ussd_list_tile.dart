import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';

class USSDListTile extends StatelessWidget {
  final String bank;
  final String ussdCode;
  final bool selected;
  const USSDListTile({
    super.key,
    required this.bank,
    required this.ussdCode,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
          border: Border.all(
            color: selected
                ? MyColors.primary
                : const Color(0xff77869E).withOpacity(.3),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          )),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          bank,
          style: TextStyle(
            fontFamily: "Inter",
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: MyColors.neutral,
          ),
        ),
        trailing: Container(
          color: MyColors.primary.withOpacity(.1),
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 6,
          ),
          child: Text(ussdCode),
        ),
      ),
    );
  }
}
