import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/friendActivity.dart';
import 'package:propstock/models/property.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/friends/final_gifting_page.dart';
import 'package:propstock/screens/friends/success_gift.dart';
import 'package:propstock/screens/friends/your_assets_to_gift.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SingleFriend extends StatefulWidget {
  static const id = "single_friend";
  final User friend;

  const SingleFriend({super.key, required this.friend});

  @override
  State<SingleFriend> createState() => _SingleFriendState();
}

class _SingleFriendState extends State<SingleFriend> {
  List<FriendActivity> _friendActivity = [];
  bool loading = true;
  bool firstLoad = true;
  String? avatar;
  String? userId;
  bool isUnfriended = false;
  int _payment_page = 0;

  final List<Widget> paymentpages = [
    const YourAssetsToGift(),
    const FinalGiftingPage(),
    const SuccessGiftPageGifters(),
  ];
  @override
  initState() {
    super.initState();

    setState(() {
      avatar = Provider.of<Auth>(context, listen: false).profilepic;
      userId = Provider.of<Auth>(context, listen: false).userId;
    });

    Provider.of<PropertyProvider>(context, listen: false)
        .setFriendAsGift(widget.friend);
    _checkIfIsFriend();
    _searchFriendActivity();
  }

  Future<void> _checkIfIsFriend() async {
    try {
      String isFriend = await Provider.of<Auth>(context, listen: false)
          .isUserFriend(widget.friend);
      if (isFriend == "yes") {
        setState(() {
          isUnfriended = false;
        });
      } else {
        setState(() {
          isUnfriended = true;
        });
      }
    } catch (e) {
      showErrorDialog("An Error occured", context);
    } finally {
      setState(() {
        firstLoad = false;
      });
    }
  }

  Future<void> _showBottomSheet(BuildContext context) async {
    var res = await showModalBottomSheet(
      isScrollControlled: _payment_page == 1 || _payment_page == 0,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return paymentpages[_payment_page];
      },
    );

    if (res != null) {
      // Provider.of<PaymentProvider>(context, listen: false)
      //     .setPaymentOption(res);

      if (res == "send_gift") {
        setState(() {
          _payment_page = 0;
        });
      } else if (res == "send_gift_1") {
        setState(() {
          _payment_page = 1;
        });
      } else if (res == "success") {
        setState(() {
          _payment_page = 2;
        });
      } else {
        Provider.of<PropertyProvider>(context, listen: false)
            .setAssetToGift(null);

        setState(() {
          _payment_page = 0;
        });
      }

      _showBottomSheet(context);
    } else {
      setState(() {
        _payment_page = 0;
      });
    }
  }

  void showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 180,
            alignment: Alignment.center,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (loading) LinearProgressIndicator(),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    width: 190,
                    child: Text(
                      'Unfriend ${widget.friend.firstName} ${widget.friend.lastName}?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          // fontSize: 18.0,
                          // fontWeight: FontWeight.bold,
                          fontFamily: "Inter",
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: MyColors.secondary),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          // width: MediaQuery.of(context).size.width * .23,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: MyColors.primary, width: .5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: MyColors.primary,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            loading = true;
                          });
                          try {
                            await Provider.of<Auth>(context, listen: false)
                                .unFriend(widget.friend);
                            setState(() {
                              isUnfriended = true;
                            });
                            Navigator.pop(context);
                          } catch (e) {
                            print(e);
                            showErrorDialog(e.toString(), context);
                          } finally {
                            setState(() {
                              loading = false;
                            });
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),

                          margin: EdgeInsets.all(10),
                          // width: MediaQuery.of(context).size.width * .23,
                          decoration: BoxDecoration(
                              color: MyColors.primary,
                              // border: Border.all(color: MyColors.primary, width: .5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Text(
                            "Unfriend",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> _searchFriendActivity() async {
    try {
      List<FriendActivity> al = await Provider.of<Auth>(context, listen: false)
          .searchFriendActivity(widget.friend, 0, 20);

      setState(() {
        _friendActivity = al;
        loading = false;
      });
    } catch (e) {
      showErrorDialog("Could not search friend history", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: firstLoad
              ? Column(
                  children: [
                    LinearProgressIndicator(),
                    SizedBox(
                      height: 10,
                    )
                  ],
                )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SvgPicture.asset("images/close_icon.svg")),
                          GestureDetector(
                            onTap: () {
                              showModal(context);
                            },
                            child: isUnfriended
                                ? Text("")
                                : Text(
                                    "Remove friend",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        height: 160.71,
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Image.network("${widget.friend.avatar}"),
                      ),
                      Text(
                        "${widget.friend.firstName} ${widget.friend.lastName}",
                        style: TextStyle(
                          color: MyColors.neutralblack,
                          fontFamily: "Inter",
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "@${widget.friend.userName.split("@")[0]}",
                        style: TextStyle(
                          color: MyColors.neutral,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Inter",
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (!isUnfriended)
                        PropStockButton(
                          text: "Send Gift",
                          disabled: false,
                          onPressed: () {
                            _showBottomSheet(context);
                          },
                        ),
                      if (isUnfriended)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  _showBottomSheet(context);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 48,
                                  padding: EdgeInsets.all(10),

                                  // margin: EdgeInsets.all(10),
                                  // width: MediaQuery.of(context).size.width * .23,
                                  decoration: BoxDecoration(
                                      color: MyColors.primary,
                                      // border: Border.all(color: MyColors.primary, width: .5),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Text(
                                    "Send Gift",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  // Navigator.pop(context);
                                  setState(() {
                                    loading = true;
                                  });
                                  try {
                                    await Provider.of<Auth>(context,
                                            listen: false)
                                        .addFriend(widget.friend);
                                    setState(() {
                                      isUnfriended = false;
                                    });
                                    // Navigator.pop(context);
                                  } catch (e) {
                                    print(e);
                                    showErrorDialog(e.toString(), context);
                                  } finally {
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                },
                                child: Container(
                                  // margin: EdgeInsets.all(10),
                                  height: 48,

                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.center,
                                  // width: MediaQuery.of(context).size.width * .23,
                                  decoration: BoxDecoration(
                                      color: Color(0xff2286FE).withOpacity(.2),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Text(
                                    "Add Friend",
                                    style: TextStyle(
                                        color: MyColors.primary,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: .4, color: Color(0xffeeeeee)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color:
                                            Color(0xffAFCBEC).withOpacity(.5),
                                        blurRadius: 20,
                                      )
                                    ],
                                    shape: BoxShape.circle,
                                  ),
                                  child:
                                      SvgPicture.asset("images/coowner.svg")),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                "Co-owners",
                                style: TextStyle(
                                  color: MyColors.primaryDark,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: .4, color: Color(0xffeeeeee)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color:
                                            Color(0xffAFCBEC).withOpacity(.5),
                                        blurRadius: 20,
                                      )
                                    ],
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset("images/amico.svg")),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                "Co-investors",
                                style: TextStyle(
                                  color: MyColors.primaryDark,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Your History",
                          style: TextStyle(
                            color: Color(0xff1D3354),
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      if (loading) LinearProgressIndicator(),
                      if (!loading && _friendActivity.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                            itemCount: _friendActivity.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              FriendActivity activity = _friendActivity[index];

                              String originalTimestamp = activity.date;
                              DateTime dateTime =
                                  DateTime.parse(originalTimestamp);

                              String formattedDate =
                                  DateFormat('MMM, d y').format(dateTime);

                              if (activity.giftedBy == userId) {
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  isThreeLine: true,
                                  leading: ClipOval(
                                    child: CircleAvatar(
                                      child: Image.network("$avatar"),
                                    ),
                                  ),
                                  title: Text(
                                    "Sent",
                                    style: TextStyle(
                                      color: MyColors.neutralblack,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Inter",
                                    ),
                                  ),
                                  trailing: Text(
                                    formattedDate,
                                    style: TextStyle(
                                      color: MyColors.neutral,
                                      fontSize: 12,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "You sent ${widget.friend.firstName} ${widget.friend.lastName} ${activity.activity_type.contains("invest") ? "an investment" : "a property"}",
                                    style: TextStyle(
                                        color: MyColors.neutral,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Inter"),
                                  ),
                                );
                              }
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                isThreeLine: true,
                                leading: ClipOval(
                                  child: CircleAvatar(
                                    child: Image.network("$avatar"),
                                  ),
                                ),
                                title: Text(
                                  "Received",
                                  style: TextStyle(
                                    color: MyColors.neutralblack,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Inter",
                                  ),
                                ),
                                trailing: Text(
                                  formattedDate,
                                  style: TextStyle(
                                    color: MyColors.neutral,
                                    fontSize: 12,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                subtitle: Text(
                                  "You received ${activity.activity_type.contains("invest") ? "an investment" : "a property"} from ${widget.friend.firstName} ${widget.friend.lastName}",
                                  style: TextStyle(
                                      color: MyColors.neutral,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Inter"),
                                ),
                              );
                            },
                          ),
                        )
                    ],
                  )),
        ),
      ),
    );
  }
}
