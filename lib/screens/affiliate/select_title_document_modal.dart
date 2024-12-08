import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/country.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/providers/listings.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SelectTitleDocumentModal extends StatefulWidget {
  const SelectTitleDocumentModal({super.key});

  @override
  State<SelectTitleDocumentModal> createState() =>
      _SelectTitleDocumentModalState();
}

class _SelectTitleDocumentModalState extends State<SelectTitleDocumentModal> {
  final List<String> _titleDocuments = [
    "Survey of Plan",
    "Certification of Occupancy (C of O)",
    "Governor's Consent",
    "Building Plan Approval",
    "Deed of Assignment",
    "Land Purchase Reciept",
    "Title Deed",
    "Deed of Sublease",
    "Deed of Mortgage",
    "Right of Occupancy (R of O)",
  ];
  List<String> _VARIABLETITLEDOCUMENTS = [
    "Survey of Plan",
    "Certification of Occupancy (C of O)",
    "Governor's Consent",
    "Building Plan Approval",
    "Deed of Assignment",
    "Land Purchase Reciept",
    "Title Deed",
    "Deed of Sublease",
    "Deed of Mortgage",
    "Right of Occupancy (R of O)",
  ];
  List<String> _selectedTitleDocument = [];
  bool _loading = true;
  String _selectedHouseFeature = "";
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();

    _initializeSelect();
  }

  Future<void> _initializeSelect() async {
    try {
      // _titleDocuments = await _getCountriesData();
      print(_titleDocuments);
      setState(() {
        _VARIABLETITLEDOCUMENTS = _titleDocuments;
        _loading = false;
      });
    } catch (e) {
      print(e);
      showErrorDialog("Could not load Country Data", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<ListingsProvider>(context, listen: false)
              .setTitleDocuments(_selectedTitleDocument);
          Navigator.pop(context);
          // Provider.of
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
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
                          "Select House Features",
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
                          _VARIABLETITLEDOCUMENTS = _titleDocuments
                              .where((feature) => feature
                                  .toLowerCase()
                                  .contains(val.toLowerCase()))
                              .toList();
                        });
                        print(_VARIABLETITLEDOCUMENTS);
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.all(0),
                        hintText: 'Search title documents',
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
                          itemCount: _VARIABLETITLEDOCUMENTS.length,
                          itemBuilder: (context, index) {
                            final titledocdata = _VARIABLETITLEDOCUMENTS[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              margin:
                                  const EdgeInsets.only(bottom: 10, top: 10),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                    color: Color(0xffeeeeee),
                                  )),
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    // _selectedHouseFeature = titledocdata;
                                    if (_selectedTitleDocument
                                        .contains(titledocdata)) {
                                      _selectedTitleDocument
                                          .remove(titledocdata);
                                    } else {
                                      _selectedTitleDocument.add(titledocdata);
                                    }
                                    // Provider.of<PropertyProvider>(context,
                                    //         listen: false)
                                    //     .setCurrency(
                                    //         titledocdata.currency.toString());
                                    // Provider.of<Auth>(context, listen: false)
                                    //     .setCurrency(
                                    //         titledocdata.currency.toString());
                                  });

                                  // Navigator.of(context).pop();
                                },
                                child: ListTile(
                                  leading: _selectedTitleDocument
                                          .contains(titledocdata)
                                      ? Container(
                                          height: 18,
                                          width: 18,
                                          margin: EdgeInsets.only(
                                            top: 2.8,
                                          ),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: MyColors.primary,
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 13,
                                          ),
                                        )
                                      : Container(
                                          height: 18,
                                          width: 18,
                                          margin: EdgeInsets.only(
                                            top: 2.8,
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                  color: Color(0xffB9C0CA))),
                                        ),
                                  title: Text(
                                    titledocdata,
                                    style: TextStyle(
                                        color: _selectedTitleDocument
                                                .contains(titledocdata)
                                            ? MyColors.primary
                                            : Color(0xff5E6D85)),
                                  ),
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
      ),
    );
  }
}
