import 'package:flutter/material.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/wallet.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/providers/portfolio.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class TopUpPage1 extends StatefulWidget {
  @override
  State<TopUpPage1> createState() => _TopUpPage1State();
}

class _TopUpPage1State extends State<TopUpPage1> {
  bool loading = true;

  bool fullHeight = false;

  FocusNode _focusNode = FocusNode();
  TextEditingController _controller = TextEditingController();
  late Wallet? _wallet;
  double _amount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _wallet =
          Provider.of<PortfolioProvider>(context, listen: false).selectedWallet;

      loading = false;
    });

    // _fetchUserBanks();
  }

  bool isDouble(String text) {
    try {
      double.parse(text);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(_focusNode.hasFocus);
    return GestureDetector(
      onTap: () {
        print("hit detector");
        FocusScope.of(context).unfocus();
      },
      child: Container(
        color: Colors.white,
        height:
            _focusNode.hasFocus ? MediaQuery.of(context).size.height * .8 : 360,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            height: 40,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: MyColors.neutralblack,
                ),
              ),
              const Expanded(
                child: Text(
                  "Amount to top up",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Inter",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          TextField(
            controller: _controller,
            focusNode: _focusNode,

            // obscureText: obscuringText,
            onChanged: (String val) {
              if (!isDouble(val)) return;
              setState(() {
                if (val.isNotEmpty) {
                  _amount = double.parse(val);
                } else {
                  _amount = 0;
                }
              });
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              label: Text('Enter amount (${_wallet!.currency}) '),
              hintStyle: TextStyle(color: Color(0xffbbbbbb)),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xffCBDFF7),
                ), // Use the hex color
                borderRadius: BorderRadius.circular(
                    8), // You can adjust the border radius as needed
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          PropStockButton(
              text: "Add Cash",
              disabled: _amount <= 0,
              onPressed: () {
                Provider.of<PaymentProvider>(context, listen: false)
                    .setTopUpPayment(_amount);
                Navigator.pop(context, "top_up_page_2");
              })
        ]),
      ),
    );
  }
}
