import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:propstock/models/colors.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/providers/listings.dart';
import 'package:propstock/screens/affiliate/house_features_modal_sheet.dart';
import 'package:propstock/screens/affiliate/property_photos.dart';
import 'package:propstock/screens/affiliate/select_title_document_modal.dart';
// import 'package:propstock/screens/affiliate/about_listing_property.dart';
// import 'package:propstock/screens/location_select.dart';
import 'package:propstock/screens/modal_sheet.dart';
// import 'package:propstock/screens/verify_identity/identityUpload.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class AboutListingPropertyB extends StatefulWidget {
  static const id = "AboutListingPropertyB";
  const AboutListingPropertyB({super.key});

  @override
  State<AboutListingPropertyB> createState() => _AboutListingPropertyBState();
}

class _AboutListingPropertyBState extends State<AboutListingPropertyB> {
  bool loading = false;
  String selectedtype = "";
  String? _propertyUses;
  TextEditingController _toiletcontroller = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _squaremeterscontroller = TextEditingController();
  TextEditingController _bedroomcontroller = TextEditingController();
  TextEditingController _floorcontroller = TextEditingController();
  String? _selectedState;
  final List<String> _houseNames = [
    "Duplex", "Block or Flat", "Maisonette",
    // "Luxury Apartment",
  ];
  String _whatWeCallHouse = "";
  String _duplexType = "";

  List<String> _dropdownItems = ['Rental', 'Purchase', 'Investment'];
  List<String> _duplexTypes = ['Terrace', 'Fully Detached', 'Semi Detached'];
  List<String> countryhold = [];
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  bool disabledFunc() {
    return _toiletcontroller.text.isEmpty ||
        _priceController.text.isEmpty ||
        _squaremeterscontroller.text.isEmpty ||
        _bedroomcontroller.text.isEmpty ||
        _floorcontroller.text.isEmpty ||
        Provider.of<ListingsProvider>(context, listen: true)
            .houseFeatures
            .isEmpty ||
        Provider.of<ListingsProvider>(context, listen: true)
            .titleDocuments
            .isEmpty;

    // return false;
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext contextb) {
        return HouseFeaturesModalSheet();
      },
    );
  }

  void _showModalTitleBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext contextb) {
        return SelectTitleDocumentModal();
      },
    );
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
                  "Kindly provide the necessary information",
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (e) {
                    setState(() {});
                  },
                  controller: _bedroomcontroller,

                  // keyboardAppearance: K,
                  maxLines: 1, // Expands to fit the content
                  decoration: InputDecoration(
                    label: Text('No. of bedrooms'),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffCBDFF7),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffCBDFF7),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _toiletcontroller,

                  // keyboardAppearance: K,
                  maxLines: 1, // Expands to fit the content
                  decoration: InputDecoration(
                    label: Text('No. of toilets'),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffCBDFF7),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffCBDFF7),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _squaremeterscontroller,

                  // keyboardAppearance: K,
                  maxLines: 1, // Expands to fit the content
                  decoration: InputDecoration(
                    label: Text('No. of square meters'),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffCBDFF7),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffCBDFF7),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (e) {
                    setState(() {});
                  },
                  controller: _floorcontroller,

                  // keyboardAppearance: K,
                  maxLines: 1, // Expands to fit the content
                  decoration: InputDecoration(
                    label: Text('No. of floors'),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffCBDFF7),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffCBDFF7),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    alignment: Alignment.centerLeft,
                    // height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffCBDFF7)),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Provider.of<Auth>(context, listen: false)
                        //                 .countrystring !=
                        //             null &&
                        //         Provider.of<Auth>(context, listen: false)
                        //             .dynamicStateListString
                        //             .isNotEmpty
                        //     ? Text(
                        //         "${Provider.of<Auth>(context, listen: false).countrystring}")
                        //     :
                        if (Provider.of<ListingsProvider>(context, listen: true)
                            .houseFeatures
                            .isEmpty)
                          Text(
                            "Select house features",
                            style: TextStyle(color: Color(0xffB0B0B0)),
                          ),

                        if (Provider.of<ListingsProvider>(context, listen: true)
                            .houseFeatures
                            .isNotEmpty)
                          //   Text("contains something"),
                          // // Wrap()
                          Expanded(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: Provider.of<ListingsProvider>(context,
                                      listen: true)
                                  .houseFeatures
                                  .map((feature) {
                                return GestureDetector(
                                  onTap: () {
                                    print("love");
                                    Provider.of<ListingsProvider>(context,
                                            listen: false)
                                        .removeHouseFeatures(feature);
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                        top: 3,
                                        bottom: 3,
                                        left: 5,
                                        right: 15,
                                      ),
                                      margin: const EdgeInsets.only(
                                          right: 4.1, bottom: 4),
                                      decoration: const BoxDecoration(
                                          color: Color(0xffE0EAF6),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Positioned(
                                            right: -14,
                                            top: 2,
                                            child: SvgPicture.asset(
                                                "images/cross.svg"),
                                          ),
                                          Text(
                                            feature,
                                            style: const TextStyle(
                                              fontFamily: "Inter",
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      )),
                                );
                              }).toList(),
                            ),
                          ),

                        GestureDetector(
                            onTap: () {
                              _showModalBottomSheet(context);
                            },
                            child: SvgPicture.asset("images/downb.svg"))
                      ],
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    alignment: Alignment.centerLeft,
                    // height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffCBDFF7)),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Provider.of<Auth>(context, listen: false)
                        //                 .countrystring !=
                        //             null &&
                        //         Provider.of<Auth>(context, listen: false)
                        //             .dynamicStateListString
                        //             .isNotEmpty
                        //     ? Text(
                        //         "${Provider.of<Auth>(context, listen: false).countrystring}")
                        //     :
                        if (Provider.of<ListingsProvider>(context, listen: true)
                            .titleDocuments
                            .isEmpty)
                          Text(
                            "Select title documents",
                            style: TextStyle(color: Color(0xffB0B0B0)),
                          ),

                        if (Provider.of<ListingsProvider>(context, listen: true)
                            .titleDocuments
                            .isNotEmpty)
                          //   Text("contains something"),
                          // // Wrap()
                          Expanded(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: Provider.of<ListingsProvider>(context,
                                      listen: true)
                                  .titleDocuments
                                  .map((title) {
                                return GestureDetector(
                                  onTap: () {
                                    print("love");
                                    Provider.of<ListingsProvider>(context,
                                            listen: false)
                                        .removeTitleDocuments(title);
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                        top: 3,
                                        bottom: 3,
                                        left: 5,
                                        right: 15,
                                      ),
                                      margin: const EdgeInsets.only(
                                          right: 4.1, bottom: 4),
                                      decoration: const BoxDecoration(
                                          color: Color(0xffE0EAF6),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Positioned(
                                            right: -14,
                                            top: 2,
                                            child: SvgPicture.asset(
                                                "images/cross.svg"),
                                          ),
                                          Text(
                                            title,
                                            style: const TextStyle(
                                              fontFamily: "Inter",
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      )),
                                );
                              }).toList(),
                            ),
                          ),

                        GestureDetector(
                            onTap: () {
                              _showModalTitleBottomSheet(context);
                            },
                            child: SvgPicture.asset("images/downb.svg"))
                      ],
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Price",
                  style: TextStyle(
                    color: Color(0xff1D3354),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    fontFamily: "Inter",
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "How much is the property (${Provider.of<Auth>(context, listen: false).selectedCurrency})?",
                  style: TextStyle(
                    color: Color(0xff5E6D85),
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontFamily: "Inter",
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (e) {
                    setState(() {});
                  },
                  controller: _priceController,

                  // keyboardAppearance: K,
                  maxLines: 1, // Expands to fit the content
                  decoration: InputDecoration(
                    hintText: 'Enter Amount',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffCBDFF7),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffCBDFF7),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
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
                          .toilet = _toiletcontroller.text;
                      Provider.of<ListingsProvider>(context, listen: false)
                          .price = _priceController.text;
                      Provider.of<ListingsProvider>(context, listen: false)
                          .squaremeter = _squaremeterscontroller.text;
                      Provider.of<ListingsProvider>(context, listen: false)
                              .currency =
                          Provider.of<Auth>(context, listen: false)
                              .selectedCurrency;

                      Provider.of<ListingsProvider>(context, listen: false)
                          .bedroom = _bedroomcontroller.text;
                      Provider.of<ListingsProvider>(context, listen: false)
                          .floor = _floorcontroller.text;

                      Navigator.pushNamed(context, PropertyPhotosAffiliate.id);

                      // Provider.of<ListingsProvider>(context, listen: false)
                      //     .why = _whyController.text;
                      // Provider.of<ListingsProvider>(context, listen: false)
                      //     .address = _addressRealController.text;
                      // Provider.of<ListingsProvider>(context, listen: false)
                      //     .state = "$_selectedState";
                      // Provider.of<ListingsProvider>(context, listen: false)
                      //     .housename = _whatWeCallHouse;
                      // Provider.of<ListingsProvider>(context, listen: false)
                      //     .duplextype = _duplexType;

                      // Provider.of<ListingsProvider>(context, listen: false)
                      //     .setListingPropertiesA();
                      // Navigator.pushNamed(context, AboutListingPropertyBB.id);
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
    );
  }
}
