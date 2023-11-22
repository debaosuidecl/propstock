import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/user_investment.dart';
import 'package:propstock/providers/investments.dart';
import 'package:propstock/screens/dashboard.dart';
import 'package:propstock/screens/investments/investements.dart';
import 'package:propstock/screens/marketplace/market_place.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';

class MarketPlaceUploadModal extends StatefulWidget {
  final UserInvestment investment;
  const MarketPlaceUploadModal({
    super.key,
    required this.investment,
  });

  @override
  State<MarketPlaceUploadModal> createState() => _MarketPlaceUploadModalState();
}

class _MarketPlaceUploadModalState extends State<MarketPlaceUploadModal> {
  bool _success = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _success ? 450 : 350,
      child: Column(children: [
        const SizedBox(
          height: 40,
        ),
        Text(
          "${_success ? 'Upload Successful' : 'Upload to Marketplace'}",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: "Inter",
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        if (_success) SvgPicture.asset("images/success_circle.svg"),
        if (_success)
          const SizedBox(
            height: 20,
          ),
        Container(
          width: MediaQuery.of(context).size.width * .8,
          child: Text(
            _success
                ? "You can now find this investment under market place"
                : "You are about to upload this investment to the market place for sale. Note that changes cannot be made once uploaded.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: "Inter",
              color: MyColors.neutral,
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        if (_loading)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: LinearProgressIndicator(),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
          child: PropStockButton(
              text: _success ? "View in Marketplace" : "Accept & Continue",
              disabled: _loading,
              onPressed: () async {
                try {
                  if (_success) {
                    Navigator.pushNamedAndRemoveUntil(context, MarketPlace.id,
                        (route) {
                      return route.settings.name == Dashboard.id;
                    });
                  } else {
                    setState(() {
                      _loading = true;
                    });
                    await Provider.of<InvestmentsProvider>(context,
                            listen: false)
                        .uploadPropertyToMarketPlace(widget.investment);

                    setState(() {
                      _success = true;
                    });
                  }
                } catch (e) {
                  showErrorDialog(e.toString(), context);
                } finally {
                  setState(() {
                    _loading = false;
                  });
                }
              }),
        )
      ]),
    );
  }
}
