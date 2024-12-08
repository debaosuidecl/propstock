import 'package:flutter/material.dart';
import 'package:propstock/models/country.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ModalSheet extends StatefulWidget {
  const ModalSheet({super.key});

  @override
  State<ModalSheet> createState() => _ModalSheetState();
}

class _ModalSheetState extends State<ModalSheet> {
  List<Country> _countries = [];
  List<Country> _variableCountries = [];
  bool _loading = true;
  String _selectedCountry = "";
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();

    _initializeSelect();
  }

  Future<void> _initializeSelect() async {
    try {
      _countries = await _getCountriesData();
      print(_countries);
      setState(() {
        _variableCountries = _countries;
        _loading = false;
      });
    } catch (e) {
      print(e);
      showErrorDialog("Could not load Country Data", context);
    }
  }

  Future<List<Country>> _getCountriesData() async {
    final response =
        await http.get(Uri.parse('https://restcountries.com/v2/all'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((country) {
        String name = "";
        String flagUrl = "";
        String currency = "";
        String code = "";
        try {
          name = country['name'];
          code = country['callingCodes'][0];
          flagUrl = country['flags']['png'];
          currency = country["currencies"]![0]!["code"].toString();
        } catch (e) {
          print(e);
          print(country);
          print(" only once here ");
        }

        return Country(
          flag: flagUrl,
          name: name,
          currency: currency,
          code: code,
        );
      }).toList();
    } else {
      throw Exception('Failed to load countries');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
            height:
                MediaQuery.of(context).size.height, // Use full screen height
            // decoration: BoxDecoration(
            //     // borderRadius: BorderRadius.circular(20),
            //     ),
            color: Colors.white,
            child: Column(
              children: [
                // header container
                const SizedBox(
                  height: 40,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  decoration: const BoxDecoration(
                      color: Color(0xff2186fe),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Row(children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Image(
                        image: AssetImage("images/close_icon_white.png"),
                        height: 35,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .7,
                      alignment: Alignment.center,
                      // color: Colors.green,
                      child: const Text(
                        "Select your location",
                        style: TextStyle(
                          color: Color(0xffffffff),
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    )
                  ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: _textEditingController,
                    onChanged: (String val) {
                      print(val);
                      setState(() {
                        _variableCountries = _countries
                            .where((country) => country.name
                                .toLowerCase()
                                .contains(val.toLowerCase()))
                            .toList();
                      });
                      print(_variableCountries);
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.all(0),
                      hintText: 'Search country',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFFCBDFF7)), // Use the hex color
                        borderRadius: BorderRadius.circular(
                            8), // You can adjust the border radius as needed
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_loading)
                  CircularProgressIndicator()
                else
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.builder(
                        itemCount: _variableCountries.length,
                        itemBuilder: (context, index) {
                          final countryData = _variableCountries[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 10, top: 10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  color: _selectedCountry != countryData.name
                                      ? Color(0xffeeeeee)
                                      : Color(0xff2286FE),
                                )),
                            child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  _selectedCountry = countryData.name;
                                  Provider.of<PropertyProvider>(context,
                                          listen: false)
                                      .setCurrency(
                                          countryData.currency.toString());
                                  Provider.of<Auth>(context, listen: false)
                                      .setCurrency(
                                          countryData.currency.toString());
                                });
                                Provider.of<Auth>(context, listen: false)
                                    .setCountry(countryData);
                                Provider.of<Auth>(context, listen: false)
                                    .setCountryString(countryData.name);
                                print("getting state by country");
                                try {
                                  await Provider.of<Auth>(context,
                                          listen: false)
                                      .getStatesByCountry(countryData.name);
                                  print("gotten state by country");
                                } catch (e) {
                                  print(e);
                                }
                                Navigator.of(context).pop();
                              },
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
                                    countryData.flag,
                                    height: 390,
                                    // width: 50,
                                  ),
                                ),
                                title: Text(countryData.name),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
              ],
            )),
      ),
    );
    ;
  }
}
