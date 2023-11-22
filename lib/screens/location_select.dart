import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:propstock/models/country.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/modal_sheet.dart';
import 'package:propstock/screens/signup.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class LocationSelect extends StatefulWidget {
  static const id = "location_select";
  const LocationSelect({super.key});

  @override
  State<LocationSelect> createState() => _LocationSelectState();
}

class _LocationSelectState extends State<LocationSelect> {
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
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Image(
                          height: 32,
                          image: AssetImage('images/close_icon.png'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Select your location",
                    style: TextStyle(
                        color: Color(0xff1D3354),
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                        fontSize: 30),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  const Text(
                    "Choose the country where you live presently",
                    style: TextStyle(
                        color: Color(0xff5E6D85),
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w100,
                        fontSize: 15),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      // bring out modal bottomsheet
                      _showModalBottomSheet(context);
                    },
                    child: Provider.of<Auth>(context, listen: true)
                                .country!
                                .name !=
                            ""
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 10, top: 10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  color: Color(0xff2286FE),
                                )),
                            child: GestureDetector(
                              onTap: () {},
                              child: ListTile(
                                leading: Container(
                                  clipBehavior: Clip.hardEdge,
                                  height: 50,
                                  width: 50,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    // color: Colors.green,
                                  ),
                                  child: Image.network(
                                    fit: BoxFit.fitHeight,
                                    Provider.of<Auth>(context, listen: false)
                                        .country!
                                        .flag,
                                    height: 390,
                                    // width: 50,
                                  ),
                                ),
                                title: Text(
                                    Provider.of<Auth>(context, listen: false)
                                        .country!
                                        .name),
                                trailing: GestureDetector(
                                  onTap: () {
                                    _showModalBottomSheet(context);
                                  },
                                  child: Text(
                                    "Change",
                                    style: TextStyle(
                                      color: Color(0xff2286FE),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xffeeeeee), width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              title: Text(
                                "Search Country",
                                style: TextStyle(
                                  color: Color(0xff5E6D85),
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w100,
                                  fontSize: 12,
                                ),

                                // style: TextStyle(),
                              ),
                              trailing: Image(
                                  image: AssetImage("images/dropdownIcon.png")),
                            ),
                          ),
                  )
                ],
              ),
            ),
            Container(
              // height: MediaQuery.of(context).size.height * .1,
              width: double.infinity,
              child: ElevatedButton(
                child: Text(
                  "Continue",
                  style: TextStyle(
                    color: Color(0xffffffff),
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w100,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 17,
                    ),
                    elevation: 0,
                    backgroundColor: Provider.of<Auth>(context, listen: true)
                                .country!
                                .name !=
                            ""
                        ? Color(0xff2286FE)
                        : Color(0xffbbbbbb)),
                onPressed: () {
                  print("continue");
                  if (Provider.of<Auth>(context, listen: false).country!.name !=
                      "") {
                    Navigator.pushNamed(context, SignUp.id);
                  }
                },
              ),
            )
          ],
        ),
      )),
    );
  }
}
