import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:propstock/models/card.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/wallet.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/providers/portfolio.dart';
import 'package:propstock/screens/payment_card/add_card.dart';
import 'package:propstock/screens/wallet/card_component.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class SwitchCards extends StatefulWidget {
  static const id = "switch_cards";
  @override
  State<SwitchCards> createState() => _SwitchCardsState();
}

class _SwitchCardsState extends State<SwitchCards> {
  bool _loading = true;
  bool _isProcessing = false;

  FocusNode _focusNode = FocusNode();
  TextEditingController _controller = TextEditingController();
  late Wallet? _wallet;
  List<CardModel> _cards = [];
  double _amount = 0;

  String paystackPublicKey = 'pk_test_143fd324876738add7122e3f4adf935c8e243812';
  final plugin = PaystackPlugin();

  bool _processing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    plugin.initialize(publicKey: paystackPublicKey);

    setState(() {
      _wallet =
          Provider.of<PortfolioProvider>(context, listen: false).selectedWallet;

      _loading = false;
    });

    _initPaymentoptions();
  }

  Future<void> _initPaymentoptions() async {
    try {
      // get user cards
      await Provider.of<PaymentProvider>(context, listen: false)
          .fetchCustomerCard();

      setState(() {
        _cards = Provider.of<PaymentProvider>(context, listen: false).userCards;
      });
    } catch (e) {
      showErrorDialog(e.toString(), context);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> makePayment(CardModel? _paymentcard,
      {double? temporarychargePrice}) async {
    setState(() {
      _processing = true;
    });

    print("temp time");
    Charge charge = Charge()
      ..amount = double.parse("$temporarychargePrice").ceil()
      ..reference = "ref_${DateTime.now()}_debalini"
      ..email = Provider.of<Auth>(context, listen: false).email
      ..currency = "NGN";

    final String accesscode =
        await Provider.of<PaymentProvider>(context, listen: false)
            .initializePaystackPayment(
                double.parse("$temporarychargePrice").ceil(),
                verify: true);

    print(accesscode);

    // charge.locale = ""

    // return;

    charge.accessCode = accesscode;

    try {
      CheckoutResponse response = await plugin.checkout(
        context,
        charge: charge,
        fullscreen: true,
        method: CheckoutMethod.card,
      );
      print(111);
      print(response);
      if (response.status == true) {
        print(response.message);
        _initPaymentoptions();
      } else {
        print(response.message);
      }
    } catch (e) {
      setState(() {
        _processing = false;
      });
      print(e);
      showErrorDialog("could not start paystack payment", context);
    } finally {
      setState(() {
        _processing = false;
      });
    }
  }

  void _showAlertDialog(BuildContext context, String title, String description,
      {bool? startPayment}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () {
                // Close the AlertDialog when the "OK" button is pressed
                if (startPayment == true) {
                  makePayment(null, temporarychargePrice: 5000);
                  Navigator.of(context).pop();
                } else {}
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? CircularProgressIndicator()
        : GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              //
            },
            child: Container(
              color: Colors.white,
              height: _focusNode.hasFocus
                  ? MediaQuery.of(context).size.height * .8
                  : 360,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context, 'top_up_page_2');
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: MyColors.neutralblack,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            "Your Cards",
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
                      height: 10,
                    ),
                    if (_isProcessing) const LinearProgressIndicator(),
                    const SizedBox(
                      height: 31,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: _cards.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CardComponent(card: _cards[index]),
                                    GestureDetector(
                                      onTap: () async {
                                        // switch card algo
                                        setState(() {
                                          _isProcessing = true;
                                        });

                                        try {
                                          await Provider.of<PaymentProvider>(
                                                  context,
                                                  listen: false)
                                              .setCardAsDefault(_cards[index]);

                                          Navigator.pop(
                                              context, "top_up_page_2");
                                        } catch (e) {
                                          showErrorDialog(
                                              e.toString(), context);
                                        } finally {
                                          setState(() {
                                            _isProcessing = false;
                                          });
                                        }
                                      },
                                      child: Text(
                                        "Switch",
                                        style: TextStyle(
                                          fontFamily: "Inter",
                                          color: MyColors.primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                    ),
                    // PropStockButton(
                    //     text: "Add Cash",
                    //     disabled: _amount <= 0,
                    //     onPressed: () {
                    //       Navigator.pop(context, "top_up_page_2");
                    //     }),
                    GestureDetector(
                      onTap: () {
                        // makePayment(null, temporarychargePrice: 5000);
                        _showAlertDialog(
                          context,
                          'ADDING CARD',
                          'To add a card press "OK". note you will be temporarily charged NGN 50.00 and will be refunded within 24 hours. if the card is not added after the operation, then the card is not reusable and you should go back and pay with paystack\'s one time payment feature in the previous screen ',
                          startPayment: true,
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "+",
                                  style: TextStyle(
                                    color: MyColors.primary,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Add a new card",
                                  style: TextStyle(
                                    color: MyColors.primary,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _showAlertDialog(
                                      context,
                                      'Info on adding a new card',
                                      'You will be charged NGN 50.00 temporarily for adding a card. your funds will be automatically refunded within 24 hours. Card may not be added if deemed unreusable by paystack but do not worry, the funds will be refunded. ',
                                    );
                                  },
                                  child: Icon(
                                    Icons.info_outline,
                                    color: Color(0xffbbbbbb),
                                  ),
                                )
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context, "wallet_pre");
                              },
                              child: Icon(
                                Icons.keyboard_arrow_right_rounded,
                                color: MyColors.neutralGrey,
                                size: 27,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ]),
            ),
          );
  }
}
