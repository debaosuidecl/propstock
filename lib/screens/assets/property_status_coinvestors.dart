import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/providers/assets.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class PropertyStatusCoInvestors extends StatefulWidget {
  const PropertyStatusCoInvestors({super.key});
  static const id = "property_status_coinvestors";
  @override
  State<PropertyStatusCoInvestors> createState() =>
      _PropertyStatusCoInvestorsState();
}

class _PropertyStatusCoInvestorsState extends State<PropertyStatusCoInvestors> {
  Future<String> fetchUserData(User user, String? investmentId) async {
    String percentage = "";
    try {
      String percentageb =
          await Provider.of<AssetsProvider>(context, listen: false)
              .findCoInvestPercentage(user, investmentId);

      percentage = percentageb;
    } catch (e) {
      showErrorDialog("Cannot get percentage", context);
    }

    return percentage;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    List<User> coInvestorList = arguments["totalCoInvestors"] as List<User>;
    String? investmentId = arguments["investment_id"];
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 1, color: Color(0xffeeeeee)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset("images/left-back.svg"),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 20.0,
                          top: 20,
                          left: 0,
                          bottom: 20,
                        ),
                        child: Text(
                          "Co-investors",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff1D3354),
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            fontFamily: "Inter",
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                // color: Colors.green,
                width: double.infinity,
                child: Text(
                  "Your Co-investors",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xff1D3354),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ListView.builder(
                  shrinkWrap:
                      true, // Ensure the ListView takes only the needed height
                  physics:
                      NeverScrollableScrollPhysics(), // Prevent the ListView from scrolling independently

                  itemCount: coInvestorList.length,
                  itemBuilder: (ctx, index) {
                    User coinvestor = coInvestorList[index];
                    return ListTile(
                      leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage("${coinvestor.avatar}")),
                      title: Text(coinvestor.firstName),
                      subtitle: Text(coinvestor.userName),
                      trailing: FutureBuilder<String>(
                        future:
                            fetchUserData(coInvestorList[index], investmentId),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(color: Colors.red),
                            );
                          } else if (snapshot.hasData) {
                            return Text(
                              "${snapshot.data!}%",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: MyColors.primary,
                              ),
                            );
                          } else {
                            return Text('No data found');
                          }
                        },
                      ),
                    );
                  })
            ],
          )),
        ),
      ),
    );
  }
}
