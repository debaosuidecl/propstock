import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/providers/investments.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/circular_card.dart';
import 'package:propstock/widgets/single_investment_card.dart';
import 'package:provider/provider.dart';

class Investments extends StatefulWidget {
  const Investments({super.key});
  static const id = "investments";

  @override
  State<Investments> createState() => _InvestmentsState();
}

class _InvestmentsState extends State<Investments> {
  bool _loading = true;
  bool _loadingNext = false;
  String filter = "all";
  int _page = 0;
  final int _limit = 10;
  Timer? _debounceTimer;
  String _currentQuery = '';
  bool showSeeMore = true;
  TextEditingController _controller = TextEditingController();
  List<UserInvestment> _userInvestments = [];
  bool showingSearch = false;

  @override
  initState() {
    super.initState();

    _searchInvestments("all");
  }

  Future<void> _searchInvestments(String searchCriteria,
      {String? propSearch}) async {
    try {
      setState(() {
        filter = searchCriteria;
      });
      final List<UserInvestment> userInvestments =
          await Provider.of<InvestmentsProvider>(context, listen: false)
              .fetchInvestments(
        searchCriteria,
        _page,
        _limit,
        propSearch: propSearch,
      );

      setState(() {
        if (userInvestments.isEmpty) {
          showSeeMore = false;
        }
        _userInvestments = _userInvestments + userInvestments;
      });
    } catch (e) {
      showErrorDialog(e.toString(), context);
    } finally {
      setState(() {
        _loading = false;
        _loadingNext = false;
      });
    }
  }

  void _onSearchTextChanged(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_currentQuery != query) {
        setState(() {
          _currentQuery = query;
          _page = 0;
          _loading = true;
          _userInvestments = [];
        });
        // _fetchFriends(query);
        _searchInvestments(filter, propSearch: query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("fval $filter");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                "images/Frame.svg",
                height: 15,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          )),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height * .9,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Investments",
                    style: TextStyle(
                      color: MyColors.secondary,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          showingSearch = !showingSearch;
                          _controller.clear();
                        });
                      },
                      child: showingSearch
                          ? SvgPicture.asset("images/close_icon.svg")
                          : SvgPicture.asset("images/MagnifyingGlass.svg"))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _page = 0;
                        _loading = true;
                        _userInvestments = [];
                      });
                      _searchInvestments("all");
                    },
                    child: CircularCard(
                      selected: filter == "all" ? true : false,
                      title: "All",
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _page = 0;
                        _loading = true;
                        _userInvestments = [];
                      });
                      _searchInvestments("active");
                    },
                    child: CircularCard(
                      selected: filter == "active",
                      title: "Active",
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _page = 0;
                        _loading = true;
                        _userInvestments = [];
                      });

                      _searchInvestments("mature");
                    },
                    child: CircularCard(
                      selected: filter == "mature",
                      title: "Mature",
                    ),
                  ),
                ],
              ),
              if (showingSearch)
                SizedBox(
                  height: 20,
                ),
              if (showingSearch)
                TextField(
                  controller: _controller,
                  // focusNode: _focus,
                  onChanged: (String value) {
                    _onSearchTextChanged(value);
                  },

                  // keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    // prefixIcon: Icon(Icons.search),
                    prefixIcon: Icon(
                      Icons.search,
                    ),

                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    label: Text('Search property',
                        style: TextStyle(fontFamily: "Inter")),
                    hintStyle: TextStyle(color: Color(0xffbbbbbb)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: MyColors.fieldDefault,
                      ), // Use the hex color
                      borderRadius: BorderRadius.circular(
                          8), // You can adjust the border radius as needed
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: MyColors.fieldDefault,
                      ), // Use the hex color
                      borderRadius: BorderRadius.circular(
                          8), // You can adjust the border radius as needed
                    ),
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              if (_loading) CircularProgressIndicator(),
              if (!_loading && _userInvestments.isEmpty)
                Center(
                  child: Text("No investments found"),
                ),
              Expanded(
                child: ListView.builder(
                    itemCount: _userInvestments.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext ctx, index) {
                      UserInvestment inv = _userInvestments[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SingleInvestmentCard(
                              property: inv.property, investment: inv),
                          if (index == _userInvestments.length - 1 &&
                              showSeeMore)
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _page = _page + 1;
                                      _loadingNext = true;
                                    });
                                    _searchInvestments(filter);
                                  },
                                  child: Text(
                                    "see more",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: MyColors.primary,
                                    ),
                                  ),
                                ),
                                if (!showSeeMore)
                                  Text(
                                    ".",
                                    textAlign: TextAlign.center,
                                  ),
                                if (_loadingNext) CircularProgressIndicator(),
                                SizedBox(
                                  height: 40,
                                )
                              ],
                            )
                        ],
                      );
                    }),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
