import 'dart:convert';

import '../packages/crypto-2.1.3/lib/crypto.dart';

class VerificaToken {
  String _token;
  int idPessoa;
  int idPessoaGrupo;


  VerificaToken({String token}){
    _token = token;
  }

  Future<bool> validaToken() async {
    var tokenItens = _token.split(".");
    String header64 = tokenItens[0];
    String payload64 = tokenItens[1];
    Map _payload = jsonDecode(utf8.decode(base64Decode(payload64)));
    String signature64 = tokenItens[2];

    String secret = "GiovanniGustavoTadaakiKarinaRenato";
    var hmac = Hmac(sha256,secret.codeUnits);
    var digest = hmac.convert("$header64.$payload64".codeUnits);
    var signatureGlobal = base64Encode(digest.bytes);

    if (signature64 == signatureGlobal) {
      return true;
    } else {
      return false;
    }
  }
  
  


}