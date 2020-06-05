import 'dart:convert';

import 'package:crypto/crypto.dart';

class UsuarioHasura {
  int id;
  int idPessoaGrupo;
  int idPessoa;
  String nome;
  String password;
  String email;
  String _token;

  UsuarioHasura({String token}) {
    id = 0;
    idPessoaGrupo = 0;
    idPessoa = 0;
    nome = "";
    password = "";
    email = "";
    _token = token;
  }

  Future<String> getTokenToHasura() async {
    String token = "Bearer "+_token.split("|")[1];
    print("getTokenToHasura: "+token);
    return token;
  }
  
  String generateToken(UsuarioHasura usuario){
    var header = {
      "alg": "HS256",
      "typ": "JWT"
    };
    print(jsonEncode(header));
    String header64Ori = base64Encode(jsonEncode(header).codeUnits);
    String header64 = base64Encode(jsonEncode(header).codeUnits);
    header64 = header64.replaceAll("/", "_");
    header64 = header64.replaceAll("+", "-");
    header64 = header64.replaceAll("=", "");
    print("header: "+header64);

    

    var payload = {
      "sub": "1",//usuario.id,
      "id_pessoa": "1",//usuario.idPessoa,
      "id_pessoa_grupo": "1",//usuario.idPessoaGrupo,
      "nome": "${usuario.nome}",
      "admin": true,
      //"iat": DateTime.now().millisecondsSinceEpoch + 60000,
      "https://hasura.io/jwt/claims": {
        "x-hasura-allowed-roles": ["user"],
        "x-hasura-default-role": "user",
        "x-hasura-user-id": "1",
        "x-hasura-org-id": "${usuario.idPessoa}"
      }      
    };
    print(jsonEncode(payload));
    String payload64Ori = base64Encode(jsonEncode(payload).codeUnits);
    String payload64 = base64Encode(jsonEncode(payload).codeUnits);
    payload64 = payload64.replaceAll("/", "_");
    payload64 = payload64.replaceAll("+", "-");
    payload64 = payload64.replaceAll("=", "");

    //print("payload: "+payload64);

    print("$header64.$payload64");

    String secret = "GiovanniGustavoTadaakiKarinaRenato";
    var hmac = Hmac(sha256,secret.codeUnits);
    var digestOri = hmac.convert("$header64Ori.$payload64Ori".codeUnits);
    var digest = hmac.convert("$header64.$payload64".codeUnits);
    var signatureOri = base64Encode(digestOri.bytes);
    var signature = base64Encode(digest.bytes);
    String tokenOri = "$header64Ori.$payload64Ori.$signatureOri";
    String token = "$header64.$payload64.$signature";
    token = token.replaceAll("/", "_");
    token = token.replaceAll("+", "-");
    token = token.replaceAll("=", "");
    return tokenOri+"|"+token;
  }

  Future<bool> validaToken() async {
    try{
      print("validaToken ---- INICIO -----");
      print("t1: "+_token);
      String token = _token.split("|")[0];
      print("t2: "+token);
      var tokenItens = token.split(".");
      print(tokenItens.toString());
      String header64 = tokenItens[0];
      print(header64);
      String payload64 = tokenItens[1];
      print(payload64);
      String signature64 = tokenItens[2];
      print(signature64);

      Map _payload = jsonDecode(utf8.decode(base64Decode(payload64)));
      print(_payload.toString());
      
      String secret = "GiovanniGustavoTadaakiKarinaRenato";
      var hmac = Hmac(sha256,secret.codeUnits);
      var digest = hmac.convert("$header64.$payload64".codeUnits);
      var signatureGlobal = base64Encode(digest.bytes);

      if (signature64 == signatureGlobal) {
        print("tokenOK");
        id = int.parse(_payload["sub"]);
        idPessoa = _payload["id_pessoa"];
        idPessoaGrupo = _payload["id_pessoa_grupo"];
        nome = _payload["nome"];
        print("id_pessoa: "+idPessoa.toString());
        return true;
      } else {
        print("token invalido");
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    } 
  }  

}

