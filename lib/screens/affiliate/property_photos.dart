import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:propstock/models/colors.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/providers/listings.dart';
import 'package:propstock/screens/affiliate/house_features_modal_sheet.dart';
import 'package:propstock/screens/affiliate/select_title_document_modal.dart';
import 'package:propstock/screens/affiliate/upload_property_document.dart';
// import 'package:propstock/screens/affiliate/about_listing_property.dart';
// import 'package:propstock/screens/location_select.dart';
import 'package:propstock/screens/modal_sheet.dart';
// import 'package:propstock/screens/verify_identity/identityUpload.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class PropertyPhotosAffiliate extends StatefulWidget {
  static const id = "PropertyPhotosAffiliate";
  const PropertyPhotosAffiliate({super.key});

  @override
  State<PropertyPhotosAffiliate> createState() =>
      _PropertyPhotosAffiliateState();
}

class _PropertyPhotosAffiliateState extends State<PropertyPhotosAffiliate> {
  bool loading = false;

  List<File> _selectedImages = [];

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage != null)
      setState(() {
        _selectedImages.add(File(returnedImage.path));
      });
  }

  bool disabledFunc() {
    return _selectedImages.isEmpty;
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
                  "Property Photos",
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
                  "Upload photos of the property",
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
              if (_selectedImages.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                      onTap: () {
                        _pickImageFromGallery();
                      },
                      child: SvgPicture.asset("images/add_new_image.svg")),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: _selectedImages.asMap().entries.map((entry) {
                    int idx = entry.key;
                    File image = entry.value;
                    bool isLast = idx == _selectedImages.length - 1;

                    if (isLast) {
                      return Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                // print("love");
                                // Provider.of<ListingsProvider>(context,
                                //         listen: false)
                                //     .removeHouseFeatures(feature);
                              },
                              child: Stack(
                                children: [
                                  Container(
                                      clipBehavior: Clip.hardEdge,
                                      margin: EdgeInsets.only(
                                          right: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      height: 100,
                                      child: Image.file(image)),
                                  Positioned(
                                      right: 15,
                                      top: 5,
                                      child: GestureDetector(
                                        onTap: () {
                                          print("removing image");
                                          _selectedImages.remove(image);
                                          setState(() {});
                                        },
                                        child: SvgPicture.asset(
                                            "images/transclose.svg"),
                                      )),
                                ],
                              )),
                          GestureDetector(
                              onTap: () {
                                _pickImageFromGallery();
                              },
                              child:
                                  SvgPicture.asset("images/add_new_image.svg")),
                        ],
                      );
                    }

                    return GestureDetector(
                      onTap: () {
                        // print("love");
                        // Provider.of<ListingsProvider>(context,
                        //         listen: false)
                        //     .removeHouseFeatures(feature);
                      },
                      child: Stack(
                        children: [
                          Container(
                            clipBehavior: Clip.hardEdge,
                            margin: EdgeInsets.only(right: 10, bottom: 10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            height: 100,
                            child: Image.file(image),
                          ),
                          Positioned(
                              right: 15,
                              top: 5,
                              child: GestureDetector(
                                  onTap: () {
                                    _selectedImages.remove(image);
                                    setState(() {});
                                    print("removing image");
                                  },
                                  child: SvgPicture.asset(
                                      "images/transclose.svg"))),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 20,
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
                          .selectedPropertyImages = _selectedImages;

                      Navigator.pushNamed(context, UploadPropertyDocument.id);
                      // Provider.of<ListingsProvider>(context, listen: false)
                      //     .price = _priceController.text;
                      // Provider.of<ListingsProvider>(context, listen: false)
                      //         .currency =
                      //     Provider.of<Auth>(context, listen: false)
                      //         .selectedCurrency;

                      // Provider.of<ListingsProvider>(context, listen: false)
                      //     .bedroom = _bedroomcontroller.text;
                      // Provider.of<ListingsProvider>(context, listen: false)
                      //     .floor = _floorcontroller.text;

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
                      // Navigator.pushNamed(context, PropertyPhotosAffiliateB.id);
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
