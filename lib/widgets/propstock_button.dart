import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';

class PropStockButton extends StatelessWidget {
  final String text;
  final bool disabled;
  final void Function()? onPressed;
  const PropStockButton({
    super.key,
    required this.text,
    required this.disabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // print(disabled);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,

        alignment: Alignment.center,
        height: 48,
        decoration: BoxDecoration(
            // color: MyColors.primary
            color: disabled ? MyColors.neutralGrey : MyColors.primary,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            )),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        // padding: EdgeInsets.symmetric(horizontal: 20),
        // child: ElevatedButton(
        //   style: ElevatedButton.styleFrom(
        //     elevation: 0,
        //   ),
        //   onPressed: onPressed,
        //   child: Text(
        //     text,
        //     style: TextStyle(
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
