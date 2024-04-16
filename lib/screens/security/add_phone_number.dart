import 'dart:convert';
// import 'dart:js_interop';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/country.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/screens/forgot_password.dart';
import 'package:propstock/screens/security/reset_password_final.dart';
import 'package:propstock/screens/security/verifyPhone.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPhoneNumber2fa extends StatefulWidget {
  static const id = "addphonenumber2fa";
  const AddPhoneNumber2fa({super.key});

  @override
  State<AddPhoneNumber2fa> createState() => _AddPhoneNumber2faState();
}

class _AddPhoneNumber2faState extends State<AddPhoneNumber2fa> {
  bool enabledBio = false;
  late final LocalAuthentication auth;
  // bool _supportState = false;
  bool obscureText = true;
  bool loading = false;
  final List<Map<String, dynamic>> countries = [
    {
      "name": "Afghanistan",
      "code": "+93",
      "flag": "🇦🇫",
      "abbreviation": "AF"
    },
    {"name": "Albania", "code": "+355", "flag": "🇦🇱", "abbreviation": "AL"},
    {"name": "Algeria", "code": "+213", "flag": "🇩🇿", "abbreviation": "DZ"},
    {"name": "Andorra", "code": "+376", "flag": "🇦🇩", "abbreviation": "AD"},
    {"name": "Angola", "code": "+244", "flag": "🇦🇴", "abbreviation": "AO"},
    {
      "name": "Antigua and Barbuda",
      "code": "+1-268",
      "flag": "🇦🇬",
      "abbreviation": "AG"
    },
    {"name": "Argentina", "code": "+54", "flag": "🇦🇷", "abbreviation": "AR"},
    {"name": "Armenia", "code": "+374", "flag": "🇦🇲", "abbreviation": "AM"},
    {"name": "Australia", "code": "+61", "flag": "🇦🇺", "abbreviation": "AU"},
    {"name": "Austria", "code": "+43", "flag": "🇦🇹", "abbreviation": "AT"},
    {
      "name": "Azerbaijan",
      "code": "+994",
      "flag": "🇦🇿",
      "abbreviation": "AZ"
    },
    {"name": "Bahamas", "code": "+1-242", "flag": "🇧🇸", "abbreviation": "BS"},
    {"name": "Bahrain", "code": "+973", "flag": "🇧🇭", "abbreviation": "BH"},
    {
      "name": "Bangladesh",
      "code": "+880",
      "flag": "🇧🇩",
      "abbreviation": "BD"
    },
    {
      "name": "Barbados",
      "code": "+1-246",
      "flag": "🇧🇧",
      "abbreviation": "BB"
    },
    {"name": "Belarus", "code": "+375", "flag": "🇧🇾", "abbreviation": "BY"},
    {"name": "Belgium", "code": "+32", "flag": "🇧🇪", "abbreviation": "BE"},
    {"name": "Belize", "code": "+501", "flag": "🇧🇿", "abbreviation": "BZ"},
    {"name": "Benin", "code": "+229", "flag": "🇧🇯", "abbreviation": "BJ"},
    {"name": "Bhutan", "code": "+975", "flag": "🇧🇹", "abbreviation": "BT"},
    {"name": "Bolivia", "code": "+591", "flag": "🇧🇴", "abbreviation": "BO"},
    {
      "name": "Bosnia and Herzegovina",
      "code": "+387",
      "flag": "🇧🇦",
      "abbreviation": "BA"
    },
    {"name": "Botswana", "code": "+267", "flag": "🇧🇼", "abbreviation": "BW"},
    {"name": "Brazil", "code": "+55", "flag": "🇧🇷", "abbreviation": "BR"},
    {"name": "Brunei", "code": "+673", "flag": "🇧🇳", "abbreviation": "BN"},
    {"name": "Bulgaria", "code": "+359", "flag": "🇧🇬", "abbreviation": "BG"},
    {
      "name": "Burkina Faso",
      "code": "+226",
      "flag": "🇧🇫",
      "abbreviation": "BF"
    },
    {"name": "Burundi", "code": "+257", "flag": "🇧🇮", "abbreviation": "BI"},
    {
      "name": "Cabo Verde",
      "code": "+238",
      "flag": "🇨🇻",
      "abbreviation": "CV"
    },
    {"name": "Cambodia", "code": "+855", "flag": "🇰🇭", "abbreviation": "KH"},
    {"name": "Cameroon", "code": "+237", "flag": "🇨🇲", "abbreviation": "CM"},
    {"name": "Canada", "code": "+1", "flag": "🇨🇦", "abbreviation": "CA"},
    {
      "name": "Central African Republic",
      "code": "+236",
      "flag": "🇨🇫",
      "abbreviation": "CF"
    },
    {"name": "Chad", "code": "+235", "flag": "🇹🇩", "abbreviation": "TD"},
    {"name": "Chile", "code": "+56", "flag": "🇨🇱", "abbreviation": "CL"},
    {"name": "China", "code": "+86", "flag": "🇨🇳", "abbreviation": "CN"},
    {"name": "Colombia", "code": "+57", "flag": "🇨🇴", "abbreviation": "CO"},
    {"name": "Comoros", "code": "+269", "flag": "🇰🇲", "abbreviation": "KM"},
    {
      "name": "Congo (Congo-Brazzaville)",
      "code": "+242",
      "flag": "🇨🇬",
      "abbreviation": "CG"
    },
    {
      "name": "Congo, Democratic Republic of the",
      "code": "+243",
      "flag": "🇨🇩",
      "abbreviation": "CD"
    },
    {
      "name": "Costa Rica",
      "code": "+506",
      "flag": "🇨🇷",
      "abbreviation": "CR"
    },
    {"name": "Croatia", "code": "+385", "flag": "🇭🇷", "abbreviation": "HR"},
    {"name": "Cuba", "code": "+53", "flag": "🇨🇺", "abbreviation": "CU"},
    {"name": "Cyprus", "code": "+357", "flag": "🇨🇾", "abbreviation": "CY"},
    {
      "name": "Czech Republic",
      "code": "+420",
      "flag": "🇨🇿",
      "abbreviation": "CZ"
    },
    {"name": "Denmark", "code": "+45", "flag": "🇩🇰", "abbreviation": "DK"},
    {"name": "Djibouti", "code": "+253", "flag": "🇩🇯", "abbreviation": "DJ"},
    {
      "name": "Dominica",
      "code": "+1-767",
      "flag": "🇩🇲",
      "abbreviation": "DM"
    },
    {
      "name": "Dominican Republic",
      "code": "+1-809",
      "flag": "🇩🇴",
      "abbreviation": "DO"
    },
    {"name": "Ecuador", "code": "+593", "flag": "🇪🇨", "abbreviation": "EC"},
    {"name": "Egypt", "code": "+20", "flag": "🇪🇬", "abbreviation": "EG"},
    {
      "name": "El Salvador",
      "code": "+503",
      "flag": "🇸🇻",
      "abbreviation": "SV"
    },
    {
      "name": "Equatorial Guinea",
      "code": "+240",
      "flag": "🇬🇶",
      "abbreviation": "GQ"
    },
    {"name": "Eritrea", "code": "+291", "flag": "🇪🇷", "abbreviation": "ER"},
    {"name": "Estonia", "code": "+372", "flag": "🇪🇪", "abbreviation": "EE"},
    {"name": "Eswatini", "code": "+268", "flag": "🇸🇿", "abbreviation": "SZ"},
    {"name": "Ethiopia", "code": "+251", "flag": "🇪🇹", "abbreviation": "ET"},
    {"name": "Fiji", "code": "+679", "flag": "🇫🇯", "abbreviation": "FJ"},
    {"name": "Finland", "code": "+358", "flag": "🇫🇮", "abbreviation": "FI"},
    {"name": "France", "code": "+33", "flag": "🇫🇷", "abbreviation": "FR"},
    {"name": "Gabon", "code": "+241", "flag": "🇬🇦", "abbreviation": "GA"},
    {"name": "Gambia", "code": "+220", "flag": "🇬🇲", "abbreviation": "GM"},
    {"name": "Georgia", "code": "+995", "flag": "🇬🇪", "abbreviation": "GE"},
    {"name": "Germany", "code": "+49", "flag": "🇩🇪", "abbreviation": "DE"},
    {"name": "Ghana", "code": "+233", "flag": "🇬🇭", "abbreviation": "GH"},
    {"name": "Greece", "code": "+30", "flag": "🇬🇷", "abbreviation": "GR"},
    {"name": "Grenada", "code": "+1-473", "flag": "🇬🇩", "abbreviation": "GD"},
    {"name": "Guatemala", "code": "+502", "flag": "🇬🇹", "abbreviation": "GT"},
    {"name": "Guinea", "code": "+224", "flag": "🇬🇳", "abbreviation": "GN"},
    {
      "name": "Guinea-Bissau",
      "code": "+245",
      "flag": "🇬🇼",
      "abbreviation": "GW"
    },
    {"name": "Guyana", "code": "+592", "flag": "🇬🇾", "abbreviation": "GY"},
    {"name": "Haiti", "code": "+509", "flag": "🇭🇹", "abbreviation": "HT"},
    {"name": "Honduras", "code": "+504", "flag": "🇭🇳", "abbreviation": "HN"},
    {"name": "Hungary", "code": "+36", "flag": "🇭🇺", "abbreviation": "HU"},
    {"name": "Iceland", "code": "+354", "flag": "🇮🇸", "abbreviation": "IS"},
    {"name": "India", "code": "+91", "flag": "🇮🇳", "abbreviation": "IN"},
    {"name": "Indonesia", "code": "+62", "flag": "🇮🇩", "abbreviation": "ID"},
    {"name": "Iran", "code": "+98", "flag": "🇮🇷", "abbreviation": "IR"},
    {"name": "Iraq", "code": "+964", "flag": "🇮🇶", "abbreviation": "IQ"},
    {"name": "Ireland", "code": "+353", "flag": "🇮🇪", "abbreviation": "IE"},
    {"name": "Israel", "code": "+972", "flag": "🇮🇱", "abbreviation": "IL"},
    {"name": "Italy", "code": "+39", "flag": "🇮🇹", "abbreviation": "IT"},
    {"name": "Jamaica", "code": "+1-876", "flag": "🇯🇲", "abbreviation": "JM"},
    {"name": "Japan", "code": "+81", "flag": "🇯🇵", "abbreviation": "JP"},
    {"name": "Jordan", "code": "+962", "flag": "🇯🇴", "abbreviation": "JO"},
    {"name": "Kazakhstan", "code": "+7", "flag": "🇰🇿", "abbreviation": "KZ"},
    {"name": "Kenya", "code": "+254", "flag": "🇰🇪", "abbreviation": "KE"},
    {"name": "Kiribati", "code": "+686", "flag": "🇰🇮", "abbreviation": "KI"},
    {"name": "Kuwait", "code": "+965", "flag": "🇰🇼", "abbreviation": "KW"},
    {
      "name": "Kyrgyzstan",
      "code": "+996",
      "flag": "🇰🇬",
      "abbreviation": "KG"
    },
    {"name": "Laos", "code": "+856", "flag": "🇱🇦", "abbreviation": "LA"},
    {"name": "Latvia", "code": "+371", "flag": "🇱🇻", "abbreviation": "LV"},
    {"name": "Lebanon", "code": "+961", "flag": "🇱🇧", "abbreviation": "LB"},
    {"name": "Lesotho", "code": "+266", "flag": "🇱🇸", "abbreviation": "LS"},
    {"name": "Liberia", "code": "+231", "flag": "🇱🇷", "abbreviation": "LR"},
    {"name": "Libya", "code": "+218", "flag": "🇱🇾", "abbreviation": "LY"},
    {
      "name": "Liechtenstein",
      "code": "+423",
      "flag": "🇱🇮",
      "abbreviation": "LI"
    },
    {"name": "Lithuania", "code": "+370", "flag": "🇱🇹", "abbreviation": "LT"},
    {
      "name": "Luxembourg",
      "code": "+352",
      "flag": "🇱🇺",
      "abbreviation": "LU"
    },
    {
      "name": "Madagascar",
      "code": "+261",
      "flag": "🇲🇬",
      "abbreviation": "MG"
    },
    {"name": "Malawi", "code": "+265", "flag": "🇲🇼", "abbreviation": "MW"},
    {"name": "Malaysia", "code": "+60", "flag": "🇲🇾", "abbreviation": "MY"},
    {"name": "Maldives", "code": "+960", "flag": "🇲🇻", "abbreviation": "MV"},
    {"name": "Mali", "code": "+223", "flag": "🇲🇱", "abbreviation": "ML"},
    {"name": "Malta", "code": "+356", "flag": "🇲🇹", "abbreviation": "MT"},
    {
      "name": "Marshall Islands",
      "code": "+692",
      "flag": "🇲🇭",
      "abbreviation": "MH"
    },
    {
      "name": "Mauritania",
      "code": "+222",
      "flag": "🇲🇷",
      "abbreviation": "MR"
    },
    {"name": "Mauritius", "code": "+230", "flag": "🇲🇺", "abbreviation": "MU"},
    {"name": "Mexico", "code": "+52", "flag": "🇲🇽", "abbreviation": "MX"},
    {
      "name": "Micronesia",
      "code": "+691",
      "flag": "🇫🇲",
      "abbreviation": "FM"
    },
    {"name": "Moldova", "code": "+373", "flag": "🇲🇩", "abbreviation": "MD"},
    {"name": "Monaco", "code": "+377", "flag": "🇲🇨", "abbreviation": "MC"},
    {"name": "Mongolia", "code": "+976", "flag": "🇲🇳", "abbreviation": "MN"},
    {
      "name": "Montenegro",
      "code": "+382",
      "flag": "🇲🇪",
      "abbreviation": "ME"
    },
    {"name": "Morocco", "code": "+212", "flag": "🇲🇦", "abbreviation": "MA"},
    {
      "name": "Mozambique",
      "code": "+258",
      "flag": "🇲🇿",
      "abbreviation": "MZ"
    },
    {
      "name": "Myanmar (formerly Burma)",
      "code": "+95",
      "flag": "🇲🇲",
      "abbreviation": "MM"
    },
    {"name": "Namibia", "code": "+264", "flag": "🇳🇦", "abbreviation": "NA"},
    {"name": "Nauru", "code": "+674", "flag": "🇳🇷", "abbreviation": "NR"},
    {"name": "Nepal", "code": "+977", "flag": "🇳🇵", "abbreviation": "NP"},
    {
      "name": "Netherlands",
      "code": "+31",
      "flag": "🇳🇱",
      "abbreviation": "NL"
    },
    {
      "name": "New Zealand",
      "code": "+64",
      "flag": "🇳🇿",
      "abbreviation": "NZ"
    },
    {"name": "Nicaragua", "code": "+505", "flag": "🇳🇮", "abbreviation": "NI"},
    {"name": "Niger", "code": "+227", "flag": "🇳🇪", "abbreviation": "NE"},
    {"name": "Nigeria", "code": "+234", "flag": "🇳🇬", "abbreviation": "NG"},
    {
      "name": "North Korea",
      "code": "+850",
      "flag": "🇰🇵",
      "abbreviation": "KP"
    },
    {
      "name": "North Macedonia",
      "code": "+389",
      "flag": "🇲🇰",
      "abbreviation": "MK"
    },
    {"name": "Norway", "code": "+47", "flag": "🇳🇴", "abbreviation": "NO"},
    {"name": "Oman", "code": "+968", "flag": "🇴🇲", "abbreviation": "OM"},
    {"name": "Pakistan", "code": "+92", "flag": "🇵🇰", "abbreviation": "PK"},
    {"name": "Palau", "code": "+680", "flag": "🇵🇼", "abbreviation": "PW"},
    {
      "name": "Palestine State",
      "code": "+970",
      "flag": "🇵🇸",
      "abbreviation": "PS"
    },
    {"name": "Panama", "code": "+507", "flag": "🇵🇦", "abbreviation": "PA"},
    {
      "name": "Papua New Guinea",
      "code": "+675",
      "flag": "🇵🇬",
      "abbreviation": "PG"
    },
    {"name": "Paraguay", "code": "+595", "flag": "🇵🇾", "abbreviation": "PY"},
    {"name": "Peru", "code": "+51", "flag": "🇵🇪", "abbreviation": "PE"},
    {
      "name": "Philippines",
      "code": "+63",
      "flag": "🇵🇭",
      "abbreviation": "PH"
    },
    {"name": "Poland", "code": "+48", "flag": "🇵🇱", "abbreviation": "PL"},
    {"name": "Portugal", "code": "+351", "flag": "🇵🇹", "abbreviation": "PT"},
    {"name": "Qatar", "code": "+974", "flag": "🇶🇦", "abbreviation": "QA"},
    {"name": "Romania", "code": "+40", "flag": "🇷🇴", "abbreviation": "RO"},
    {"name": "Russia", "code": "+7", "flag": "🇷🇺", "abbreviation": "RU"},
    {"name": "Rwanda", "code": "+250", "flag": "🇷🇼", "abbreviation": "RW"},
    {
      "name": "Saint Kitts and Nevis",
      "code": "+1-869",
      "flag": "🇰🇳",
      "abbreviation": "KN"
    },
    {
      "name": "Saint Lucia",
      "code": "+1-758",
      "flag": "🇱🇨",
      "abbreviation": "LC"
    },
    {
      "name": "Saint Vincent and the Grenadines",
      "code": "+1-784",
      "flag": "🇻🇨",
      "abbreviation": "VC"
    },
    {"name": "Samoa", "code": "+685", "flag": "🇼🇸", "abbreviation": "WS"},
    {
      "name": "San Marino",
      "code": "+378",
      "flag": "🇸🇲",
      "abbreviation": "SM"
    },
    {
      "name": "Sao Tome and Principe",
      "code": "+239",
      "flag": "🇸🇹",
      "abbreviation": "ST"
    },
    {
      "name": "Saudi Arabia",
      "code": "+966",
      "flag": "🇸🇦",
      "abbreviation": "SA"
    },
    {"name": "Senegal", "code": "+221", "flag": "🇸🇳", "abbreviation": "SN"},
    {"name": "Serbia", "code": "+381", "flag": "🇷🇸", "abbreviation": "RS"},
    {
      "name": "Seychelles",
      "code": "+248",
      "flag": "🇸🇨",
      "abbreviation": "SC"
    },
    {
      "name": "Sierra Leone",
      "code": "+232",
      "flag": "🇸🇱",
      "abbreviation": "SL"
    },
    {"name": "Singapore", "code": "+65", "flag": "🇸🇬", "abbreviation": "SG"},
    {"name": "Slovakia", "code": "+421", "flag": "🇸🇰", "abbreviation": "SK"},
    {"name": "Slovenia", "code": "+386", "flag": "🇸🇮", "abbreviation": "SI"},
    {
      "name": "Solomon Islands",
      "code": "+677",
      "flag": "🇸🇧",
      "abbreviation": "SB"
    },
    {"name": "Somalia", "code": "+252", "flag": "🇸🇴", "abbreviation": "SO"},
    {
      "name": "South Africa",
      "code": "+27",
      "flag": "🇿🇦",
      "abbreviation": "ZA"
    },
    {
      "name": "South Korea",
      "code": "+82",
      "flag": "🇰🇷",
      "abbreviation": "KR"
    },
    {
      "name": "South Sudan",
      "code": "+211",
      "flag": "🇸🇸",
      "abbreviation": "SS"
    },
    {"name": "Spain", "code": "+34", "flag": "🇪🇸", "abbreviation": "ES"},
    {"name": "Sri Lanka", "code": "+94", "flag": "🇱🇰", "abbreviation": "LK"},
    {"name": "Sudan", "code": "+249", "flag": "🇸🇩", "abbreviation": "SD"},
    {"name": "Suriname", "code": "+597", "flag": "🇸🇷", "abbreviation": "SR"},
    {"name": "Sweden", "code": "+46", "flag": "🇸🇪", "abbreviation": "SE"},
    {
      "name": "Switzerland",
      "code": "+41",
      "flag": "🇨🇭",
      "abbreviation": "CH"
    },
    {"name": "Syria", "code": "+963", "flag": "🇸🇾", "abbreviation": "SY"},
    {
      "name": "Tajikistan",
      "code": "+992",
      "flag": "🇹🇯",
      "abbreviation": "TJ"
    },
    {"name": "Tanzania", "code": "+255", "flag": "🇹🇿", "abbreviation": "TZ"},
    {"name": "Thailand", "code": "+66", "flag": "🇹🇭", "abbreviation": "TH"},
    {
      "name": "Timor-Leste",
      "code": "+670",
      "flag": "🇹🇱",
      "abbreviation": "TL"
    },
    {"name": "Togo", "code": "+228", "flag": "🇹🇬", "abbreviation": "TG"},
    {"name": "Tonga", "code": "+676", "flag": "🇹🇴", "abbreviation": "TO"},
    {
      "name": "Trinidad and Tobago",
      "code": "+1-868",
      "flag": "🇹🇹",
      "abbreviation": "TT"
    },
    {"name": "Tunisia", "code": "+216", "flag": "🇹🇳", "abbreviation": "TN"},
    {"name": "Turkey", "code": "+90", "flag": "🇹🇷", "abbreviation": "TR"},
    {
      "name": "Turkmenistan",
      "code": "+993",
      "flag": "🇹🇲",
      "abbreviation": "TM"
    },
    {"name": "Tuvalu", "code": "+688", "flag": "🇹🇻", "abbreviation": "TV"},
    {"name": "Uganda", "code": "+256", "flag": "🇺🇬", "abbreviation": "UG"},
    {"name": "Ukraine", "code": "+380", "flag": "🇺🇦", "abbreviation": "UA"},
    {
      "name": "United Arab Emirates",
      "code": "+971",
      "flag": "🇦🇪",
      "abbreviation": "AE"
    },
    {
      "name": "United Kingdom",
      "code": "+44",
      "flag": "🇬🇧",
      "abbreviation": "GB"
    },
    {
      "name": "United States of America",
      "code": "+1",
      "flag": "🇺🇸",
      "abbreviation": "US"
    },
    {"name": "Uruguay", "code": "+598", "flag": "🇺🇾", "abbreviation": "UY"},
    {
      "name": "Uzbekistan",
      "code": "+998",
      "flag": "🇺🇿",
      "abbreviation": "UZ"
    },
    {"name": "Vanuatu", "code": "+678", "flag": "🇻🇺", "abbreviation": "VU"},
    {
      "name": "Vatican City (Holy See)",
      "code": "+379",
      "flag": "🇻🇦",
      "abbreviation": "VA"
    },
    {"name": "Venezuela", "code": "+58", "flag": "🇻🇪", "abbreviation": "VE"},
    {"name": "Vietnam", "code": "+84", "flag": "🇻🇳", "abbreviation": "VN"},
    {"name": "Yemen", "code": "+967", "flag": "🇾🇪", "abbreviation": "YE"},
    {"name": "Zambia", "code": "+260", "flag": "🇿🇲", "abbreviation": "ZM"},
    {"name": "Zimbabwe", "code": "+263", "flag": "🇿🇼", "abbreviation": "ZW"}
  ];

  Map<String, dynamic>? selectedCountry;
  String phone = "";
  TextEditingController _controller = TextEditingController();

  Future<void> initStateOfCountry() async {
    try {
      // setState(() {
      //   loading = true;
      // });

      String? countrytosearch =
          Provider.of<Auth>(context, listen: false).countrystring;

      print("preferred country : ${countrytosearch}");

      if (countrytosearch != null) {
        Map<String, dynamic>? nigeriaMap = countries.firstWhere(
          (country) => country["name"] == countrytosearch,
          orElse: () => {"abbreviation": "US", "code": "+1"},
        );

        if (nigeriaMap != null) {
          print("Map for Nigeria found: $nigeriaMap");
          setState(() {
            selectedCountry = nigeriaMap;
          });
        } else {
          print("Nigeria not found in the list.");
        }
      }
      // final response = await Provider.of<Auth>(context, listen: false)
      //     .signin("", "", "$email", password);

      // Provider.of<Auth>(context, listen: false).setTempPassword(password);
      // print("response: success");

      // print("response: success");

      // Navigator.pushNamed(context, AddPhoneNumber2faFinal.id);

      // print(response);
    } catch (e) {
      showErrorDialog(e.toString(), context);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _enable2fa() async {
    try {
      setState(() {
        loading = true;
      });
      await Provider.of<Auth>(context, listen: false)
          .enable2fa("${selectedCountry!['code']}$phone");

      Navigator.pushNamed(context, verifyPhone.id);
    } catch (e) {
      showErrorDialog(e.toString(), context);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    initStateOfCountry();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Add phone number",
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
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 11,
                      ),
                      child: Text(
                        "We’ll send a code to this number for verification whenever you log in.",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color(0xff5E6D85),
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Color(0xffCBDFF7),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(
                              8,
                            ))),
                        child: Row(
                          children: [
                            DropdownButton<Map<String, dynamic>>(
                              underline: Container(),
                              icon: SvgPicture.asset("images/down.svg"),
                              value: selectedCountry,
                              onChanged: (value) {
                                setState(() {
                                  selectedCountry = value;
                                });
                              },
                              items: countries
                                  .map<DropdownMenuItem<Map<String, dynamic>>>(
                                      (country) {
                                return DropdownMenuItem<Map<String, dynamic>>(
                                  value: country,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        .165,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          country['flag'],
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        SizedBox(width: 10),
                                        Text("${country['abbreviation']}"),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            if (selectedCountry != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "${selectedCountry!["code"]}",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                // keyboardType: TextInputType.text,
                                onChanged: (String val) {
                                  setState(() {
                                    // firstName = val;
                                    phone = val;
                                    // _fetchFaq();
                                  });
                                },
                                decoration: const InputDecoration(
                                    hintText: "894 233 0000",
                                    // prefixIconColor: Color(0xffB0B0B0),
                                    filled: true,
                                    fillColor: Color(0xffffffff),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    // label: Text('First Name'),
                                    hintStyle: TextStyle(
                                      color: Color(0xffB0B0B0),
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                    border: InputBorder.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20),
                    //   child: TextField(
                    //     controller: _controller,
                    //     // keyboardType: TextInputType.text,
                    //     onChanged: (String val) {
                    //       setState(() {
                    //         // firstName = val;
                    //         password = val;
                    //         // _fetchFaq();
                    //       });
                    //     },
                    //     obscureText: obscureText,
                    //     decoration: InputDecoration(
                    //       hintText: "Password",

                    //       suffixIcon: GestureDetector(
                    //           onTap: () {
                    //             setState(() {
                    //               obscureText = !obscureText;
                    //             });
                    //           },
                    //           child: obscureText
                    //               ? Icon(Icons.remove_red_eye)
                    //               : Icon(Icons.remove_red_eye_outlined)),
                    //       prefixIconColor: Color(0xffB0B0B0),
                    //       filled: true,
                    //       fillColor: Color(0xffffffff),
                    //       contentPadding: const EdgeInsets.symmetric(
                    //           horizontal: 10, vertical: 15),
                    //       // label: Text('First Name'),
                    //       hintStyle: TextStyle(
                    //         color: Color(0xffB0B0B0),
                    //         fontSize: 14,
                    //       ),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderSide: const BorderSide(
                    //           color: Color(0xffCBDFF7),
                    //         ), // Use the hex color
                    //         borderRadius: BorderRadius.circular(
                    //             8), // You can adjust the border radius as needed
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderSide: const BorderSide(
                    //           color: Color(0xffCBDFF7),
                    //         ), // Use the hex color
                    //         borderRadius: BorderRadius.circular(
                    //             8), // You can adjust the border radius as needed
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    // SizedBox(
                    //   height: 140,
                    // )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (loading)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: LinearProgressIndicator(),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: PropStockButton(
                        text: "Continue",
                        disabled: phone.isEmpty || selectedCountry == null,
                        onPressed: _enable2fa),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
