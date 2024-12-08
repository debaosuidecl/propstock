import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class IdentityUpload extends StatefulWidget {
  const IdentityUpload({super.key});

  static const id = "identity_upload";

  @override
  State<IdentityUpload> createState() => _IdentityUploadState();
}

class _IdentityUploadState extends State<IdentityUpload> {
  File? _selectedImage = null;
  bool loading = false;
  Future _pickImageFromGallery() async {
    PermissionStatus status = await Permission.photos.request();

    // opena
    // return print(status.isGranted);
    // if (status.isGranted) return print("is denied");
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage != null)
      setState(() {
        _selectedImage = File(returnedImage!.path);
      });
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage != null)
      setState(() {
        _selectedImage = File(returnedImage!.path);
      });
  }

  //  Future<void> _uploadImage() async {
  //   if (_selectedImage == null) return;

  //   // final uri = Uri.parse('https://your-backend-url/upload');
  //   // final request = http.MultipartRequest('POST', uri)
  //   //   ..files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));

  //   // final response = await request.send();

  //   // if (response.statusCode == 200) {
  //   //   print('Image uploaded successfully');
  //   // } else {
  //   //   print('Image upload failed');
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    final String documentType =
        ModalRoute.of(context)!.settings.arguments as String;

    Future updateProfile() async {
      setState(() {
        loading = true;
      });
      if (_selectedImage != null) {
        // setst
        // I have to send request to backend.
        try {
          String? img = await Provider.of<Auth>(context, listen: false)
              .uploadIDImage(_selectedImage!, documentType);

          await Provider.of<Auth>(context, listen: false).tryAutoLogin();

          // setState(() {
          //   // avatar = img;
          // });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Your $documentType is being verified, you will be notified shortly when complete')),
          );

          Navigator.pop(context, 'success');
        } catch (e) {
          print(e);
          showErrorDialog("could not upload your image file", context);
          setState(() {
            loading = false;
          });
          return;
        }
      }
    }

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
          child: Container(
            height: MediaQuery.of(context).size.height * .75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                if (loading)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: LinearProgressIndicator(),
                  ),

                SizedBox(
                  height: 5,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    documentType,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Enter your $documentType on your slip for verification",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff5E6D85),
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _selectedImage != null
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              child: Image.file(_selectedImage!))
                          : SvgPicture.asset("images/id.svg"),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // if (loading)
                //   Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                //     child: LinearProgressIndicator(),
                //   ),

                if (_selectedImage != null)
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          // _pickImageFromGallery();
                          if (!loading) updateProfile();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: loading
                                ? Color(0xffeeeeee)
                                : Color.fromARGB(241, 4, 140, 11),
                            // border: Border.all(
                            //   color: MyColors.primary,
                            // ),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Text(
                            "Upload",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )),

                SizedBox(
                  height: 10,
                ),
                // if (_selectedImage == null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: PropStockButton(
                      text: "Take a picture",
                      disabled: false,
                      onPressed: () {
                        // updateProfile();
                        _pickImageFromCamera();
                      }),
                ),
                // if (_selectedImage == null)
                SizedBox(
                  height: 10,
                ),

                // if (_selectedImage == null)
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        _pickImageFromGallery();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: MyColors.primary,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Text(
                          "Upload From Gallery",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: MyColors.primary,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
