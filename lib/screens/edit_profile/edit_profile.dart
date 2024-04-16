import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/create_new_pin.dart';
import 'package:propstock/screens/edit_profile/edit_profile_b.dart';

import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Appstate { free, picked, cropped }

class EditProfile extends StatefulWidget {
  static const id = "EditProfile";
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // bool enabledBio = false;
  // bool enabledisplayinfo = false;
  // late final LocalAuthentication auth;
  // bool _supportState = false;
  bool loading = true;
  String? avatar = "";
  String? email = "";
  String? firstName = "";
  String? lastName = "";
  String? phone = "";
  int dateOfBirth = 0;

  late Appstate state;

  // AppState

  File? selectedImage;
  File? _intermediateFile;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    check();
  }

  bool isInteger(int? value) {
    // Check if the value is not null and is of type int
    return value != null && value is int;
  }

  bool disabledFunc() {
    return _firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        loading;
  }

  Future<void> check() async {
    try {
      // final prefs = await SharedPreferences.getInstance();

      setState(() {
        avatar = Provider.of<Auth>(context, listen: false).profilepic;
        email = Provider.of<Auth>(context, listen: false).email;
        firstName = Provider.of<Auth>(context, listen: false).firstname;
        lastName = Provider.of<Auth>(context, listen: false).lastname;
        phone = Provider.of<Auth>(context, listen: false).phoneFor2fa;
        // if(dateOfBirth !=null)

        if (isInteger(Provider.of<Auth>(context, listen: false).dateOfBirth)) {
          dateOfBirth =
              Provider.of<Auth>(context, listen: false).dateOfBirth as int;
        }
        loading = false;
      });

      _firstNameController.setText("$firstName");
      _emailController.setText("$email");
      _lastNameController.setText("$lastName");
      _phoneController.setText("$phone");

      if (isInteger(dateOfBirth) && dateOfBirth != 0) {
        DateTime formatted = DateTime.fromMillisecondsSinceEpoch(dateOfBirth);
        _dateController
            .setText("${formatted.day}-${formatted.month}-${formatted.year}");
      }

      print("this is the avatar: $avatar");
      // final extractedUserData = prefs.getString("displayinfo");

      // print(extractedUserData);

      // // final biostate = extractedUserData["biometrics_token"];

      // if (extractedUserData != null) {
      //   // if(extractedUserData =)

      //   setState(() {
      //     enabledisplayinfo = true;
      //   });
      // // }
    } catch (e) {
      print(e);
    }
  }

  Future _pickFromGallery() async {
    try {
      final returnedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      setState(() {
        _intermediateFile = File(returnedImage!.path);
      });

      setState(() {
        state = Appstate.picked;
      });

      cropImage();
    } catch (e) {
      // print("got it");
      // showErrorDialog(e.toString(), context);
    }
  }

  Future cropImage() async {
    try {
      File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _intermediateFile!.path,
        cropStyle: CropStyle.circle,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9,
              ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: "Crop Image",
          toolbarColor: MyColors.primary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(title: "Crop Image"),
      );

      if (croppedFile != null) {
        selectedImage = croppedFile;

        setState(() {
          state = Appstate.cropped;
        });
      }
    } catch (e) {
      showErrorDialog("Could not display crop tool", context);
    }
  }

  Future _pickFromCamera() async {
    try {
      final returnedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);

      setState(() {
        _intermediateFile = File(returnedImage!.path);
      });

      setState(() {
        state = Appstate.picked;
      });

      cropImage();
    } catch (e) {
      // print("got it");
      // showErrorDialog(e.toString(), context);
    }
  }

  Future _updateProfile() async {
    setState(() {
      loading = true;
    });
    if (selectedImage != null) {
      // I have to send request to backend.
      try {
        String? img = await Provider.of<Auth>(context, listen: false)
            .uploadImage(selectedImage!);

        setState(() {
          avatar = img;
        });
      } catch (e) {
        print(e);
        showErrorDialog("could not upload your image file", context);
        setState(() {
          loading = false;
        });
        return;
      }
    }

    try {
      await Provider.of<Auth>(context, listen: false).updateAccount(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        dateOfBirth: dateOfBirth,
      );

      final snackBar = SnackBar(
        content: Text('Profile successfully updated'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            // Perform some action when the user taps the action button
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // Navigator.pop(context);
      // setState(() {
      //   avatar = img;
      // });
    } catch (e) {
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future openImageOptions() async {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          // Adjust the height and decoration of the bottom sheet
          height: 200,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            // border: Border.all(color: Colors.grey, width: 1.0),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  _pickFromCamera();
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    SvgPicture.asset("images/camera.svg"),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Camera",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Inter",
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  _pickFromGallery();
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.browse_gallery,
                      color: MyColors.primary,
                      size: 32,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Gallery",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Inter",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
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
            Navigator.pop(context);
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
                  "Edit Profile",
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
                height: 30,
              ),
              // if (!loading && avatar != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Stack(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          // child:
                          height: 120,
                          width: 120,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),

                          child: selectedImage != null
                              ? Image.file(selectedImage!)
                              : Image.network("$avatar"),
                        ),
                        Positioned(
                          child: GestureDetector(
                              onTap: () {
                                // _pickFromGallery();
                                openImageOptions();
                              },
                              child: SvgPicture.asset("images/camera.svg")),
                          bottom: 0,
                          right: 0,
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Basic Information",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xff1D3354),
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _firstNameController,
                  // keyboardType: TextInputType.text,
                  onChanged: (String val) {
                    setState(() {
                      firstName = val;
                    });
                  },
                  decoration: InputDecoration(
                    // hintText: "First Name",
                    label: Text("First Name"),
                    prefixIconColor: Color(0xffB0B0B0),
                    filled: true,
                    fillColor: Color(0xffffffff),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    hintStyle: TextStyle(
                      color: Color(0xffB0B0B0),
                      fontSize: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xffCBDFF7),
                      ), // Use the hex color
                      borderRadius: BorderRadius.circular(
                          8), // You can adjust the border radius as needed
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xffCBDFF7),
                      ), // Use the hex color
                      borderRadius: BorderRadius.circular(
                          8), // You can adjust the border radius as needed
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _lastNameController,
                  // keyboardType: TextInputType.text,
                  onChanged: (String val) {
                    setState(() {
                      lastName = val;
                    });
                  },
                  decoration: InputDecoration(
                    label: Text("Last Name"),
                    prefixIconColor: Color(0xffB0B0B0),
                    filled: true,
                    fillColor: Color(0xffffffff),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    hintStyle: TextStyle(
                      color: Color(0xffB0B0B0),
                      fontSize: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xffCBDFF7),
                      ), // Use the hex color
                      borderRadius: BorderRadius.circular(
                          8), // You can adjust the border radius as needed
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xffCBDFF7),
                      ), // Use the hex color
                      borderRadius: BorderRadius.circular(
                          8), // You can adjust the border radius as needed
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _emailController,
                  // keyboardType: TextInputType.text,
                  onChanged: (String val) {
                    setState(() {
                      email = val;
                    });
                  },

                  enabled: false,
                  decoration: InputDecoration(
                    hintText: "Email",
                    label: Text("Email"),
                    prefixIconColor: Color(0xffB0B0B0),
                    filled: true,
                    fillColor: Color(0xffffffff),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    hintStyle: TextStyle(
                      color: Color(0xffB0B0B0),
                      fontSize: 14,
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xffCBDFF7),
                      ), // Use the hex color
                      borderRadius: BorderRadius.circular(
                          8), // You can adjust the border radius as needed
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xffCBDFF7),
                      ), // Use the hex color
                      borderRadius: BorderRadius.circular(
                          8), // You can adjust the border radius as needed
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xffCBDFF7),
                      ), // Use the hex color
                      borderRadius: BorderRadius.circular(
                          8), // You can adjust the border radius as needed
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _phoneController,
                  // keyboardType: TextInputType.text,
                  onChanged: (String val) {
                    setState(() {
                      phone = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Phone",
                    label: Text("Phone"),
                    prefixIconColor: Color(0xffB0B0B0),
                    filled: true,
                    fillColor: Color(0xffffffff),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    hintStyle: TextStyle(
                      color: Color(0xffB0B0B0),
                      fontSize: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xffCBDFF7),
                      ), // Use the hex color
                      borderRadius: BorderRadius.circular(
                          8), // You can adjust the border radius as needed
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xffCBDFF7),
                      ), // Use the hex color
                      borderRadius: BorderRadius.circular(
                          8), // You can adjust the border radius as needed
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate:
                        DateTime.fromMillisecondsSinceEpoch(dateOfBirth),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _dateController.setText(
                          "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}");
                      // _dateController
                      //     .setText("${pickedDate.millisecondsSinceEpoch}");

                      dateOfBirth = pickedDate.millisecondsSinceEpoch;
                    });
                  }
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 48,
                      clipBehavior: Clip.none,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Color(0xffCBDFF7),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Text(_dateController.text.isEmpty
                          ? "-- SET DATE --"
                          : _dateController.text),
                    ),
                    Positioned(
                        left: 25,
                        top: -7,
                        child: Container(
                          color: Colors.white,
                          child: Text(
                            "Date Of Birth",
                            style: TextStyle(
                              // background: Colors.white,
                              color: MyColors.neutral,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w200,
                              fontSize: 12,
                            ),
                          ),
                        )),
                  ],
                ),

                // child: Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: TextField(
                //     controller: _dateController,
                //     // keyboardType: TextInputType.text,
                //     onChanged: (String val) {
                //       setState(() {
                //         email = val;
                //       });
                //     },
                //     // enabled: false,

                //     decoration: InputDecoration(
                //       label: Text("Date of Birth"),
                //       prefixIconColor: Color(0xffB0B0B0),
                //       filled: true,
                //       fillColor: Color(0xffffffff),
                //       contentPadding: const EdgeInsets.symmetric(
                //           horizontal: 10, vertical: 15),
                //       hintStyle: TextStyle(
                //         color: Color(0xffB0B0B0),
                //         fontSize: 14,
                //       ),
                //       enabledBorder: OutlineInputBorder(
                //         borderSide: const BorderSide(
                //           color: Color(0xffCBDFF7),
                //         ), // Use the hex color
                //         borderRadius: BorderRadius.circular(
                //             8), // You can adjust the border radius as needed
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderSide: const BorderSide(
                //           color: Color(0xffCBDFF7),
                //         ), // Use the hex color
                //         borderRadius: BorderRadius.circular(
                //             8), // You can adjust the border radius as needed
                //       ),
                //     ),
                //   ),
                // ),
              ),

              const SizedBox(
                height: 25,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "More Information",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xff1D3354),
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "This would help us create a more customised experience for you.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xff5E6D85),
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add Information",
                      style: TextStyle(
                        fontFamily: "Inter",
                        color: Color(0xff1D3354),
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, EditProfileB.id);
                          },
                          child: Text(
                            "Not Completed",
                            style: TextStyle(
                              fontFamily: "Inter",
                              color: MyColors.primary,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: MyColors.primary,
                          size: 14,
                        )
                      ],
                    )
                  ],
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
                    text: "UPDATE",
                    disabled: disabledFunc(),
                    onPressed: () {
                      _updateProfile();
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
