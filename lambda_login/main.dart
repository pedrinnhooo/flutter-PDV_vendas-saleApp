import 'dart:convert';
import 'apigateway_event.dart';
import 'lib/controller/cancela_venda.dart';
import 'lib/controller/grava_venda.dart';
import 'lib/controller/login_facebook.dart';
import 'lib/controller/login_google.dart';
import 'lib/controller/login_email.dart';
import 'lib/controller/login_cria_conta.dart';
import 'lib/controller/usuario_hasura.dart';
import 'lib/controller/vincula_facebook.dart';
import 'lib/controller/vincula_google.dart';
import 'runtime.dart';
import 'lib/packages/common_files/lib/common_files.dart';

void main() async {
  await Runtime()
    ..registerApiGatewayHandler(
      'apiGatewayGravaVenda',
      apiGatewayGravaVenda,
    )
     ..registerApiGatewayHandler(
       'apiGatewayCancelaVenda',
       apiGatewayCancelaVenda,
     )
    ..registerApiGatewayHandler(
      'apiGatewayLoginEmail',
      apiGatewayLoginEmail,
    )
    ..registerApiGatewayHandler(
      'apiGatewayLoginCriaConta',
      apiGatewayLoginCriaConta,
    )
    ..registerApiGatewayHandler(
      'apiGatewayVinculaFacebook',
      apiGatewayVinculaFacebook,
    )
    ..registerApiGatewayHandler(
      'apiGatewayVinculaGoogle',
      apiGatewayVinculaGoogle,
    )
    ..registerApiGatewayHandler(
      'apiGatewayLoginFacebook',
      apiGatewayLoginFacebook,
    )
    ..registerApiGatewayHandler(
      'apiGatewayLoginGoogle',
      apiGatewayLoginGoogle,
    )
    ..start();
}

Future<ApiGatewayResponse> apiGatewayGravaVenda(
  ApiGatewayEvent apiRequest,
  Context context,
) async {
  print("Finaliza ---INICIO--- ");
  //print("Finaliza: "+apiRequest.body);
  //print(apiRequest.queryStringParameters.toJson()['username']);
  final Map<String, dynamic> asJson =
      json.decode(apiRequest.body) as Map<String, dynamic>;

  //print("token: "+apiRequest.headers.toString());
  
  //print("token: "+apiRequest.headers.authorization);
  UsuarioHasura usuario = UsuarioHasura(token: apiRequest.headers.authorization);

  print("valida token");
  bool tokenOk = await usuario.validaToken();
  if (tokenOk) {
    GravaVenda controller = GravaVenda(usuario, json: asJson);
    bool result = await controller.executaGravaVenda();
    if (result) {
      return ApiGatewayResponse(
        body: json.encode(controller.jsonRetorno),
        isBase64Encoded: false,
        statusCode: 200,
      );
    } else {
      return ApiGatewayResponse(
        body: json.encode({'resultado': null}),
        isBase64Encoded: false,
        statusCode: 500,
      );
    }
  } else {
      return ApiGatewayResponse(
        body: json.encode({'resultado': null}),
        isBase64Encoded: false,
        statusCode: 401,
      );
  }  
}

Future<ApiGatewayResponse> apiGatewayCancelaVenda(
  ApiGatewayEvent apiRequest,
  Context context,
) async {
  print("Cancela ---INICIO--- ");
  //print("Cancela: "+apiRequest.body);
  //print(apiRequest.queryStringParameters.toJson()['username']);
  final Map<String, dynamic> asJson =
      json.decode(apiRequest.body) as Map<String, dynamic>;
  
  //print("token: "+apiRequest.headers.authorization);
  UsuarioHasura usuario = UsuarioHasura(token: apiRequest.headers.authorization);
  print("valida token");
  bool tokenOk = await usuario.validaToken();
  if (tokenOk) {
    CancelaVenda controller = CancelaVenda(usuario, json: asJson);
    bool result = await controller.executaCancelaVenda();
    if (result) {
      return ApiGatewayResponse(
        body: json.encode(controller.jsonRetorno),
        isBase64Encoded: false,
        statusCode: 200,
      );
    } else {
      return ApiGatewayResponse(
        body: json.encode({'resultado': null}),
        isBase64Encoded: false,
        statusCode: 500,
      );
    }
  } else {
      return ApiGatewayResponse(
        body: json.encode({'resultado': null}),
        isBase64Encoded: false,
        statusCode: 401,
      );
  }  
}

Future<ApiGatewayResponse> apiGatewayLoginCriaConta(
  ApiGatewayEvent apiRequest,
  Context context,
) async {
  print("LoginCriaConta ---INICIO--- ");
  print("LoginCriaConta: "+apiRequest.body);
  final Map<String, dynamic> asJson =
      json.decode(apiRequest.body) as Map<String, dynamic>;
  
  print("LoginCriaConta: Pessoa.fromJson");
  Login login = Login();
  login.usuario = Pessoa.fromJson(asJson);
  print("id_device: "+asJson["id_device"]);
  login.idDevice = asJson["id_device"];
  print("LoginCriaConta: loginEmail");
  LoginCriaConta loginCriaConta = LoginCriaConta(login);
  try {
    print("LoginCriaConta: createConta");
    await loginCriaConta.createConta();
    print("LoginCriaConta: return");
    //print(login.usuario.razaoNome);
    print(login.token);
    return ApiGatewayResponse(
      body: json.encode(login.toJson()),
      isBase64Encoded: false,
      statusCode: 200,
    );
  } catch (e) {
    return ApiGatewayResponse(
      body: json.encode({'resultado': null}),
      isBase64Encoded: false,
      statusCode: 500,
    );
  }  
}

Future<ApiGatewayResponse> apiGatewayLoginEmail(
  ApiGatewayEvent apiRequest,
  Context context,
) async {
  print("LoginEmail ---INICIO--- ");
  print("LoginEmail: "+apiRequest.body);
  final Map<String, dynamic> asJson =
      json.decode(apiRequest.body) as Map<String, dynamic>;
  
  print("LoginEmail: Pessoa.fromJson");
  Login login = Login();
  login.usuario = Pessoa.fromJson(asJson);
  login.idDevice = asJson["id_device"];
  print("LoginEmail: loginEmail");
  LoginEmail loginEmail = LoginEmail(login);
  try {
    print("LoginEmail: efetuarLogin");
    login = await loginEmail.efetuarLogin();
    print("LoginEmail: return");
    print(login.usuario.razaoNome);
    print(login.token);
    return ApiGatewayResponse(
      body: json.encode(login.toJson()),
      isBase64Encoded: false,
      statusCode: 200,
    );
  } catch (e) {
    return ApiGatewayResponse(
      body: json.encode({'resultado': null}),
      isBase64Encoded: false,
      statusCode: 500,
    );
  }  
}

Future<ApiGatewayResponse> apiGatewayVinculaFacebook(
  ApiGatewayEvent apiRequest,
  Context context,
) async {
  print("VinculaFacebook ---INICIO--- ");
  print("VinculaFacebook: "+apiRequest.body);
  //print(apiRequest.queryStringParameters.toJson()['username']);
  final Map<String, dynamic> asJson =
      json.decode(apiRequest.body) as Map<String, dynamic>;
  
  print("VinculaFacebook: Pessoa.fromJson");
  Login login = Login();
  login.usuario = Pessoa.fromJson(asJson);
  VinculaFacebook vinculaFacebook = VinculaFacebook(login);
  //Map<String, dynamic> result;
  try {
    print("VinculaFacebook: vinculaFacebook");
    login = await vinculaFacebook.vinculaFacebook();
    print("VinculaFacebook: return");
    print(login.usuario.razaoNome);
    print(login.token);
    return ApiGatewayResponse(
      body: json.encode(login.toJson()),
      isBase64Encoded: false,
      statusCode: 200,
    );
  } catch (e) {
    return ApiGatewayResponse(
      body: json.encode({'resultado': null}),
      isBase64Encoded: false,
      statusCode: 500,
    );
  }  
}

Future<ApiGatewayResponse> apiGatewayVinculaGoogle(
  ApiGatewayEvent apiRequest,
  Context context,
) async {
  print("VinculaGoogle ---INICIO--- ");
  print("VinculaGoogle: "+apiRequest.body);
  //print(apiRequest.queryStringParameters.toJson()['username']);
  final Map<String, dynamic> asJson =
      json.decode(apiRequest.body) as Map<String, dynamic>;
  
  print("VinculaGoogle: Pessoa.fromJson");
  Login login = Login();
  login.usuario = Pessoa.fromJson(asJson);
  VinculaGoogle vinculaGoogle = VinculaGoogle(login);
  //Map<String, dynamic> result;
  try {
    print("VinculaGoogle: vinculaGoogle");
    login = await vinculaGoogle.vinculaGoogle();
    print("VinculaGoogle: return");
    print(login.usuario.razaoNome);
    print(login.token);
    return ApiGatewayResponse(
      body: json.encode(login.toJson()),
      isBase64Encoded: false,
      statusCode: 200,
    );
  } catch (e) {
    return ApiGatewayResponse(
      body: json.encode({'resultado': null}),
      isBase64Encoded: false,
      statusCode: 500,
    );
  }  
}

Future<ApiGatewayResponse> apiGatewayLoginFacebook(
  ApiGatewayEvent apiRequest,
  Context context,
) async {
  print("LoginFacebook ---INICIO--- ");
  print("LoginFacebook: "+apiRequest.body);
  //print(apiRequest.queryStringParameters.toJson()['username']);
  final Map<String, dynamic> asJson =
      json.decode(apiRequest.body) as Map<String, dynamic>;
  
  print("LoginFacebook: Pessoa.fromJson");
  Login login = Login();
  login.usuario = Pessoa.fromJson(asJson);
  login.idDevice = asJson["id_device"];
  print("LoginFacebook: loginFacebook");
  LoginFacebook loginFacebook = LoginFacebook(login);
  //Map<String, dynamic> result;
  try {
    print("LoginFacebook: efetuarLogin");
    login = await loginFacebook.efetuarLogin();
    print("LoginFacebook: return");
    print(login.usuario.razaoNome);
    print(login.token);
    return ApiGatewayResponse(
      body: json.encode(login.toJson()),
      isBase64Encoded: false,
      statusCode: 200,
    );
  } catch (e) {
    return ApiGatewayResponse(
      body: json.encode({'resultado': null}),
      isBase64Encoded: false,
      statusCode: 500,
    );
  }  
}

Future<ApiGatewayResponse> apiGatewayLoginGoogle(
  ApiGatewayEvent apiRequest,
  Context context,
) async {
  print("LoginGoogle ---INICIO--- ");
  print("LoginGoogle: "+apiRequest.body);
  //print(apiRequest.queryStringParameters.toJson()['username']);
  final Map<String, dynamic> asJson =
      json.decode(apiRequest.body) as Map<String, dynamic>;
  
  print("LoginGoogle: Pessoa.fromJson");
  Login login = Login();
  login.usuario = Pessoa.fromJson(asJson);
  login.idDevice = asJson["id_device"];
  print("LoginGoogle: loginGoogle");
  LoginGoogle loginGoogle = LoginGoogle(login);
  //Map<String, dynamic> result;
  try {
    print("LoginGoogle: efetuarLogin");
    login = await loginGoogle.efetuarLogin();
    print("LoginGoogle: return");
    print(login.usuario.razaoNome);
    print(login.token);
    return ApiGatewayResponse(
      body: json.encode(login.toJson()),
      isBase64Encoded: false,
      statusCode: 200,
    );
  } catch (e) {
    return ApiGatewayResponse(
      body: json.encode({'resultado': null}),
      isBase64Encoded: false,
      statusCode: 500,
    );
  }  
}



