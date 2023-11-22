import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/buy_property/co_buy_final_page.dart';
import 'package:propstock/screens/invest/buy_units_invest_page.dart';
import 'package:propstock/screens/invest/co_invest_final.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:propstock/widgets/selected_user.dart';
import 'package:provider/provider.dart';

class CoBuy extends StatefulWidget {
  static const id = "co_buy";

  const CoBuy({super.key});

  @override
  State<CoBuy> createState() => _CoBuyState();
}

class _CoBuyState extends State<CoBuy> {
  TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;
  String _currentQuery = '';
  bool _loading = false;

  List<User> _users = [];

  Map<String, User> _selectedUsers = {};

  Future<void> _fetchFriends(String query) async {
    try {
      setState(() {
        _loading = true;
      });
      List<User> users =
          await Provider.of<PropertyProvider>(context, listen: false)
              .fetchFriends(query);
      print(users);
      setState(() {
        _users = users
            .where((u) => !_selectedUsers.containsKey(u.userName))
            .toList();
      });
    } catch (e) {
      showErrorDialog(e.toString(), context);
    } finally {
      _loading = false;
    }
  }

  void _onSearchTextChanged(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_currentQuery != query) {
        _currentQuery = query;
        _fetchFriends(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Property property =
        ModalRoute.of(context)!.settings.arguments as Property;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: MyColors.primaryDark,
          ),
        ),
        title: Text(
          "Co-Buyers",
          style: TextStyle(
            color: MyColors.primaryDark,
            fontWeight: FontWeight.w600,
            fontFamily: "Inter",
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: MediaQuery.of(context).size.height * .85,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Add friends to co-buy ",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: MyColors.primaryDark,
                  ),
                ),
                if (_users.length > 0)
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _users = [];
                          });
                        },
                        child: Container(
                          // height: 20,
                          // width: 120,

                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(.4),
                              borderRadius: BorderRadius.all(Radius.circular(
                                15,
                              ))),
                          child: Text("Clear All x",
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _controller,
                  onChanged: (String value) {
                    _onSearchTextChanged(value);
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    label: Text('Find friends by name or username',
                        style: TextStyle(fontFamily: "Inter", fontSize: 12)),
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
                if (_loading) const LinearProgressIndicator(),
                if (_users.isEmpty && _selectedUsers.isEmpty)
                  Container(
                    // height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        SvgPicture.asset(
                          "images/plus_circle.svg",
                          height: 56,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Add the people you’d like to co-invest with ",
                            style: TextStyle(
                              color: MyColors.neutralGrey,
                            ))
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                      itemCount: _users.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext ctx, int index) {
                        User user = _users[index];
                        return GestureDetector(
                          onTap: () {
                            if (_selectedUsers.keys.length >= 4) {
                              showErrorDialog(
                                  "You can only add 4 co-buyers", context);
                              return;
                            } else {
                              setState(() {
                                _selectedUsers[user.userName] = user;

                                _users = _users
                                    .where((u) =>
                                        !_selectedUsers.containsKey(u.userName))
                                    .toList();
                              });
                            }

                            // Navigator.pop(context);
                          },
                          child: ListTile(
                            subtitle: Text(
                              "@${user.userName.split('@')[0]}",
                              style: TextStyle(
                                color: MyColors.neutralGrey,
                              ),
                            ),
                            title: Text(
                              "${user.firstName} ${user.lastName}",
                              style: TextStyle(
                                fontFamily: "Inter",
                                color: MyColors.neutralblack,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            leading: ClipOval(
                              child: CircleAvatar(
                                backgroundColor: MyColors.neutralGrey,
                                backgroundImage: NetworkImage("${user.avatar}"),
                              ),
                            ),
                            trailing: Icon(Icons.info_outline_rounded),
                          ),
                        );
                      }),
                ),
                if (_selectedUsers.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Wrap(
                        alignment: WrapAlignment.start,
                        children: _selectedUsers.keys
                            .map((String username) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SelectedUser(
                                      onTap: () {
                                        _selectedUsers.remove(username);
                                        setState(() {});
                                      },
                                      user: _selectedUsers[username]),
                                ))
                            .toList()),
                  ),
                PropStockButton(
                  text: "Continue",
                  disabled: _selectedUsers.isEmpty,
                  onPressed: () {
                    if (_selectedUsers.isEmpty || _selectedUsers.length > 4) {
                      return;
                    }
                    Provider.of<PropertyProvider>(context, listen: false)
                        .setCoInvestors(_selectedUsers.values.toList());

                    Navigator.pushNamed(
                      context,
                      CoBuyFinalPage.id,
                      arguments: property,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
