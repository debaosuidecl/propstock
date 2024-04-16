import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/market_place.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/providers/investments.dart';
import 'package:propstock/providers/marketplace.dart';
import 'package:propstock/screens/dashboard.dart';
import 'package:propstock/screens/investments/investements.dart';
import 'package:propstock/screens/marketplace/bid_success.dart';
import 'package:propstock/screens/marketplace/market_place.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/market_product_card.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class MarketBidModal extends StatefulWidget {
  final MarketPlaceProduct marketPlaceProduct;
  const MarketBidModal({
    super.key,
    required this.marketPlaceProduct,
  });

  @override
  State<MarketBidModal> createState() => _MarketBidModalState();
}

class _MarketBidModalState extends State<MarketBidModal> {
  bool _success = false;
  String _amount = "";
  bool _loading = false;

  TextEditingController _controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    Future<dynamic> _submitBid() async {
      try {
        setState(() {
          _loading = true;
        });
        final bidSubmission =
            await Provider.of<MarketPlaceProvider>(context, listen: false)
                .placeBid(_amount, widget.marketPlaceProduct.currency,
                    widget.marketPlaceProduct.productid);

        print(bidSubmission);

        setState(() {
          _success = true;
        });
      } catch (e) {
        showErrorDialog(e.toString(), context);
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }

    NumberFormat formatter = NumberFormat.currency(
        locale: 'en_US',
        symbol: "${widget.marketPlaceProduct.property.currency} ");

    String recommendedPrice = formatter.format(widget.marketPlaceProduct.price);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: _success
            ? 450
            : MediaQuery.of(context).size.height * .8 +
                MediaQuery.of(context).viewInsets.bottom,
        child: _success
            ? BidSuccess()
            : SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset("images/back_arrow.svg"),
                          Expanded(
                              child: Container(
                            // color: Colors.blue,
                            child: Text(
                              "Place a Bid",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: MyColors.secondary,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                          )),
                          // SvgPicture.asset("images/close_icon.svg"),
                          Text(
                            "----",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 3),
                        width: double.infinity,
                        child: MarketProductCard(
                          notClickable: true,
                          property: widget.marketPlaceProduct.property,
                          marketplace: widget.marketPlaceProduct,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 76,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xffCBDFF7),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Recommended Price",
                                  style: TextStyle(
                                    color: MyColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Inter",
                                  ),
                                ),
                                Text(
                                  recommendedPrice,
                                  // "${widget.marketPlaceProduct.currency} ${widget.marketPlaceProduct.price}",
                                  style: TextStyle(
                                    color: MyColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Inter",
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Co-invest with friends?",
                          style: TextStyle(
                            color: MyColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "How much do you want to pay? (${widget.marketPlaceProduct.property.currency})",
                          style: TextStyle(
                            color: Color(0xff5E6D85),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          onChanged: (String val) {
                            setState(() {
                              // firstName = val;
                              _amount = val;
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            // label: Text('First Name'),
                            hintStyle: TextStyle(color: Color(0xffCBDFF7)),
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
                        height: 10,
                      ),

                      if (_loading)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: LinearProgressIndicator(),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: PropStockButton(
                          text: "Submit",
                          disabled: _loading || _amount.isEmpty,
                          onPressed: _submitBid,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context)
                              .viewInsets
                              .bottom), // Adjust bottom inset
                    ]),
              ),
      ),
    );
  }
}
