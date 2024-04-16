import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/dashboard.dart';
import 'package:propstock/screens/set_pin.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EnableBiometrics extends StatefulWidget {
  static const id = "enable_biometrics";
  const EnableBiometrics({super.key});

  @override
  State<EnableBiometrics> createState() => _EnableBiometricsState();
}

class _EnableBiometricsState extends State<EnableBiometrics> {
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) {
      print("is supported: $isSupported");
      setState(() {
        _supportState = isSupported;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: GestureDetector(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    // final enabledBio = prefs.containsKey('enabled_biometrics');
                    prefs.setString("enabled_biometrics", "skip");

                    if (Provider.of<Auth>(context, listen: false).pin == null) {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SetPin()));
                    } else {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Dashboard()));
                    }
                  },
                  child: Text("skip", style: TextStyle(color: Colors.blue))),
            )
          ],
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xff1D3354),
            ),
            onPressed: () {
              // Navigate back to the previous screen when the back button is pressed
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .8,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Enable Biometrics",
                            style: TextStyle(
                              color: Color(0xff1D3354),
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w600,
                              fontSize: 30,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Allow sign in into the app using your biometrics",
                            style: TextStyle(
                              color: Color(0xffbbbbbb),
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w200,
                              fontSize: 16,
                            ),
                          ),
                        ]),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.height,
                    // padding: EdgeInsets.all(0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        _authenticate();
                      },
                      child: Text("Enable"),
                    ),
                  )
                ]),
          ),
        ));
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    print("list of biometrics: $availableBiometrics");

    if (!mounted) return;
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: "let us authenticate you with your local method",
        options:
            const AuthenticationOptions(stickyAuth: true, biometricOnly: true),
      );
      print("Authenticated: $authenticated");

      if (authenticated) {
        final prefs = await SharedPreferences.getInstance();
        // final enabledBio = prefs.containsKey('enabled_biometrics');
        prefs.setString("enabled_biometrics", "true");
        // var token = prefs.getString("token");
        final extractedUserData =
            json.decode(prefs.getString('userData') as String)
                as Map<String, dynamic>;

        final token = extractedUserData["token"] as String;

        prefs.setString("biometrics_token", token);
        // prefs.setString("enabled_biometrics", "true");
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SetPin()));
      }
    } on PlatformException catch (e) {
      print(e);

      showErrorDialog(
          "Biometrics is not available for your device. please set that up before trying to enable",
          context);
    }
  }
}
