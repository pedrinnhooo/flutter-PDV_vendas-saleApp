import 'dart:convert';
import '../packages/common_files/lib/common_files.dart';
import '../packages/crypto-2.1.3/lib/crypto.dart';

class UsuarioHasura {
  int id;
  int idPessoaGrupo;
  int idPessoa;
  String nome;
  String password;
  String email;
  String token;

  UsuarioHasura({String this.token}) {
    id = 0;
    idPessoaGrupo = 0;
    idPessoa = 0;
    nome = "";
    password = "";
    email = "";
  }

  Future<String> getTokenToHasura() async {
    String _token = "Bearer "+token.split("|")[1];
    print("getTokenToHasura: "+_token);
    return _token;
  }
  
  String generateToken(){
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
      "sub": "${this.id}",
      "id_pessoa": "${this.idPessoa}",
      "id_pessoa_grupo": "${this.idPessoaGrupo}",
      "nome": "${this.nome}",
      "admin": true,
      //"iat": DateTime.now().millisecondsSinceEpoch + 60000,
      //"iat": DateTime.now().millisecondsSinceEpoch + 60000,
      "https://hasura.io/jwt/claims": {
        "x-hasura-allowed-roles": ["user"],
        "x-hasura-default-role": "user",
        "x-hasura-user-id": "${this.idPessoa}",
        "x-hasura-org-id": "${this.idPessoaGrupo}",
        "x-hasura-custom": "${this.id}"
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
      print("t1: "+token);
      String _token = token.split("|")[0];
      print("t2: "+_token);
      var tokenItens = _token.split(".");
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
        print("tokenOK-1");
        id = int.parse(_payload["sub"]);
        print("tokenOK-2");
        idPessoa = int.parse(_payload["id_pessoa"]);
        print("tokenOK-3");
        idPessoaGrupo = int.parse(_payload["id_pessoa_grupo"]);
        print("tokenOK-4");
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

