import 'dart:async';

import 'package:flutter/material.dart';
import 'package:propstock/screens/location_select.dart';
import 'package:propstock/screens/sign_in_pin.dart';
import 'package:propstock/screens/sign_in_with_password.dart';
import 'package:propstock/screens/signup.dart';
import 'package:propstock/widgets/tiny_circle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});
  static const id = "onboarding";
  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding>
    with SingleTickerProviderStateMixin {
  List<String> imagesList = [
    'images/onboard1.png',
    'images/onboard2.png',
    'images/onboard3.png'
  ];

  // late AnimationController _controller;
  late AnimationController _controller;

  // late PageController _pageController;
  int _currentPageIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _currentPageIndex = (_currentPageIndex + 1) % imagesList.length;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    // _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GestureDetector(
          onTap: () {
            // setState(() {
            //   _currentPageIndex = (_currentPageIndex + 1) % imagesList.length;
            // });
          },
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: Image.asset(
              imagesList[_currentPageIndex],
              key: ValueKey<int>(_currentPageIndex),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              // color: Colors.green.withAlpha(100),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black54,
                    Colors.black,
                  ],
                ),
              ),
              height: MediaQuery.of(context).size.height * .5,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(25),
              child: Column(
                children: [
                  // Text(key: ,)
                  const Text(
                    'Find the home of your dreams',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Inter",
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    // padding: EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      'The best solution for acquiring a property of your choice with ease and at your comfort.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Inter",
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TinyCircle(
                              color: _currentPageIndex == 0
                                  ? Colors.white
                                  : Colors.white38),
                          TinyCircle(
                              color: _currentPageIndex == 1
                                  ? Colors.white
                                  : Colors.white38),
                          TinyCircle(
                              color: _currentPageIndex == 2
                                  ? Colors.white
                                  : Colors.white38),
                        ]),
                  ),

                  SizedBox(height: 40),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SignUp.id);
                      },
                      child: Text("Register"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff2386fe),
                          padding: EdgeInsets.all(0),
                          elevation: 0),
                    ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: OutlinedButton(
                      onPressed: () async {
                        // Add your button action here
                        final prefs = await SharedPreferences.getInstance();

                        final userDataForPin =
                            prefs.getString("userDataForPin");
                        print(userDataForPin);
                        // return;
                        if (userDataForPin != null) {
                          Navigator.pushNamed(
                            context,
                            SignInPin.id,
                            // (route) => false,
                          );
                          return;
                        } else {
                          Navigator.pushNamed(context, SignInWithPassword.id);
                        }
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(
                              color: Colors.white,
                              width: 1.0), // Add border thickness here
                        ),
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ]),
    );
  }
}
