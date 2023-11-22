import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/bank.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class BankListModal extends StatefulWidget {
  const BankListModal({super.key});

  @override
  State<BankListModal> createState() => _BankListModalState();
}

class _BankListModalState extends State<BankListModal> {
  List<Bank> _banks = [];
  List<Bank> _variableBanks = [];
  bool _loading = true;
  TextEditingController _controller = TextEditingController();
  bool _processing = false;

  Bank _selectedBank = Bank(name: "", code: "");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fetchBanks();
  }

  Future<void> _fetchBanks() async {
    try {
      List<Bank> banks =
          await Provider.of<PaymentProvider>(context, listen: false)
              .fetchBanks();
      setState(() {
        _banks = banks;
        _variableBanks = banks;
      });
    } catch (e) {
      showErrorDialog("Could not fetch banks", context);
    } finally {
      _loading = false;
      _processing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .95,
      child: Column(children: [
        Container(
          height: 64,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: MyColors.primary,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: SvgPicture.asset("images/mdi_close.svg"),
                ),
              ),
              Expanded(
                child: Text(
                  "Select Bank",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  right: 30,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 40,
        ),
        if (_loading) CircularProgressIndicator(),
        if (!_loading)
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: TextField(
              controller: _controller,
              // focusNode: _focusNode,
              // obscureText: obscuringText,
              onChanged: (String val) {
                setState(() {
                  // _accountNumber = val;
                  if (val.isEmpty) {
                    _variableBanks = _banks;
                  } else {
                    _variableBanks = _banks
                        .where((bank) =>
                            bank.name.toLowerCase().contains(val.toLowerCase()))
                        .toList();
                  }
                });
              },
              // keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                label: Text('Find bank'),
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
          ),
        if (_processing)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: LinearProgressIndicator(),
          ),
        if (!_loading)
          Expanded(
            child: ListView.builder(
              itemCount: _variableBanks.length,
              itemBuilder: (context, index) {
                Bank bank = _variableBanks[index];
                return GestureDetector(
                  onTap: () {
                    Provider.of<PaymentProvider>(context, listen: false)
                        .setSelectedBank(bank);
                    Navigator.pop(context, bank);

                    // setState(() {
                    //   _selectedBank = bank;
                    //   // _processing = true;
                    // });

                    // reach back end to determine owner of account
                  },
                  child: Container(
                    // height: 30,
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: bank == _selectedBank
                            ? MyColors.primary
                            : Color(0xffbbbbbb),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Text(
                      bank.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Inter",
                        color: MyColors.neutralblack,
                      ),
                    ),
                  ),
                );
              },
            ),
          )
      ]),
    );
  }
}
