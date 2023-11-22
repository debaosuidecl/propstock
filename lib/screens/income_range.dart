import 'package:flutter/material.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/loading_screen.dart';
import 'package:propstock/screens/primary_goal.dart';
import 'package:provider/provider.dart';

class IncomeRange extends StatefulWidget {
  static const id = "income_range";
  const IncomeRange({super.key});

  @override
  State<IncomeRange> createState() => _IncomeRangeState();
}

class _IncomeRangeState extends State<IncomeRange> {
  String _incomeRange = "";
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
                                "2/4",
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
                        "Income Range",
                        style: TextStyle(
                          color: Color(0xffbbbbbb),
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "What is your monthly income range?",
                        style: TextStyle(
                            color: Color(0xff1D3354),
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            height: 1.7),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .04,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _incomeRange = "\$0 -  \$10,000";
                        });
                      },
                      child: OptionItem(
                        title: "\$0 -  \$10,000",
                        // description: "No previous experience with investing",
                        selected: _incomeRange == "\$0 -  \$10,000",
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _incomeRange = "\$10,000 -  \$100,000";
                        });
                      },
                      child: OptionItem(
                        title: "\$10,000 -  \$100,000",
                        // description: "No previous experience with investing",
                        selected: _incomeRange == "\$10,000 -  \$100,000",
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _incomeRange = "\$100,000 -  \$500,000";
                        });
                      },
                      child: OptionItem(
                        title: "\$100,000 -  \$500,000",
                        // description: "No previous experience with investing",
                        selected: _incomeRange == "\$100,000 -  \$500,000",
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _incomeRange = "\$500,000 -  above";
                        });
                      },
                      child: OptionItem(
                        title: "\$500,000 -  above",
                        // description: "No previous experience with investing",
                        selected: _incomeRange == "\$500,000 -  above",
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                  ]),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.pushNamed(context, LocationSelect.id);
                  // Navigator.pushNamed(context, IncomeRange.id);
                  // Navigator.pushNamed(context, LocationSelect.id);
                  if (_incomeRange.isEmpty) return;
                  Provider.of<Auth>(context, listen: false)
                      .setIncomeRange(_incomeRange);
                  Navigator.pushNamed(context, PrimaryGoal.id);
                },
                child: Text(
                  "Next",
                  style: TextStyle(
                    color: _incomeRange != ""
                        ? Color(0xffffffff)
                        : Color(0xffB0B0B0),
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w200,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: _incomeRange != ""
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
  // String description;
  bool? selected;
  OptionItem(
      {super.key,
      required this.title,
      // required this.description,
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
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
              SizedBox(
                height: 7,
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
