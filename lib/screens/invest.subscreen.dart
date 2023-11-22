import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/property_all_investment_type.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/error_resource.dart';
import 'package:propstock/widgets/invest_card.dart';
import 'package:propstock/widgets/invest_header.dart';
import 'package:provider/provider.dart';

class InvestSubscreen extends StatefulWidget {
  const InvestSubscreen({super.key});

  @override
  State<InvestSubscreen> createState() => _InvestSubscreenState();
}

class _InvestSubscreenState extends State<InvestSubscreen> {
  bool _loading = true;
  bool _error = false;
  List<Property> _recommendedProperties = [];
  List<Property>? _rentalIncomeInvestments = [];
  List<Property>? _contractInvestments = [];
  List<Property>? _buyToResell = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPropertyFetch();
  }

  Future<void> _initPropertyFetch() async {
    try {
      await Future.wait([
        Provider.of<PropertyProvider>(context, listen: false).getRecommended(),
        Provider.of<PropertyProvider>(context, listen: false)
            .queryProperty("Rental Income"),
        Provider.of<PropertyProvider>(context, listen: false)
            .queryProperty("Contract Investment"),
        Provider.of<PropertyProvider>(context, listen: false)
            .queryProperty("Buy to Resell"),
      ]);

      final List<Property> recommended =
          Provider.of<PropertyProvider>(context, listen: false).recommended;
      final List<Property>? rentalIncome =
          Provider.of<PropertyProvider>(context, listen: false)
              .allPropList["Rental Income"];
      final List<Property>? contractInvestment =
          Provider.of<PropertyProvider>(context, listen: false)
              .allPropList["Contract Investment"];
      final List<Property>? buyToResell =
          Provider.of<PropertyProvider>(context, listen: false)
              .allPropList["Buy to Resell"];

      setState(() {
        _recommendedProperties = recommended;
        _contractInvestments = contractInvestment;
        _buyToResell = buyToResell;
        _error = false;
      });
    } catch (e) {
      print(e);

      showErrorDialog("Could not fetch properties", context);
      setState(() {
        _error = true;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .7,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: _loading
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            )
          : _error
              ? Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: ErrorResource(
                      message:
                          "Could not fetch properties. No worries :). Click on the refresh icon to try again",
                      onRefresh: () {
                        setState(() {
                          _loading = true;
                        });
                        _initPropertyFetch();
                      }),
                )
              : SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        if (!Provider.of<PropertyProvider>(context,
                                listen: true)
                            .filterMode)
                          Column(
                            children: [
                              if (_recommendedProperties.length > 0)
                                Column(
                                  children: [
                                    InvestHeader(
                                      title: "Recommended",
                                      seeAll: () {
                                        Provider.of<PropertyProvider>(context,
                                                listen: false)
                                            .setInvestmentType("Recommended");
                                        Navigator.pushNamed(context,
                                            PropertyAllInvestmentType.id);
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:
                                            _recommendedProperties.length,
                                        itemBuilder: (context, index) {
                                          return InvestCard(
                                            property:
                                                _recommendedProperties[index],
                                          );
                                        }),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                  ],
                                ),
                              if (_rentalIncomeInvestments!.length > 0)
                                Column(
                                  children: [
                                    InvestHeader(
                                      title: "Rental Income Investments",
                                      seeAll: () {
                                        Provider.of<PropertyProvider>(context,
                                                listen: false)
                                            .setInvestmentType("Rental Income");
                                        Navigator.pushNamed(context,
                                            PropertyAllInvestmentType.id);
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            _rentalIncomeInvestments!.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return InvestCard(
                                            property: _rentalIncomeInvestments![
                                                index],
                                          );
                                        }),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                  ],
                                ),
                              if (_contractInvestments!.length > 0)
                                Column(
                                  children: [
                                    InvestHeader(
                                      title: "Contract Investments",
                                      seeAll: () {
                                        Provider.of<PropertyProvider>(context,
                                                listen: false)
                                            .setInvestmentType(
                                                "Contract Investment");
                                        Navigator.pushNamed(context,
                                            PropertyAllInvestmentType.id);
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .5),
                                      // color: Colors.green,
                                      child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              _contractInvestments!.length,
                                          itemBuilder: (context, index) {
                                            return InvestCard(
                                              property:
                                                  _contractInvestments![index],
                                            );
                                          }),
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                  ],
                                ),
                              if (_buyToResell!.length > 0)
                                Column(
                                  children: [
                                    InvestHeader(
                                      title: "Buy to Resell",
                                      seeAll: () {
                                        Provider.of<PropertyProvider>(context,
                                                listen: false)
                                            .setInvestmentType("Buy to Resell");
                                        Navigator.pushNamed(context,
                                            PropertyAllInvestmentType.id);
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .5),
                                      // color: Colors.green,
                                      child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: _buyToResell!.length,
                                          itemBuilder: (context, index) {
                                            return InvestCard(
                                              property: _buyToResell![index],
                                            );
                                          }),
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                  ],
                                ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Filter Mode",
                                        style: TextStyle(
                                            color: Color(0xff1D3354),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            fontFamily: "Inter"),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: SvgPicture.asset(
                                          "images/FunnelSimple.svg",
                                          height: 24,
                                          semanticsLabel: 'Acme Logo',
                                        ),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Provider.of<PropertyProvider>(context,
                                              listen: false)
                                          .clearFilter();
                                    },
                                    child: Text(
                                      "Clear Filter",
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              InvestHeader(
                                title: "Filtered Results",
                                seeAll: () {
                                  Provider.of<PropertyProvider>(context,
                                          listen: false)
                                      .setInvestmentType("Filtered Results");
                                  Navigator.pushNamed(
                                      context, PropertyAllInvestmentType.id);
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: Provider.of<PropertyProvider>(
                                          context,
                                          listen: true)
                                      .filteredProperties
                                      .length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return InvestCard(
                                      property: Provider.of<PropertyProvider>(
                                              context,
                                              listen: true)
                                          .filteredProperties[index],
                                    );
                                  }),
                              const SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                      ]),
                ),
    );
  }
}
