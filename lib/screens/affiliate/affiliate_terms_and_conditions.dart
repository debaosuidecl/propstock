import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/screens/affiliate/sign_exclusivity_form.dart';
import 'package:propstock/widgets/PdfViewerCachedFromURL.dart';
import 'package:propstock/widgets/propstock_button.dart';

class AffiliateTermsAndConditions extends StatefulWidget {
  static const id = "affiliate_terms_and_conditions";
  const AffiliateTermsAndConditions({super.key});

  @override
  State<AffiliateTermsAndConditions> createState() =>
      _AffiliateTermsAndConditionsState();
}

class _AffiliateTermsAndConditionsState
    extends State<AffiliateTermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Affiliate terms and conditions",
          style: TextStyle(
            color: Color(0xff011936),
            fontSize: 18,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.close, color: Color(0xff011936)),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Terms and Conditions",
            style: TextStyle(
                fontFamily: "Inter",
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: Color(0xff011936)),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: PDFViewerCachedFromURL(
                url:
                    "https://jawfish-good-lioness.ngrok-free.app/images/terms.pdf"),
          ),
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * .19,
            child: ListView(children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: PropStockButton(
                    text: "Accept",
                    disabled: false,
                    onPressed: () {
                      Navigator.pushNamed(context, SignExclusivityForm.id);
                      // updateProfile();
                      // _pickImageFromCamera();
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      // _pickImageFromGallery();
                      Navigator.pop(context);
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
                        "Decline",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: MyColors.primary,
                        ),
                      ),
                    ),
                  )),
            ]),
          ),
        ],
      ),
    );
  }
}
