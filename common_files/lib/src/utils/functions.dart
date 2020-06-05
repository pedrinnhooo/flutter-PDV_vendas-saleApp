import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path_;
import 'package:common_files/common_files.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'constants.dart';

String ourDate(DateTime value) {
  return value.toString().substring(0,10);
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}

bool validateCep(String value) {
  Pattern pattern =
      r'^[0-9]{5}-[0-9]{3}$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}

Future<Cep> consultaCep(String value) async {
  var dio = Dio();
  try {
    Response response = await dio.get("https://viacep.com.br/ws/$value/json/");
    if (response.statusCode == 200) {
        return Cep.fromMap(response.data);
    } else {
      throw null;
    }   
  } catch (erro) {
    print(erro);
    return null;  
  }
}

int getStatusLoginIndex(StatusLogin value) {
  switch (value) {
    case StatusLogin.loginOk: return StatusLogin.loginOk.index;
    case StatusLogin.usuarioSenhaInvalida: return StatusLogin.usuarioSenhaInvalida.index;
    case StatusLogin.usuarioJaCadastrado: return StatusLogin.usuarioJaCadastrado.index;
    case StatusLogin.usuarioBloqueado: return StatusLogin.usuarioBloqueado.index;
    case StatusLogin.semConexao: return StatusLogin.semConexao.index;
  }
}

StatusLogin setStatusLoginIndex(int value) {
  switch (value) {
    case 0: return StatusLogin.loginOk;
    case 1: return StatusLogin.usuarioSenhaInvalida;
    case 2: return StatusLogin.usuarioJaCadastrado;
    case 3: return StatusLogin.usuarioBloqueado;
  }
}

Future<String> readBase64Image(String path) async {
  String base64String;
  try {
    final directory = (await getApplicationDocumentsDirectory()).path;
    final file = File("${directory}${path}");
    // final directory = await getApplicationDocumentsDirectory();
    // final file = File('${directory}$path');
    base64String = await file.readAsString();
  } catch (e) {
    print("Não foi possível ler o base64 do arquivo. Erro: $e");
  }
  return base64String;
}

Future<String> formatKeyboardValue(String value) async {
  switch (value.length) {
    case 1:
      return "0,0" + value;
      break;
    case 2:
      return "0," + value;
      break;
    case 3:
      return value.substring(0, 1) + "," + value.substring(1, value.length);
      break;
    case 4:
      return value.substring(0, 2) + "," + value.substring(2, value.length);
      break;
    case 5:
      return value.substring(0, 3) + "," + value.substring(3, value.length);
      break;
    case 6:
      return value.substring(0, 1) +
          "." +
          value.substring(1, 4) +
          "," +
          value.substring(4, value.length);
      break;
    case 7:
      return value.substring(0, 2) +
          "." +
          value.substring(2, 5) +
          "," +
          value.substring(5, value.length);
      break;
    case 8:
      return value.substring(0, 3) +
          "." +
          value.substring(3, 6) +
          "," +
          value.substring(6, value.length);
      break;
    default: return value;
  }
}

String quotedString(String value) {
  return "'$value'";
}

Future<String> getDeviceId(BuildContext context) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId; // unique ID on Android
  }
}

Future<void> log(HasuraBloc _hasuraBloc, AppGlobalBloc _appGlobalBloc, {String nomeArquivo="", String nomeFuncao="", String error="",
    String stacktrace="", String object="", String query=""}) async {
  LogErro logErro = LogErro();
  logErro.nomeArquivo = nomeArquivo;
  logErro.nomeFuncao = nomeFuncao;
  logErro.error = error;
  logErro.stacktrace = stacktrace;
  logErro.object = object;
  logErro.query = query;
  _appGlobalBloc.logErroList.add(logErro);
  LogErroDAO logErroDAO = LogErroDAO(_hasuraBloc, _appGlobalBloc, logErro);
  try {
    await logErroDAO.insert();
  } catch (error) {

  } 
}