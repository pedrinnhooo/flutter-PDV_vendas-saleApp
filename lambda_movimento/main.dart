import 'dart:convert';
import 'apigateway_event.dart';
import 'lib/controller/cancela_venda.dart';
import 'lib/controller/grava_venda.dart';
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
  HasuraBlocLambda _hasuraBloc = HasuraBlocLambda(usuario);

  print("valida token");
  bool tokenOk = await usuario.validaToken();
  if (tokenOk) {
    GravaVenda controller = GravaVenda(_hasuraBloc, usuario, json: asJson);
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
  HasuraBlocLambda _hasuraBloc = HasuraBlocLambda(usuario);
  print("valida token");
  bool tokenOk = await usuario.validaToken();
  if (tokenOk) {
    CancelaVenda controller = CancelaVenda(_hasuraBloc, usuario, json: asJson);
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



