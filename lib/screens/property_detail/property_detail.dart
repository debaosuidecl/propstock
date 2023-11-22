import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/property_detail/property_detail.analytics.dart';
// import 'package:propstock/screens/property_detail.overview.dart';
import 'package:propstock/screens/property_detail/property_detail.overview.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class PropertyDetail extends StatefulWidget {
  static const id = "PropertyDetail";
  const PropertyDetail({super.key});

  @override
  State<PropertyDetail> createState() => _PropertyDetailState();
}

class _PropertyDetailState extends State<PropertyDetail> {
  String property_id = "";
  bool _loading = true;
  int _page = 0;

  Property? _property;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initPropertyState();
  }

  Future<void> _initPropertyState() async {
    try {
      setState(() {
        _property = Provider.of<PropertyProvider>(context, listen: false)
            .selectedProperty;

        _loading = true;
      });
    } catch (e) {
      showErrorDialog(e.toString(), context);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: _loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SvgPicture.asset(
                              "images/back_arrow.svg",
                              height: 32,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .6,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 18.0,
                            ),
                            child: Text(
                              _property!.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Inter",
                                color: Color(0xff011936),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 18.0,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset("images/ShareNetwork.svg"),
                                SizedBox(
                                  width: 4,
                                ),
                                Container(
                                  height: 40,
                                  width: 40,
                                  padding: EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xffeeeeee),
                                        blurRadius: 3,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: SvgPicture.asset("images/Heart.svg"),
                                ),
                              ],
                            ),
                          )
                        ]),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xffFAFAFA),
                        borderRadius: const BorderRadius.all(Radius.circular(
                          8,
                        )),
                        border: Border.all(
                          color: const Color(0xff999999).withOpacity(.1),
                          width: 3,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xffA4BAD410),
                            spreadRadius:
                                -10.0, // Negative spread radius creates inner shadow
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _page = 0;
                                });
                              },
                              child: Container(
                                  height: 48,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 10,
                                  ),
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: _page == 0 ? Colors.white : null,
                                      border: _page == 0
                                          ? Border.all(
                                              color: Color(0xffeeeeee),
                                              width: 1,
                                            )
                                          : null,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(
                                        10,
                                      ))),
                                  child: Text(
                                    "Overview",
                                    style: TextStyle(
                                      color:
                                          _page == 0 ? Color(0xff2286FE) : null,
                                      fontFamily: "Inter",
                                    ),
                                  )),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _page = 1;
                                });
                              },
                              child: Container(
                                  height: 48,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 10,
                                  ),
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    // color: Colors.white
                                    color: _page == 1 ? Colors.white : null,
                                    border: _page == 1
                                        ? Border.all(
                                            color: Color(0xffeeeeee),
                                            width: 1,
                                          )
                                        : null,
                                  ),
                                  child: Text(
                                    "Analytics",
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      color:
                                          _page == 1 ? Color(0xff2286FE) : null,
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    if (_page == 0)
                      Expanded(
                          child: PropertyDetailOverview(property: _property)),
                    if (_page == 1)
                      Expanded(
                          child: PropertyDetailAnalytics(property: _property))
                  ],
                ),
        ),
      ),
    );
  }
}
