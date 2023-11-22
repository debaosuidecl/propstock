import 'package:flutter/material.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/investment_experience.dart';
import 'package:propstock/screens/loading_screen.dart';
import 'package:provider/provider.dart';

class IntroSurveyPage extends StatefulWidget {
  const IntroSurveyPage({super.key});

  @override
  State<IntroSurveyPage> createState() => _IntroSurveyPageState();
}

class _IntroSurveyPageState extends State<IntroSurveyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .7,
                      child: const Text(
                        "Let’s help you get started!",
                        style: TextStyle(
                          color: Color(0xff1D3354),
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Answer some questions so we can create the best experience for you. Don’t worry, preferences can always be adjusted",
                      style: TextStyle(
                        color: Color(0xffbbbbbb),
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w200,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .05,
                    ),
                    Container(
                      width: double.infinity,
                      child: Image(
                        image: AssetImage("images/rocket.png"),
                        height: 288,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .05,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, LocationSelect.id);
                          Navigator.pushNamed(context, InvestmentExperience.id);
                        },
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w200,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff2386fe),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            elevation: 0),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: OutlinedButton(
                        onPressed: () async {
                          // set
                          await Provider.of<Auth>(context, listen: false)
                              .skipQuiz();
                          Navigator.pushNamedAndRemoveUntil(
                              context, LoadingScreen.id, (route) => false);
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                vertical: 15), // Add border thickness here
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          side: MaterialStateProperty.all<BorderSide>(
                            const BorderSide(
                                color: Colors.blue,
                                width: 1.0), // Add border thickness here
                          ),
                        ),
                        child: const Text(
                          'Skip Questionnaire',
                          style: TextStyle(
                            color: Colors.blue,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w200,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ));
  }
}
