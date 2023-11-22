import 'package:flutter/material.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/income_range.dart';
import 'package:propstock/screens/loading_screen.dart';
import 'package:propstock/screens/property_preference.dart';
import 'package:provider/provider.dart';

class PrimaryGoal extends StatefulWidget {
  static const id = "primary_goal";
  const PrimaryGoal({super.key});

  @override
  State<PrimaryGoal> createState() => _PrimaryGoalState();
}

class _PrimaryGoalState extends State<PrimaryGoal> {
  // String _investmentExpereince = "";

  List<String> _primaryGoals = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .88,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Color(0xff1D3354),
                                ),
                                onPressed: () {
                                  // Navigate back to the previous screen when the back button is pressed
                                  Navigator.pop(context);
                                },
                              ),
                              Text(
                                "3/4",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              // go to next page without submitting
                              // go to next page without submitting
                              await Provider.of<Auth>(context, listen: false)
                                  .skipQuiz();
                              Navigator.pushNamedAndRemoveUntil(
                                  context, LoadingScreen.id, (route) => false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Skip Quiz",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Primary goal",
                        style: TextStyle(
                          color: Color(0xffbbbbbb),
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .01,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "What is your primary purpose for using Propstock?",
                        style: TextStyle(
                            color: Color(0xff1D3354),
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            height: 1.7),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "You can select multiple options",
                        style: TextStyle(
                          color: Color(0xffbbbbbb),
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .04,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_primaryGoals.contains("Acquire Property")) {
                          setState(() {
                            _primaryGoals.remove("Acquire Property");
                          });
                        } else {
                          setState(() {
                            _primaryGoals.add("Acquire Property");
                          });
                        }
                      },
                      child: OptionItem(
                        title: "Acquire Property",
                        description:
                            "Buying of real estate and owning investment property ",
                        selected: _primaryGoals.contains("Acquire Property"),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_primaryGoals.contains("Build wealth")) {
                          setState(() {
                            _primaryGoals.remove("Build wealth");
                          });
                        } else {
                          setState(() {
                            _primaryGoals.add("Build wealth");
                          });
                        }
                      },
                      child: OptionItem(
                        title: "Build wealth",
                        selected: _primaryGoals.contains("Build wealth"),
                        description:
                            "Increasing wealth and attaining big financial goals in the long run",
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_primaryGoals.contains("Retirement")) {
                          setState(() {
                            _primaryGoals.remove("Retirement");
                          });
                        } else {
                          setState(() {
                            _primaryGoals.add("Retirement");
                          });
                        }
                      },
                      child: OptionItem(
                        title: "Retirement",
                        selected: _primaryGoals.contains("Retirement"),
                        description:
                            "Growing retirement savings by investing in real estate in order to increase retirement funds",
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_primaryGoals.contains("Source of Income")) {
                          setState(() {
                            _primaryGoals.remove("Source of Income");
                          });
                        } else {
                          setState(() {
                            _primaryGoals.add("Source of Income");
                          });
                        }
                      },
                      child: OptionItem(
                        title: "Source of Income",
                        selected: _primaryGoals.contains("Source of Income"),
                        description:
                            "As a different source of non-taxable income",
                      ),
                    ),
                  ]),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.pushNamed(context, LocationSelect.id);
                  if (_primaryGoals.isEmpty) return;
                  Provider.of<Auth>(context, listen: false)
                      .setPrimaryGoals(_primaryGoals);
                  Navigator.pushNamed(context, PropertyPreference.id);
                },
                child: Text(
                  "Next",
                  style: TextStyle(
                    color: _primaryGoals.isNotEmpty
                        ? Color(0xffffffff)
                        : Color(0xffB0B0B0),
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w200,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryGoals.isNotEmpty
                        ? Color(0xff2386fe)
                        : Color(0xffEBEDF0),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    elevation: 0),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  String title;
  String description;
  bool? selected;
  OptionItem(
      {super.key,
      required this.title,
      required this.description,
      this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(
              color: selected == true ? Colors.blue : Color(0xffCBDFF7),
              width: 1.0),
          borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        Container(
          height: 15,
          width: 15,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected == true ? Colors.blue : Colors.transparent,
              border: Border.all(color: Color(0xffCBDFF7), width: 1.0)),
        ),
        SizedBox(
          width: 20,
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: Color(0xff011936),
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
              SizedBox(
                height: 7,
              ),
              // width: MediaQuery,
              Container(
                width: MediaQuery.of(context).size.width * .7,
                child: Text(description,
                    style: TextStyle(
                      color: Color(0xff5E6D85),
                      fontFamily: "Inter",
                      fontSize: 12,
                      fontWeight: FontWeight.w100,
                      height: 1.5,
                    )),
              ),
            ],
          ),
        )
      ]

          // title: Text(title),
          // subtitle: Text(description),
          ),
    );
  }
}
