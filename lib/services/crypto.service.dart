import 'package:encrypt/encrypt.dart';

class CryptoService {
  final key = Key.fromUtf8("aBcDeFgHjKmNpQr=tUvWxYz234567888");
  final iv = IV.fromUtf8("RtVbNmKlHjGf=sQE");

  String encrypt(String dataToEncrypt) {
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return encrypter.encrypt(dataToEncrypt, iv: iv).base64;
  }

  String decrypt(String dataToDecrypt) {
    final decrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return decrypter.decrypt64(dataToDecrypt, iv: iv);
  }
}
