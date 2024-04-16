import 'package:flutter/material.dart';
// import 'package:propstock/models/country.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/utils/showErrorDialog.dart';
// import 'dart:convert';

// import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class StateModalSelect extends StatefulWidget {
  StateModalSelect({
    super.key,
  });

  @override
  State<StateModalSelect> createState() => _StateModalSelectState();
}

class _StateModalSelectState extends State<StateModalSelect> {
  // List<String> _countries = widget.states;
  List<dynamic> _variableStates = [];
  List<dynamic> _constantStates = [];
  String _selectedState = "";
  // bool _loading = true;
  // String _selectedCountry = "";
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();

    _initializeSelect();
  }

  Future<void> _initializeSelect() async {
    try {
      setState(() {
        _variableStates =
            Provider.of<Auth>(context, listen: false).dynamicStateList;
        _constantStates =
            Provider.of<Auth>(context, listen: false).dynamicStateList;
      });
    } catch (e) {
      print(e);
      showErrorDialog("Could not load State Data", context);
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
                        _variableStates = _constantStates
                            .where((state) =>
                                state.toLowerCase().contains(val.toLowerCase()))
                            .toList();
                      });
                      print(_variableStates);
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.all(0),
                      hintText: 'Search states',
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
                if (_variableStates.length == 0)
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        "No Country Selected. Ensure you have selected a valid country"),
                  )
                else
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.builder(
                        itemCount: _variableStates.length,
                        itemBuilder: (context, index) {
                          final stateData = _variableStates[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 10, top: 10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  color: _selectedState != stateData
                                      ? Color(0xffeeeeee)
                                      : Color(0xff2286FE),
                                )),
                            child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  _selectedState = _variableStates[index];
                                });
                                Provider.of<Auth>(context, listen: false)
                                    .setStateOfCountry(_selectedState);

                                Navigator.of(context).pop();
                              },
                              child: ListTile(
                                title: Text(stateData),
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
