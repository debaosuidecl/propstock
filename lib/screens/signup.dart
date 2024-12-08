import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/email_code_verify.dart';
import 'package:propstock/screens/location_select.dart';
import 'package:propstock/screens/modal_sheet.dart';
import 'package:propstock/screens/onboarding.dart';
import 'package:propstock/screens/sign_in_with_password.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  static const id = "signup";
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String firstName = "";
  String lastName = "";
  String emailAddress = "";
  String password = "";
  String phoneNumber = "";
  bool? _isChecked = false;
  bool obscuringText = true;
  bool _loading = false;

  bool _canCreateAccount() {
    if (_loading) {
      return false;
    }
    if (firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        emailAddress.isNotEmpty &&
        password.isNotEmpty &&
        _isChecked == true) {
      return true;
    }
    return false;
  }

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      showErrorDialog("Cannot launch $url", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    void _showModalBottomSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext contextb) {
          return ModalSheet();
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xff1D3354),
          ),
          onPressed: () {
            // Navigate back to the previous screen when the back button is pressed
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .78,
                // color: Colors.green,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Create an account",
                        style: TextStyle(
                            color: Color(0xff1D3354),
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                            fontSize: 30),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Fill the necessary details",
                        style: TextStyle(
                          color: Color(0xff5E6D85),
                          // height: 25.6,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w100,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextField(
                        controller: _firstNameController,
                        onChanged: (String val) {
                          setState(() {
                            firstName = val;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          label: Text('First Name'),
                          hintStyle: TextStyle(color: Color(0xffbbbbbb)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xffCBDFF7),
                            ), // Use the hex color
                            borderRadius: BorderRadius.circular(
                                8), // You can adjust the border radius as needed
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _lastNameController,
                        onChanged: (String val) {
                          setState(() {
                            lastName = val;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          label: Text('Last Name'),
                          hintStyle: TextStyle(color: Color(0xffbbbbbb)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xffCBDFF7),
                            ), // Use the hex color
                            borderRadius: BorderRadius.circular(
                                8), // You can adjust the border radius as needed
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigator.pushNamed(context, LocationSelect.id);
                              _showModalBottomSheet(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * .29,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xffCBDFF7),
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  if (Provider.of<Auth>(context)
                                      .country!
                                      .flag
                                      .isNotEmpty)
                                    CircleAvatar(
                                        radius: 15,
                                        backgroundImage: NetworkImage(
                                            Provider.of<Auth>(context)
                                                .country!
                                                .flag)),
                                  Expanded(
                                    child: TextField(
                                      // controller: _emailController,
                                      onChanged: (String val) {
                                        setState(() {
                                          // phoneNumber = val;
                                        });
                                      },
                                      enabled: false,
                                      decoration: InputDecoration(
                                        // suffixIcon: SvgPicture.asset(
                                        //   "images/down1.svg",
                                        //   height: 1,
                                        // ),

                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 0),
                                        label: Provider.of<Auth>(context)
                                                .country!
                                                .flag
                                                .isEmpty
                                            ? Text('code')
                                            : Text(Provider.of<Auth>(context)
                                                .country!
                                                .code!),
                                        hintStyle:
                                            TextStyle(color: Color(0xffbbbbbb)),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SvgPicture.asset("images/down1.svg"),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            // child: ,
                            width: MediaQuery.of(context).size.width * .65,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffCBDFF7)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),

                            child: TextField(
                              controller: _phoneController,
                              onChanged: (String val) {
                                setState(() {
                                  phoneNumber = val;
                                });
                              },
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                // suffixIcon: SvgPicture.asset(
                                //   "images/down1.svg",
                                //   height: 1,
                                // ),

                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                label: Text('Phone Number'),
                                hintStyle: TextStyle(color: Color(0xffbbbbbb)),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _emailController,
                        onChanged: (String val) {
                          setState(() {
                            emailAddress = val;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          label: Text('Email Address'),
                          hintStyle: TextStyle(color: Color(0xffbbbbbb)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xffCBDFF7),
                            ), // Use the hex color
                            borderRadius: BorderRadius.circular(
                                8), // You can adjust the border radius as needed
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _passwordController,
                        obscureText: obscuringText,
                        onChanged: (String val) {
                          setState(() {
                            password = val;
                          });
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscuringText = !obscuringText;
                              });
                            },
                            child: obscuringText
                                ? Icon(Icons.remove_red_eye)
                                : Icon(Icons.remove_red_eye_outlined),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          label: Text('Password'),
                          hintStyle: TextStyle(color: Color(0xffbbbbbb)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xffCBDFF7),
                            ), // Use the hex color
                            borderRadius: BorderRadius.circular(
                                8), // You can adjust the border radius as needed
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _isChecked,
                                // 278382
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    _isChecked = newValue;
                                  });
                                },
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * .7,
                                child: RichText(
                                  text: TextSpan(
                                    text: 'By continuing, you agree to our',
                                    style: const TextStyle(
                                        fontSize: 15, color: Color(0xffbbbbbb)),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: ' Terms of Service',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            _launchURL(
                                                'https://www.example.com/terms');
                                          },
                                      ),
                                      const TextSpan(
                                        text: ' and ',
                                        style: TextStyle(
                                          color: Color(0xffbbbbbb),
                                          fontSize: 15,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            _launchURL(
                                                'https://www.example.com/privacy');
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                      )
                    ]),
              ),
              if (_loading) LinearProgressIndicator(),
              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    // Navigator.pushNamed(context, LocationSelect.id);

                    try {
                      if (_loading) return;
                      setState(() {
                        _loading = true;
                      });
                      await Provider.of<Auth>(context, listen: false).signup(
                        firstName,
                        lastName,
                        emailAddress,
                        password,
                        Provider.of<Auth>(context, listen: false)
                            .country!
                            .code!,
                        phoneNumber,
                      );

                      print("done");

                      await Navigator.pushNamed(context, EmailCodeVerify.id);
                    } catch (e) {
                      showErrorDialog(e.toString(), context);
                    } finally {
                      setState(() {
                        _loading = false;
                      });
                    }
                  },
                  child: Text("Create Account"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _canCreateAccount()
                          ? Color(0xff2386fe)
                          : Color(0xffbbbbbb),
                      padding: EdgeInsets.all(15),
                      elevation: 0),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 3),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Already have an account?',
                    style: TextStyle(fontSize: 15, color: Color(0xffbbbbbb)),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' Sign In',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // _launchURL('https://www.example.com/terms');

                            // Navigator.pushNamed(context, SignInWithPassword.id);

                            Navigator.pushNamedAndRemoveUntil(
                                context, SignInWithPassword.id, (route) {
                              return route.settings.name == OnBoarding.id;
                            });
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
