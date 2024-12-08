import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/providers/listings.dart';
import 'package:propstock/screens/affiliate/listing.dart';
import 'package:propstock/screens/dashboard.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class UploadPropertyDocument extends StatefulWidget {
  static const id = "UploadPropertyDocument";
  const UploadPropertyDocument({super.key});

  @override
  State<UploadPropertyDocument> createState() => _UploadPropertyDocumentState();
}

class _UploadPropertyDocumentState extends State<UploadPropertyDocument> {
  bool loading = false;

  List<PlatformFile> _selectedFiles = [];

  // Future _pickdocfromgallery() async {
  //   final returnedImage =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);

  //   if (returnedImage != null)
  //     setState(() {
  //       _selectedFiles.add(File(returnedImage.path));
  //     });
  // }'

  Future<void> upload() async {
    try {
      setState(() {
        loading = true;
      });

      await Provider.of<ListingsProvider>(context, listen: false).upload();

      print("all good");
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (ctx) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              height: 500,
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Uploaded Successfully",
                    style: TextStyle(
                      color: Color(0xff011936),
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      fontFamily: "Inter",
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SvgPicture.asset("images/success_circle.svg"),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Your listing will be published within 12 hours, after document has be verified.",
                    style: TextStyle(
                      color: Color(0xff5E6D85),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      fontFamily: "Inter",
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  PropStockButton(
                      text: "Done",
                      disabled: false,
                      onPressed: () async {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            AffiliateListing.id,
                            ModalRoute.withName(Dashboard.id));

                        // var res =
                        // await Navigator.pushNamed(context, VerifyIdentity.id);

                        // if (res == "success") {
                        //   Navigator.pop(context);
                        // }
                      })
                ],
              ),
            );
          });
    } catch (e) {
      showErrorDialog(e.toString(), context);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _pickdocfromgallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFiles.add(result.files.single);
      });
    } else {
      // User canceled the picker
    }
  }

  bool disabledFunc() {
    return _selectedFiles.isEmpty;
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
                  "Upload Property Documents",
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
                  "The following are the list of property documents that you are to upload:",
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
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 4,
                          width: 4,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text("Digital Floor Plan",
                            style: TextStyle(
                              color: Color(0xff1D3354),
                              fontFamily: "Inter",
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 4,
                          width: 4,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text("Survey Plan",
                            style: TextStyle(
                              color: Color(0xff1D3354),
                              fontFamily: "Inter",
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 4,
                          width: 4,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text("Governor's Consent",
                            style: TextStyle(
                              color: Color(0xff1D3354),
                              fontFamily: "Inter",
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 4,
                          width: 4,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text("Certificate of Occupancy (C of O)",
                            style: TextStyle(
                              color: Color(0xff1D3354),
                              fontFamily: "Inter",
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 4,
                          width: 4,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text("Building Plan Approval",
                            style: TextStyle(
                              color: Color(0xff1D3354),
                              fontFamily: "Inter",
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 4,
                          width: 4,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text("Deed of Assignment",
                            style: TextStyle(
                              color: Color(0xff1D3354),
                              fontFamily: "Inter",
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                        onTap: () {
                          _pickdocfromgallery();
                        },
                        child: SvgPicture.asset("images/uploadmultidoc.svg")),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 200, // Specify the maximum height
                      ),
                      child: ListView.builder(
                          // physics: NeverScrollableScrollPhysics(),
                          // scrollDirection: NeverScrollableScrollPhysics(),
                          itemCount: _selectedFiles.length,
                          itemBuilder: (context, index) {
                            var item = _selectedFiles[index];
                            return Column(
                              children: [
                                ListTile(
                                  title: Text("${item.name}"),
                                  contentPadding: EdgeInsets.zero,
                                  trailing: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedFiles.remove(item);
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Color(0xffbbbbbb),
                                    ),
                                  ),
                                ),
                                Divider()
                              ],
                            );
                          }),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    if (loading)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: LinearProgressIndicator(),
                      ),
                    if (loading)
                      SizedBox(
                        height: 40,
                      ),
                    PropStockButton(
                        text: "Upload",
                        disabled: _selectedFiles.isEmpty || loading,
                        onPressed: () {
                          Provider.of<ListingsProvider>(context, listen: false)
                              .titleDocumentFiles = _selectedFiles;

                          upload();
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
