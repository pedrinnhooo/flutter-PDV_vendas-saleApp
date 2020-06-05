import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:device_id/device_id.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCadastroBloc extends BlocBase {
  AppGlobalBloc appGlobalBloc;
  Login login;
  Pessoa pessoa;
  String username = "";
  String email = "";
  String password = "";
  String retypedPassword = "";
  bool usernameInvalido = false;
  bool emailInvalido = false;
  bool passwordInvalido = false;
  bool retypedPasswordInvalida = false;
  bool formInvalido = false;
  SharedPreferences sharedPreferences;
  
  BehaviorSubject<bool> usernameInvalidoController;
  Stream<bool> get usernameInvalidoOut => usernameInvalidoController.stream; 
  BehaviorSubject<bool> emailInvalidoController;
  Stream<bool> get emailInvalidoOut => emailInvalidoController.stream; 
  BehaviorSubject<bool> passwordInvalidoController;
  Stream<bool> get passwordInvalidoOut => passwordInvalidoController.stream; 
  BehaviorSubject<bool> retypedPasswordInvalidaController;
  Stream<bool> get retypedPasswordInvalidaOut => retypedPasswordInvalidaController.stream; 
  BehaviorSubject<bool> formInvalidoController;
  Stream<bool> get formInvalidoOut => formInvalidoController.stream;

  LoginCadastroBloc(this.appGlobalBloc){
    initSharedPrerences();
    login = Login();
    usernameInvalidoController = BehaviorSubject.seeded(usernameInvalido);
    emailInvalidoController = BehaviorSubject.seeded(emailInvalido);
    passwordInvalidoController = BehaviorSubject.seeded(passwordInvalido);
    retypedPasswordInvalidaController = BehaviorSubject.seeded(retypedPasswordInvalida);
    formInvalidoController = BehaviorSubject.seeded(formInvalido);
  }

  initSharedPrerences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  doSignUp(BuildContext context) async {
    List<Contato> contatoList = [];
    Contato contato = Contato(
      email: email
    );
    contatoList.add(contato);
    pessoa = Pessoa(
      razaoNome: username,
      password: password,
      idPessoaGrupo: 1,
      ehUsuario: 1,
      ehRevenda: 0,
      ehLoja: 0,
      ehFornecedor: 0,
      ehDeletado: 0,
      ehFisica: 1,
      ehCliente: 0,
      dataCadastro: DateTime.parse("2019-11-11T12:44:41.025596"),
      dataAtualizacao: DateTime.parse("2019-11-11T12:52:08.939108"),
      cnpjCpf: "",
      contato: contatoList
    );
    
    try {
      Dio dio = Dio();
      dio.options.headers = lambdaHeaders;

      Map<String,dynamic> requestData = pessoa.toJson();
      //requestData["id_device"] = await DeviceId.getID;
      requestData["id_device"] = await getDeviceId(context);
      
      Response response = await dio.post(
        lambdaEndpoint + "login-cria-conta", 
        data: requestData,
      );
      print(response.data);
      if(response.statusCode == 200) {
        print(response.data['token']);
        print(response.data['status_login']);
        //await sharedPreferences.setString('token', response.data['token']);
        login = Login.fromJson(response.data);
        pessoa = login.usuario;
        appGlobalBloc.loja = login.lojaList[0];
        appGlobalBloc.terminal = login.terminal;
        await sharedPreferences.setString('token', response.data['token']);
        await sharedPreferences.setString('loja', json.encode(appGlobalBloc.loja));
        await sharedPreferences.setString('terminal', json.encode(appGlobalBloc.terminal));

        return response.statusCode;
      }
      return 500;
    } catch (e) {
      print(e);
      return 500;
    }
  }

  validaUsuario() {
    usernameInvalido = username == "" ? true : false;
    formInvalido = usernameInvalido;
    usernameInvalidoController.add(usernameInvalido);
  }

  validaEmail(){
    if (validateEmail(email) || email == "")
      emailInvalido = true;
    else
      emailInvalido = false;
    formInvalido = !formInvalido ? emailInvalido : formInvalido;
    emailInvalidoController.add(emailInvalido);
  }

  validaSenha() {
    passwordInvalido = password == "" ? true : false;
    formInvalido = !formInvalido ? passwordInvalido : formInvalido;
    passwordInvalidoController.add(passwordInvalido);
  }

  validaSenhaRedigitada(){
    retypedPasswordInvalida = retypedPassword == "" || retypedPassword == password ? true : false;
    formInvalido = !formInvalido ? retypedPasswordInvalida : formInvalido;
    retypedPasswordInvalidaController.add(retypedPasswordInvalida);
  }

  @override
  void dispose() {
    retypedPasswordInvalidaController.close();
    passwordInvalidoController.close();
    emailInvalidoController.close();
    usernameInvalidoController.close();
    formInvalidoController.close();
    super.dispose();
  }
}
