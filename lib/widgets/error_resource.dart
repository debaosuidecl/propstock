import 'package:flutter/material.dart';

class ErrorResource extends StatelessWidget {
  String message;
  void Function() onRefresh;

  ErrorResource({super.key, required this.message, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: onRefresh,
            child: Icon(Icons.refresh),
          )
        ],
      )),
    );
  }
}
