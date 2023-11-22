// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:propstock/providers/buy.dart';
import 'package:propstock/providers/investments.dart';
import 'package:propstock/providers/payment.dart';
import 'package:propstock/providers/portfolio.dart';
import 'package:propstock/providers/property.dart';
import 'package:propstock/screens/assets/assets.dart';
import 'package:propstock/screens/bank_account/add_bank_account.dart';
import 'package:propstock/screens/bank_account/confirm_bank_account.dart';
import 'package:propstock/screens/buy_property/buy_property_detail.overview.dart';
import 'package:propstock/screens/buy_property/buy_property_units_page.dart';
import 'package:propstock/screens/buy_property/co_buy.dart';
import 'package:propstock/screens/buy_property/co_buy_final_page.dart';
import 'package:propstock/screens/buy_property/doc_handover.dart';
import 'package:propstock/screens/buy_property/filter_buy_property.dart';
import 'package:propstock/screens/buy_property/send_property_as_gifts.dart';
import 'package:propstock/screens/create_new_pin.dart';
import 'package:propstock/screens/create_new_pin_confirm.dart';
import 'package:propstock/screens/dashboard.dart';
import 'package:propstock/screens/email_code_verify.dart';
import 'package:propstock/screens/filter_dashboard.dart';
import 'package:propstock/screens/forgot_password.dart';
import 'package:propstock/screens/forgot_pin.dart';
import 'package:propstock/screens/friends/myfriends.dart';
import 'package:propstock/screens/got_verification_mail.dart';
import 'package:propstock/screens/income_range.dart';
import 'package:propstock/screens/invest/co_invest.dart';
import 'package:propstock/screens/invest/co_invest_final.dart';
import 'package:propstock/screens/invest/send_investment_as_gifts.dart';
import 'package:propstock/screens/investment_experience.dart';
import 'package:propstock/screens/investment_portfolio/investment_portolio_sub_screen.dart';
import 'package:propstock/screens/investments/friend_gift_finalize.dart';
import 'package:propstock/screens/investments/investements.dart';
import 'package:propstock/screens/investments/investment_details.dart';
import 'package:propstock/screens/investments/market_place_seller.dart';
import 'package:propstock/screens/investments/sell_investments_preview.dart';
import 'package:propstock/screens/loading_screen.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/location_select.dart';
import 'package:propstock/screens/marketplace/market_place.dart';
import 'package:propstock/screens/notifications/notifications.dart';
import 'package:propstock/screens/onboarding.dart';
import 'package:propstock/screens/payment_card/add_card.dart';
import 'package:propstock/screens/primary_goal.dart';
import 'package:propstock/screens/property_all_investment_type.dart';
import 'package:propstock/screens/property_detail/property_detail.dart';
import 'package:propstock/screens/property_preference.dart';
import 'package:propstock/screens/sign_in_pin.dart';
import 'package:propstock/screens/sign_in_with_password.dart';
import 'package:propstock/screens/signup.dart';
import 'package:propstock/screens/invest/buy_units_invest_page.dart';
import 'package:propstock/screens/verify_account/verify_account.dart';
import 'package:propstock/screens/wallet/switch_cards.dart';
import 'package:propstock/screens/wallet/wallet_transaction_page.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => PropertyProvider()),
        ChangeNotifierProvider(create: (context) => PaymentProvider()),
        ChangeNotifierProvider(create: (context) => PortfolioProvider()),
        ChangeNotifierProvider(create: (context) => InvestmentsProvider()),
        ChangeNotifierProvider(create: (context) => BuyPropertyProvider()),
      ],
      child: OverlaySupport(
        child: MaterialApp(
          title: 'Propstock',
          theme: ThemeData(
              // useMaterial3: true,
              iconTheme: const IconThemeData(color: Colors.deepOrange),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 0, 12, 29),
                  padding: const EdgeInsets.symmetric(vertical: 19),
                  elevation: 5,
                ),
              )),
          home: const LoadingScreen(),
          debugShowCheckedModeBanner: false,
          routes: {
            LoadingScreen.id: (context) => const LoadingScreen(),
            LocationSelect.id: (context) => const LocationSelect(),
            SignUp.id: (context) => const SignUp(),
            EmailCodeVerify.id: (context) => const EmailCodeVerify(),
            OnBoarding.id: (context) => const OnBoarding(),
            InvestmentExperience.id: (context) => const InvestmentExperience(),
            IncomeRange.id: (context) => const IncomeRange(),
            PrimaryGoal.id: (context) => const PrimaryGoal(),
            PropertyPreference.id: (context) => const PropertyPreference(),
            Dashboard.id: (context) => const Dashboard(),
            SignInPin.id: (context) => const SignInPin(),
            SignInWithPassword.id: (context) => const SignInWithPassword(),
            ForgotPin.id: (context) => const ForgotPin(),
            CreateNewPin.id: (context) => const CreateNewPin(),
            CreateNewPinConfirm.id: (context) => const CreateNewPinConfirm(),
            ForgotPassword.id: (context) => const ForgotPassword(),
            GotVerificationMail.id: (context) => const GotVerificationMail(),
            PageFilter.id: (context) => const PageFilter(),
            PropertyAllInvestmentType.id: (context) =>
                PropertyAllInvestmentType(),
            PropertyDetail.id: (context) => const PropertyDetail(),
            BuyUnitsInvestPage.id: (context) => const BuyUnitsInvestPage(),
            AddCard.id: (context) => const AddCard(),
            Investments.id: (context) => const Investments(),
            SendInvestmentAsGift.id: (context) => const SendInvestmentAsGift(),
            CoInvest.id: (context) => const CoInvest(),
            CoInvestFinalPage.id: (context) => const CoInvestFinalPage(),
            InvestmentDetails.id: (context) => const InvestmentDetails(),
            MarketPlaceSeller.id: (context) => const MarketPlaceSeller(),
            SellInvestmentsPreview.id: (context) =>
                const SellInvestmentsPreview(),
            MarketPlace.id: (context) => const MarketPlace(),
            VerifyAccount.id: (context) => const VerifyAccount(),
            FriendGiftFinalize.id: (context) => const FriendGiftFinalize(),
            AddBankAccount.id: (context) => const AddBankAccount(),
            ConfirmBankAccount.id: (context) => const ConfirmBankAccount(),
            InvestmentPortfolioSubScreen.id: (context) =>
                const ConfirmBankAccount(),
            SwitchCards.id: (context) => SwitchCards(),
            WalletTransactionPage.id: (context) =>
                const WalletTransactionPage(),
            FilterBuyProperty.id: (context) => const FilterBuyProperty(),
            BuyPropertyDetailOverview.id: (context) =>
                const BuyPropertyDetailOverview(),
            BuyPropertyUnitsPage.id: (context) => const BuyPropertyUnitsPage(),
            DocumentHandover.id: (context) => const DocumentHandover(),
            SendPropertyAsGift.id: (context) => const SendPropertyAsGift(),
            CoBuy.id: (context) => const CoBuy(),
            CoBuyFinalPage.id: (context) => const CoBuyFinalPage(),
            Assets.id: (context) => const Assets(),
            MyFriends.id: (context) => const MyFriends(),
            NotificationsPage.id: (context) => const NotificationsPage()
            // SingleFriend.id: (context) => SingleFriend(),
          },
        ),
      ),
    );
  }
}
