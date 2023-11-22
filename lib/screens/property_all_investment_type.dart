import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/providers/property.dart';
// import 'package:propstock/screens/property_detail.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/invest_card.dart';
import 'package:propstock/widgets/invest_header.dart';
import 'package:provider/provider.dart';

class PropertyAllInvestmentType extends StatefulWidget {
  static const id = "PropertyAllInvestmentType";
  // String title;
  PropertyAllInvestmentType({super.key});

  @override
  State<PropertyAllInvestmentType> createState() =>
      _PropertyAllInvestmentTypeState();
}

class _PropertyAllInvestmentTypeState extends State<PropertyAllInvestmentType> {
  String _investmentType = "";
  bool _loading = true;
  bool _loadingMore = false;
  bool _thereIsMoreText = true;
  int _page = 0;

  List<Property> _properties = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getInitValues();
  }

  Future<void> _getInitValues() async {
    try {
      setState(() {
        setState(() {
          _loadingMore = true;
        });
        _investmentType = Provider.of<PropertyProvider>(context, listen: false)
            .selectedInvestmentType;
      });
      await Provider.of<PropertyProvider>(context, listen: false)
          .fetchSeeAllProperty(1, _page);

      setState(() {
        _properties = _properties +
            Provider.of<PropertyProvider>(context, listen: false)
                .seeAllProperties;
        _page = _page + 1;

        if (Provider.of<PropertyProvider>(context, listen: false)
                .seeAllProperties
                .length <=
            0) {
          _thereIsMoreText = false;
        }
      });
    } catch (e) {
      print(e);
      showErrorDialog(e.toString(), context);
    } finally {
      setState(() {
        _loading = false;
        _loadingMore = false;
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
          child: Column(children: [
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 18.0,
                ),
                child: Text(
                  _investmentType,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Inter",
                    color: Color(0xff011936),
                  ),
                ),
              ),
            ]),
            if (_loading)
              Center(
                child: CircularProgressIndicator(),
              ),
            if (!_loading)
              Expanded(
                  child: SingleChildScrollView(
                child: Column(children: [
                  SizedBox(
                    height: 20,
                  ),
                  if (_investmentType == "Recommended")
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                          "These properties are being recommended based on your preferences. You can adjust preferences from your profile."),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _properties.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InvestCard(
                            property: _properties[index],
                          );
                        }),
                  ),
                  if (_loadingMore) CircularProgressIndicator(),
                  GestureDetector(
                    onTap: () {
                      _getInitValues();
                    },
                    child: Container(
                      child: _thereIsMoreText
                          ? Text(
                              "See more",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 16,
                                  fontFamily: "Inter"),
                            )
                          : Container(
                              height: 5,
                              width: 5,
                              decoration: BoxDecoration(
                                color: Color(0xffbbbbbb),
                                shape: BoxShape.circle,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ]),
              ))
          ]),
        ),
      ),
    );
  }
}
