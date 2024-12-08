import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:propstock/screens/dashboard.dart';
import 'package:propstock/screens/email_code_verify.dart';
import 'package:propstock/screens/enable_biometrics.dart';
import 'package:propstock/screens/intro_survey_page.dart';
import 'package:propstock/screens/onboarding.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/security/verifyPhone.dart';
import 'package:propstock/screens/security/verifyPhoneFromSignIn.dart';
import 'package:propstock/screens/set_pin.dart';
import 'package:propstock/utils_general.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatefulWidget {
  static const id = "loading";

  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool noInternet = false;
  bool showConnectivitySnackBar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;

    final message = hasInternet
        ? "You have again ${result.toString()}"
        : "You have no internet";

    final color = hasInternet ? Colors.green : Colors.red;

    if (hasInternet) {
      // UtilsGeneral.showTopSnackBar(context, message, color);
      setState(() {
        noInternet = true;
      });
    }
    return hasInternet;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tryAutoLogin();
  }

  Future<void> _tryAutoLogin() async {
    try {
      setState(() {
        noInternet = false;
      });

      final bool onBoarded =
          await Provider.of<Auth>(context, listen: false).checkIfOnboarded();
      print(onBoarded);
      print("bording status");

      // final bool isDefaultSMSApp = await checkIfAppIsDefaultApp();
      print("checking default sms app");

      // if (!onBoarded) {
      //   print("Not boarded");
      //   Navigator.of(context).push(
      //     MaterialPageRoute(builder: (context) => OnBoarding()),
      //   );
      //   return;
      // }
      final prefs = await SharedPreferences.getInstance();
      final enabledBio = prefs.containsKey('enabled_biometrics');

      print("enabled bio: $enabledBio");
      await Provider.of<Auth>(context, listen: false)
          .tryAutoLogin(removeWaitTime: false);
      print("line 69");
      print(Provider.of<Auth>(context, listen: false).isAuth);
      if (!Provider.of<Auth>(context, listen: false).isVerified &&
          Provider.of<Auth>(context, listen: false).isAuth) {
        // String? phone = Provider.of<Auth>(context, listen: false).phone;
        print("pushing to code verify");
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => EmailCodeVerify()),
        );
      } else if (Provider.of<Auth>(context, listen: false).isVerified &&
          Provider.of<Auth>(context, listen: false).isAuth &&
          Provider.of<Auth>(context, listen: false).requirestwofa == true) {
        // String? phone = Provider.of<Auth>(context, listen: false).phone;
        print("pushing to code verify");
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => VerifyPhoneFromSignIn()),
        );
      } else if (Provider.of<Auth>(context, listen: false).isVerified &&
          Provider.of<Auth>(context, listen: false).isAuth &&
          !enabledBio) {
        //  enable bio page
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => EnableBiometrics()));
      } else if (Provider.of<Auth>(context, listen: false).isVerified &&
          Provider.of<Auth>(context, listen: false).isAuth &&
          enabledBio &&
          Provider.of<Auth>(context, listen: false).pin == "") {
        // set pin page
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SetPin()));
      }

      // else if (Provider.of<Auth>(context, listen: false).isVerified &&
      //     Provider.of<Auth>(context, listen: false).isAuth &&
      //     enabledBio &&
      //     Provider.of<Auth>(context, listen: false).pin != "" &&
      //     Provider.of<Auth>(context, listen: false).profileSurveyShown !=
      //         true) {
      //   // set pin page
      //   Navigator.of(context)
      //       .push(MaterialPageRoute(builder: (context) => IntroSurveyPage()));
      // }

      else if (Provider.of<Auth>(context, listen: false).isAuth &&
          Provider.of<Auth>(context, listen: false).isVerified &&
          enabledBio &&
          Provider.of<Auth>(context, listen: false).pin != "") {
        print("authenticated");
        print("push to dashboard replacement");
        Navigator.pushNamedAndRemoveUntil(
          context,
          Dashboard.id,
          (route) => false,
        );
      } else {
        print("not authenticated");

        final result = await Connectivity().checkConnectivity();
        final hasInternet = showConnectivitySnackBar(result);

        // if (hasInternet) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          OnBoarding.id,
          (route) => false,
        );
        // }
      }
    } catch (e) {
      print(e);
      print("not authenticated");
      final result = await Connectivity().checkConnectivity();

      final hasInternet = showConnectivitySnackBar(result);

      if (hasInternet) {
        Navigator.pushNamedAndRemoveUntil(
            context, OnBoarding.id, (route) => false);
      }

      // Navigator.pushNamedAndRemoveUntil(context, SignUp.id, (route) => false);
      // handle error case by showing snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2386fe),
      body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: const Image(
                  height: 300,
                  image: AssetImage('images/logo.png'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // GestureDetector(
              //   onTap: () {
              //     // _tryAutoLogin();
              //   },
              //   child: Icon(Icons.refresh),
              // )
              // Image.asset("assets/images/process_loader.gif"),
            ],
          )),
    );
  }
}
