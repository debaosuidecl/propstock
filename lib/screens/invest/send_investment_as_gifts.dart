import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class SendInvestmentAsGift extends StatefulWidget {
  static const id = "send_investment_as_gift";

  const SendInvestmentAsGift({super.key});

  @override
  State<SendInvestmentAsGift> createState() => _SendInvestmentAsGiftState();
}

class _SendInvestmentAsGiftState extends State<SendInvestmentAsGift> {
  TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;
  String _currentQuery = '';
  bool _loading = false;

  List<User> _users = [];

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
        _users = users;
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
        setState(() {
          _currentQuery = query;
        });
        _fetchFriends(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          "Send as Gift",
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Who do you want to give this investment?",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: MyColors.primaryDark,
                  ),
                ),
                SizedBox(
                  height: 50,
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
                if (_loading) LinearProgressIndicator(),
                Expanded(
                  child: ListView.builder(
                      itemCount: _users.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext ctx, int index) {
                        User user = _users[index];
                        return GestureDetector(
                          onTap: () {
                            // set selected friend to gift
                            Provider.of<PropertyProvider>(context,
                                    listen: false)
                                .setFriendAsGift(user);
                            Navigator.pop(context, user);
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
                            // leading: CircleAvatar(
                            //   backgroundColor: MyColors.neutralGrey,
                            //   child: Icon(
                            //     Icons.person_2_sharp,
                            //     color: Color(0xffeeeeeee),
                            //   ),
                            // ),
                            trailing: Icon(Icons.info_outline_rounded),
                          ),
                        );
                      }),
                ),
                if (_users.isEmpty)
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
                        Text(
                            "Add the person you’d like to gift this investment ",
                            style: TextStyle(
                              color: MyColors.neutralGrey,
                            ))
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
