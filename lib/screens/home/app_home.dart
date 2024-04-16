import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/app_home_schema.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/models/wallet.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/providers/portfolio.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/friends/myfriends.dart';
import 'package:propstock/screens/home/home_card.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/homeheader.dart';
import 'package:propstock/widgets/loading_bar_pure.dart';
import 'package:propstock/widgets/pslistitem.dart';
import 'package:provider/provider.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  User? _user;
  final PageController _pageControllerCard = PageController();
  int currentCardIndex = 0;
  Wallet networth = Wallet(amount: 10000, currency: "NGN");
  List<AppHomeSchema> listOfSchema = [];
  double completefraction = .75;
  List<User> _friends = [];
  final plistitems = [
    {
      "title": "My Assets",
      "img": "images/asset_img.svg",
      "desc": "See all your assets & investments in one place",
      "actionText": "View assets",
      "action": () {
        // go to action
      },
      "color": MyColors.primary
    },
    {
      "title": "Portfolio",
      "img": "images/portfolioicon.svg",
      "desc": "Monitor your growth since your last visit",
      "actionText": "See growth",
      "action": () {
        // go to action
      },
      "color": Color(0xffF55D3E),
    },
    {
      "title": "Become an affiliate",
      "img": "images/hand_in_hand.svg",
      "desc": "Grow your networth by becoming an affiliate",
      "actionText": "Find a match",
      "action": () {
        // go to action
      },
      "color": Color(0xff1A936F),
    },
    {
      "title": "Gift a Friend",
      "img": "images/friend_icon.svg",
      "desc": "Surprise a loved one, send a gift",
      "actionText": "Send gift",
      "action": () {
        // go to action
      },
      "color": Color(0xff4179F4)
    },
  ];
  @override
  void initState() {
    // TODO: implement initState
    _initHomeState();
    super.initState();
  }

  Future<void> _initHomeState() async {
    try {
      String? firstname = Provider.of<Auth>(context, listen: false).firstname;
      String? lastname = Provider.of<Auth>(context, listen: false).lastname;
      String? avatar = Provider.of<Auth>(context, listen: false).profilepic;
      String? username =
          Provider.of<Auth>(context, listen: false).email!.split("@")[0];

      setState(() {
        _user = User(
            id: username,
            firstName: firstname.toString(),
            lastName: lastname.toString(),
            avatar: avatar,
            userName: username);
      });

      List<AppHomeSchema> _listOfSchema =
          await Provider.of<PortfolioProvider>(context, listen: false)
              .fetchAppHomeSchema();
      List<User> _listOfFriends =
          await Provider.of<Auth>(context, listen: false)
              .getUserFriends(1, 5, query: "");

      Provider.of<PropertyProvider>(context, listen: false)
          .setFriendAsGift(null);

      print(_listOfFriends.length);
      setState(() {
        listOfSchema = _listOfSchema;
        _friends = _listOfFriends;
      });
    } catch (e) {
      print(e);
      showErrorDialog(
          "An error occured while fetching home page data", context);
    }
  }

  Future<void> fetchFriends() async {
    try {
      List<User> _listOfFriends =
          await Provider.of<Auth>(context, listen: false)
              .getUserFriends(0, 5, query: "");

      print(_listOfFriends.length);
      setState(() {
        _friends = _listOfFriends;
      });
    } catch (e) {
      print(e);
    } finally {
      print("done");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: HomeHeader(user: _user),
            ),
            Container(
              padding: EdgeInsets.zero,
              height: 220,
              child: PageView.builder(
                controller: _pageControllerCard,
                itemCount: listOfSchema.length,
                itemBuilder: (context, index) {
                  AppHomeSchema single = listOfSchema[index];
                  return Padding(
                      padding: EdgeInsets.all(7),
                      child: HomeCard(
                        wallet: Wallet(
                          amount: single.amount,
                          currency: single.currency,
                        ),
                        diff: single.diff,
                        title: single.title,
                        color: single.cardColor,
                      ));
                },
                onPageChanged: (int index) {
                  setState(() {
                    currentCardIndex = index;
                  });
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 6,
                  width: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentCardIndex == 0
                        ? MyColors.primary
                        : Color(0xffCBDFF7),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 6,
                  width: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentCardIndex == 1
                        ? MyColors.primary
                        : Color(0xffCBDFF7),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 6,
                  width: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentCardIndex == 2
                        ? MyColors.primary
                        : Color(0xffCBDFF7),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 450,
              padding: EdgeInsets.all(10),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(), // Disable scrolling

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns in the grid
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 4, // Number of items in the grid
                itemBuilder: (BuildContext context, int index) {
                  dynamic item = plistitems[index];
                  return PSListItem(
                    img: item["img"],
                    title: item['title'],
                    desc: item['desc'],
                    actionText: item['actionText'],
                    color: item['color'],
                    action: item['action'],
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Complete Set-up",
                    style: TextStyle(
                      color: MyColors.primaryDark,
                      fontSize: 18,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                          "${(completefraction * 100).toStringAsFixed(2)}% complete",
                          style: TextStyle(
                            color: MyColors.primary,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      LoadingBarPure(
                        fraction: completefraction,
                        filledColor: MyColors.primary,
                        barHeight: 5,
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "I.D Verification",
                        style: TextStyle(
                          color: MyColors.neutralblack,
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .8,
                        child: Text(
                          "We need to verify your identity before actions can be completed.",
                          style: TextStyle(
                            color: MyColors.neutral,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                          ),
                        ),
                      )
                    ],
                  ),
                  SvgPicture.asset("images/direction_right.svg")
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Profile Information",
                        style: TextStyle(
                          color: MyColors.neutralblack,
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .8,
                        child: Text(
                          "Fill out the information form in your profile. This helps us customize your account",
                          style: TextStyle(
                            color: MyColors.neutral,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                          ),
                        ),
                      ),
                    ],
                  ),
                  SvgPicture.asset("images/direction_right.svg")
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Fund Wallet",
                        style: TextStyle(
                          color: MyColors.neutralblack,
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .8,
                        child: Text(
                          "Start your real estate journey by funding your wallet",
                          style: TextStyle(
                            color: MyColors.neutral,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                          ),
                        ),
                      ),
                    ],
                  ),
                  SvgPicture.asset("images/direction_right.svg")
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Friends",
                    style: TextStyle(
                      color: MyColors.primaryDark,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      fontFamily: "Inter",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, MyFriends.id).then((value) {
                        fetchFriends();
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          "Friends List ",
                          style: TextStyle(
                            color: MyColors.primary,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            fontFamily: "Inter",
                          ),
                        ),
                        SvgPicture.asset("images/direction_right_blue.svg")
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                  itemCount: _friends.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    User friend = _friends[index];
                    return Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                clipBehavior: Clip.hardEdge,
                                height: 64,
                                width: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  // color: Colors.green,
                                ),
                                child: friend.avatar != null
                                    ? Image.network(
                                        "${friend.avatar}",
                                        fit: BoxFit.cover,
                                      )
                                    : Icon(
                                        Icons.person_3_rounded,
                                        color: Colors.grey,
                                      )
                                // child: ,
                                ),
                            Text("${friend.firstName}"),
                            Text("${friend.lastName}"),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    );
                  }),
            ),
            SizedBox(
              height: 50,
            ),
          ]),
        ),
      ),
    );
  }
}
