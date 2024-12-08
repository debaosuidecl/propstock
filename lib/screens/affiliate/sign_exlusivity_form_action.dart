import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/affiliate/signature_canvas.dart';
import 'package:propstock/screens/affiliate/text_sign.dart';
import 'package:propstock/screens/verify_identity/identityUpload.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/PDFViewerCachedFromURL.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class SignExclusivityFormAction extends StatefulWidget {
  static const id = "SignExclusivityFormAction";
  const SignExclusivityFormAction({super.key});

  @override
  State<SignExclusivityFormAction> createState() =>
      _SignExclusivityFormActionState();
}

class _SignExclusivityFormActionState extends State<SignExclusivityFormAction> {
  bool loading = false;
  int? _page = 0;
  int? _total = 0;
  PDFViewController? _pdfViewController;

  Uint8List? signImage;
  double xPosition = 100;
  double yPosition = 100;
  bool clickedSignImg = false;
  String signText = "";
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  bool disabledFunc() {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            // height: 30,
            width: 80,
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () async {
                // Navigator
                // print("hey");
                if (loading) return;

                if (signImage == null && signText.isEmpty) {
                  return showErrorDialog(
                      "You have to sign before you continue", context);
                }
                try {
                  // await
                  setState(() {
                    loading = true;
                  });
                  await Provider.of<Auth>(context, listen: false)
                      .signForm(signImage, signText);
                  await Provider.of<Auth>(context, listen: false)
                      .tryAutoLogin();
                  Navigator.pop(context);
                } catch (e) {
                  print("hit here");
                  showErrorDialog(e.toString(), context);
                } finally {
                  setState(() {
                    loading = false;
                  });
                }
              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                width: 80,
                alignment: Alignment.center,
                height: 30,
                decoration: BoxDecoration(
                  color: MyColors.primary,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Text(
                  "Done",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
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
          setState(() {
            clickedSignImg = false;
          });
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * .78,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                if (loading) LinearProgressIndicator(),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Sign Exclusivity Form",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff1D3354),
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Kindly read through and sign if you agree",
                          style: TextStyle(
                            color: Color(0xff5E6D85),
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (signImage != null || signText.isNotEmpty)
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () async {
                                  if (signImage != null) {
                                    var res = await Navigator.pushNamed(
                                        context, SignatureCanvasPage.id);

                                    if (res != null) {
                                      print(res);
                                      setState(() {
                                        signText = "";
                                      });
                                      setState(() {
                                        signImage = res as Uint8List?;
                                      });
                                    }
                                  }

                                  if (signText.isNotEmpty) {
                                    var res = await Navigator.pushNamed(
                                        context, TextSignAffiliate.id);

                                    if (res != null) {
                                      setState(() {
                                        signText = res as String;
                                        signImage = null;
                                      });
                                    }
                                  }
                                },
                                child: SvgPicture.asset("images/penb.svg")),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    signImage = null;
                                    signText = "";
                                  });
                                },
                                child: SvgPicture.asset("images/delimg.svg")),
                          ],
                        )
                    ],
                  ),
                ),
                // HorizontalLine(y: 1),
                const Divider(),
                const SizedBox(
                  height: 30,
                ),
                // Expanded(
                //   child: PDFViewerCachedFromURL(
                //       url:
                //           "https://jawfish-good-lioness.ngrok-free.app/images/terms.pdf"),
                // ),

                Expanded(
                  child: Stack(
                    children: [
                      PDF(
                        // enableSwipe: true,
                        swipeHorizontal: true,
                        // autoSpacing: false,
                        // pageFling: false,
                        onError: (error) {
                          print(error.toString());
                        },
                        onViewCreated:
                            (PDFViewController pdfViewController) async {
                          // _controller.complete(pdfViewController);

                          _pdfViewController = pdfViewController;
                          int? page = await pdfViewController.getCurrentPage();
                          int? total = await pdfViewController.getPageCount();
                          setState(() {
                            _page = page;
                            _total = total;
                          });
                        },
                        onPageError: (page, error) {
                          print('$page: ${error.toString()}');
                        },
                        onPageChanged: (int? page, int? total) {
                          print('page change: $page/$total');

                          setState(() {
                            _page = page;
                            _total = total;
                          });
                        },
                      ).cachedFromUrl(
                          "https://jawfish-good-lioness.ngrok-free.app/images/terms.pdf",
                          placeholder: (double progress) =>
                              Center(child: Text('$progress %')),
                          errorWidget: (dynamic error) =>
                              Center(child: Text(error.toString()))),
                      if (signImage != null)
                        Positioned(
                          bottom: yPosition,
                          right: xPosition,
                          child: GestureDetector(
                              onPanUpdate: (details) {
                                setState(() {
                                  clickedSignImg = true;
                                });
                                setState(() {
                                  xPosition -= details.delta.dx;
                                  yPosition -= details.delta.dy;
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: clickedSignImg
                                          ? Border.all(
                                              color: MyColors.neutralGrey)
                                          : null),
                                  child: Image.memory(signImage!))),
                          height: 50,
                        ),
                      if (signText.isNotEmpty)
                        Positioned(
                          bottom: yPosition,
                          right: xPosition,
                          child: GestureDetector(
                              onPanUpdate: (details) {
                                setState(() {
                                  clickedSignImg = true;
                                });
                                setState(() {
                                  xPosition -= details.delta.dx;
                                  yPosition -= details.delta.dy;
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: clickedSignImg
                                          ? Border.all(
                                              color: MyColors.neutralGrey)
                                          : null),
                                  child: Text(
                                    signText,
                                    style: TextStyle(
                                      fontFamily: "Creation",
                                      fontSize: 40,
                                    ),
                                  ))),
                          height: 50,
                        ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 15,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          if (_page! > 0) {
                            _pdfViewController!.setPage(_page! - 1);
                          }
                        },
                        child: SvgPicture.asset("images/left_blue.svg")),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${_page! + 1}",
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff1D3354),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Inter"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("/"),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${_total!}",
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff1D3354),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Inter"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          _pdfViewController!.setPage(_page! + 1);
                        },
                        child: SvgPicture.asset("images/right_blue.svg"))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Add signature",
                      style: TextStyle(
                        color: Color(0xff1D3354),
                        fontFamily: "Inter",
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        var res = await Navigator.pushNamed(
                            context, SignatureCanvasPage.id);

                        if (res != null) {
                          print(res);
                          setState(() {
                            signText = "";
                          });
                          setState(() {
                            signImage = res as Uint8List?;
                          });
                        }
                      },
                      child: Container(
                        height: 56,
                        width: 83,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: MyColors.primary),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Column(children: [
                          SizedBox(
                            height: 10,
                          ),
                          SvgPicture.asset("images/sign.svg"),
                          SizedBox(
                            height: 4,
                          ),
                          Text("Sign")
                        ]),
                      ),
                    ),
                    // Container(
                    //   height: 56,
                    //   width: 83,
                    //   alignment: Alignment.center,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: MyColors.primary),
                    //     borderRadius: BorderRadius.all(Radius.circular(4)),
                    //   ),
                    //   child: Column(children: [
                    //     SizedBox(
                    //       height: 10,
                    //     ),
                    //     SvgPicture.asset("images/upload.svg"),
                    //     SizedBox(
                    //       height: 7,
                    //     ),
                    //     Text("Upload")
                    //   ]),
                    // ),
                    GestureDetector(
                      onTap: () async {
                        // setState(() {
                        //   clickedSignImg = true;
                        // });
                        var res = await Navigator.pushNamed(
                            context, TextSignAffiliate.id);

                        if (res != null) {
                          setState(() {
                            signText = res as String;
                            signImage = null;
                          });
                        }
                      },
                      child: Container(
                        height: 56,
                        width: 83,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: MyColors.primary),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Column(children: [
                          SizedBox(
                            height: 10,
                          ),
                          SvgPicture.asset("images/Aa.svg"),
                          SizedBox(
                            height: 2,
                          ),
                          Text("Text")
                        ]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
