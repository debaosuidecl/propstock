import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/providers/listings.dart';
import 'package:propstock/screens/affiliate/about_listing_property.dart';
import 'package:propstock/screens/verify_identity/identityUpload.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class SelectListingType extends StatefulWidget {
  static const id = "SelectListingType";
  const SelectListingType({super.key});

  @override
  State<SelectListingType> createState() => _SelectListingTypeState();
}

class _SelectListingTypeState extends State<SelectListingType> {
  bool loading = false;
  String selectedtype = "";

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  bool disabledFunc() {
    return selectedtype.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xff1D3354),
          ),
          onPressed: () {
            // Navigate back to the previous screen when the back button is pressed
            Navigator.pop(context, 'success');
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * .8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Add to listing",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff1D3354),
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Text(
                    "Select the type of property are you adding to listing.",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 16,
                      color: Color(0xff5E6D85),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      selectedtype = "Residential Property";
                    });
                    // Navigator.pushNamed(context, IdentityUpload.id,
                    //     arguments: "National Identity Number");
                    // var res = await Navigator.pushNamed(
                    //     context, IdentityUpload.id,
                    //     arguments: "National Identity Number");

                    // if (res == "success") {
                    //   Navigator.pop(context, 'success');
                    // }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: selectedtype == "Residential Property"
                                ? MyColors.primary
                                : Color(0xffCBDFF7)),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: ListTile(
                      title: Text("Residential Property"),
                      leading: Container(
                        height: 16,
                        width: 16,
                        margin: EdgeInsets.only(top: 3),
                        decoration: BoxDecoration(
                          color: selectedtype == "Residential Property"
                              ? MyColors.primary
                              : Colors.transparent,
                          border: Border.all(color: Color(0xffCBDFF7)),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    // var res = Navigator.pushNamed(context, IdentityUpload.id,
                    //     arguments: "International Passport");

                    // if (res == "success") {
                    //   Navigator.pop(context, 'success');
                    // }
                    setState(() {
                      selectedtype = "Commercial Property";
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: selectedtype == "Commercial Property"
                                ? MyColors.primary
                                : Color(0xffCBDFF7)),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: ListTile(
                      title: Text("Commercial Property"),
                      leading: Container(
                        height: 16,
                        width: 16,
                        margin: EdgeInsets.only(top: 3),
                        decoration: BoxDecoration(
                          color: selectedtype == "Commercial Property"
                              ? MyColors.primary
                              : Colors.transparent,
                          border: Border.all(color: Color(0xffCBDFF7)),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    // // Navigator.pushNamed(context, IdentityUpload.id,
                    // //     arguments: "Drivers License");

                    // // Navigator.pushNamed(context, IdentityUpload.id,
                    // //     arguments: "National Identity Number");
                    // var res = await Navigator.pushNamed(
                    //     context, IdentityUpload.id,
                    //     arguments: "Drivers License");

                    // if (res == "success") {
                    //   Navigator.pop(context, 'success');
                    // }
                    setState(() {
                      selectedtype = "Landed Property";
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: selectedtype == "Landed Property"
                                ? MyColors.primary
                                : Color(0xffCBDFF7)),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: ListTile(
                      title: Text("Landed Property"),
                      leading: Container(
                        height: 16,
                        width: 16,
                        margin: EdgeInsets.only(top: 3),
                        decoration: BoxDecoration(
                          color: selectedtype == "Landed Property"
                              ? MyColors.primary
                              : Colors.transparent,
                          border: Border.all(color: Color(0xffCBDFF7)),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SizedBox(
                    height: 40,
                  ),
                ),
                if (loading)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: LinearProgressIndicator(),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: PropStockButton(
                      text: "Continue",
                      disabled: disabledFunc(),
                      onPressed: () {
                        Provider.of<ListingsProvider>(context, listen: false)
                            .listingType = selectedtype;
                        Navigator.pushNamed(context, AboutListingProperty.id);
                        // _updateProfile();
                      }),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
