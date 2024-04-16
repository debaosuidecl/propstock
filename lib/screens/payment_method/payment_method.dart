import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/screens/payment_method/debit_cards.dart';
import 'package:propstock/widgets/propstock_button.dart';

class PaymentMethodProfile extends StatefulWidget {
  static const id = "PaymentMethodProfile";
  const PaymentMethodProfile({super.key});

  @override
  State<PaymentMethodProfile> createState() => _PaymentMethodProfileState();
}

class _PaymentMethodProfileState extends State<PaymentMethodProfile> {
  bool loading = false;

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
                  "Payment Method",
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
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, DebitCardsProfile.id);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffCBDFF7)),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: ListTile(
                      leading: SvgPicture.asset("images/CreditCardc.svg"),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: MyColors.primary,
                      ),
                      title: const Text(
                        "Debit cards",
                        style: TextStyle(color: Color(0xff1D3354)),
                      )),
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   margin: const EdgeInsets.symmetric(horizontal: 20),
              //   decoration: BoxDecoration(
              //       border: Border.all(color: const Color(0xffCBDFF7)),
              //       borderRadius: BorderRadius.all(Radius.circular(8))),
              //   child: ListTile(
              //       leading: SvgPicture.asset("images/CreditCardc.svg"),
              //       trailing: Icon(
              //         Icons.arrow_forward_ios_rounded,
              //         color: MyColors.primary,
              //       ),
              //       title: const Text(
              //         "Debit cards",
              //         style: TextStyle(color: Color(0xff1D3354)),
              //       )),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
