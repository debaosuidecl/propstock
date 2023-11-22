import 'package:flutter/material.dart';

class Assets extends StatefulWidget {
  static const id = "assets";
  const Assets({super.key});

  @override
  State<Assets> createState() => _AssetsState();
}

class _AssetsState extends State<Assets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assets"),
      ),
      body: Column(children: []),
    );
  }
}
