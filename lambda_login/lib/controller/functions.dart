import '../packages/crypto-2.1.3/lib/crypto.dart';
import 'dart:convert';

  Future<String> generatePassword(String value) async {
    String password = value;
    String password64 = base64Encode(password.codeUnits);
    String secret = "GiovanniGustavoTadaakiKarinaRenato";
    var hmac = Hmac(sha256,secret.codeUnits);
    var digest = hmac.convert("$password64".codeUnits);
    var signature = base64Encode(digest.bytes);
    String token = "$password64.$signature";
    return token;
  }
