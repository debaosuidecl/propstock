import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

// final String _serverName = "https://cryptic-fjord-03848.herokuapp.com";
final String _serverName =
    Platform.isIOS ? "http://0.0.0.0:5100" : "http://10.0.2.2:5100";
Future<void> MyIp() async {
  final url = "https://ip.nf/me.json";
  final response = await http.get(Uri.parse(url));
  final responseData = json.decode(response.body);

  print(responseData["ip"]["ip"]);

  // notifyListeners();
}
