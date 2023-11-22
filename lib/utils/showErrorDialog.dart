import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './platformspecific.dart';

showErrorDialog(String message, BuildContext context, {String? header}) {
  showDialog(
      context: context,
      builder: (ctx) => PlatformSpecific(
            ios: CupertinoAlertDialog(
              title: Text(header != null ? header : 'An Error Occurred!'),
              content: Text(message),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ),
            android: AlertDialog(
              title: Text(header != null ? header : 'Oops! :('),
              content: Text(message),
              actions: <Widget>[
                ElevatedButton(
                  child: Text(
                    'Okay',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ),
          ));
}

showLoadingDialog(String message, BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => PlatformSpecific(
            ios: CupertinoAlertDialog(
              title: LinearProgressIndicator(),
              content: Text(message),

              // actions: <Widget>[
              //   CupertinoDialogAction(
              //     child: Text('Okay'),
              //     onPressed: () {
              //       Navigator.of(ctx).pop();
              //     },
              //   )
              // ],
            ),
            android: AlertDialog(
              title: LinearProgressIndicator(),
              content: Text(message),

              // actions: <Widget>[
              //   ElevatedButton(
              //     child: Text('Okay'),
              //     onPressed: () {
              //       Navigator.of(ctx).pop();
              //     },
              //   )
              // ],
            ),
          ));
}
