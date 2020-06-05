import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:device_id/device_id.dart';
import 'package:dio/dio.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:version/version.dart';

class LoginBloc extends BlocBase{
  AppGlobalBloc appGlobalBloc;
  HasuraBloc _hasuraBloc;
  SincronizacaoBloc sincronizacaoBloc;
  static FacebookLogin facebookSignIn;
  static FacebookAccessToken accessToken;
  GoogleSignIn googleSignIn;
  GoogleSignInAccount currentUser;
  SharedPreferences sharedPreferences;
  String username="";
  String password="";
  bool formInvalido = true;
  bool usernameInvalido = false;
  bool passwordInvalido = false;
  int statusCode;
  Pessoa pessoa;
  Login login;

  BehaviorSubject<bool> usernameInvalidoController;
  Stream<bool> get usernameInvalidoOut => usernameInvalidoController.stream;

  BehaviorSubject<bool> passwordInvalidoController;
  Stream<bool> get passwordInvalidoOut => passwordInvalidoController.stream;

  LoginBloc(){
    appGlobalBloc = AppModule.to.getBloc<AppGlobalBloc>();
    _hasuraBloc = AppModule.to.getBloc<HasuraBloc>();
    sincronizacaoBloc = AppModule.to.getBloc<SincronizacaoBloc>(); 
    initSharedPrerences();
    facebookSignIn = new FacebookLogin();
    pessoa = Pessoa();
    googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);
    usernameInvalidoController = BehaviorSubject.seeded(usernameInvalido);
    passwordInvalidoController = BehaviorSubject.seeded(passwordInvalido);
  }

  initSharedPrerences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> temTokenSharedPreferences() async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    String _token;
    String _loja;
    String _usuario;
    String _terminal;
    try {
      _token = _sharedPreferences.getString('token') ?? null;
      _loja = _sharedPreferences.getString('loja') ?? null;
      _usuario = _sharedPreferences.getString('usuario') ?? null;
      _terminal = _sharedPreferences.getString('terminal') ?? null;
      appGlobalBloc.usuario = _usuario != null ? Pessoa.fromJson(json.decode(_usuario)) : null;
      appGlobalBloc.loja = _loja != null ? Pessoa.fromJson(json.decode(_loja)) : null;
      appGlobalBloc.terminal = _terminal != null ? Terminal.fromJson(json.decode(_terminal)) : null;
      Transacao _transacao = Transacao();
      TransacaoDAO _transacaoDAO = TransacaoDAO(_hasuraBloc, _transacao, appGlobalBloc);
      appGlobalBloc.terminal.transacao = await _transacaoDAO.getByIdFromServer(appGlobalBloc.terminal.idTransacao);
      sincronizacaoBloc.initBloc();
      appGlobalBloc.terminal.transacao = await _transacaoDAO.getById(appGlobalBloc.terminal.idTransacao);
      //sincronizacaoBloc.initBloc();
      _transacaoDAO = null;
      _transacao = null;
      syncLogin();
      return _token != null;
    } catch (e) {
      print("<temTokenSharedPreferences> Exception: $e");
      return false;
    }
  }
  
  doLogin(BuildContext context) async {
    await getEmailTokenFromServer(context, TipoLogin.emailLogin, emailData: {username : password});
  }

  validaUsername() {
    usernameInvalido = username == "" ? true : false;
    formInvalido = usernameInvalido;
    usernameInvalidoController.add(usernameInvalido);
  }

  validaPassword() {
    passwordInvalido = password == "" ? true : false;
    formInvalido = usernameInvalido ? true : passwordInvalido;
    passwordInvalidoController.add(passwordInvalido);
  }

  Future getFacebookAuthorization(BuildContext context) async{
    Dio dio = Dio();
    dio.options.connectTimeout = 20000;
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        accessToken = result.accessToken;
        var data = await dio.get('$facebookGrapQLUrl?fields=email,name&access_token=${accessToken.token}');
        if(data.statusCode == 200){
          int statusCode = await getTokenFromServer(context, TipoLogin.facebookLogin, facebookData: json.decode(data.data));
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelado (usuário clicou em voltar antes de autorizar)');
        break;
      case FacebookLoginStatus.error:
        print('Alguma coisa deu errado no processo.\n'
            'Facebook error: ${result.errorMessage}');
        break;
    }
  }

  Future doGoogleSignIn(BuildContext context) async{
    try{
      await googleSignIn.signIn();
      if(googleSignIn.currentUser != null){
        print(googleSignIn.currentUser);
        await getTokenFromServer(context, TipoLogin.googleLogin, googleData: googleSignIn.currentUser);
      }
    }catch(error){
      print(error);
    }
  }

  Future<void> doGoogleSignOut() async{
    googleSignIn.disconnect();
  }

  Future getTokenFromServer(BuildContext context, TipoLogin tipoLogin, {dynamic facebookData, GoogleSignInAccount googleData, Map<String,String> emailData}) async {
    String resource = tipoLogin == TipoLogin.facebookLogin ? 'login-facebook' : 'login-google';
    List<Contato> contatoList = [];
    Contato contato = Contato(
      email: tipoLogin == TipoLogin.facebookLogin ? facebookData['email'] : googleData.email 
    );
    contatoList.add(contato);
    pessoa = Pessoa(
      password: emailData == null ? '' : emailData.values.single.toString(),
      idGoogle: tipoLogin == TipoLogin.facebookLogin ? '' : googleData.id.toString(),
      idFacebook: tipoLogin == TipoLogin.facebookLogin ? facebookData['id'].toString() : '',
      idPessoaGrupo: 1,
      razaoNome: tipoLogin == TipoLogin.facebookLogin ? facebookData['name'] : googleData.displayName,
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
    Map<String,dynamic> requestData = pessoa.toJson();
    //requestData["id_device"] = await DeviceId.getID;
    requestData["id_device"] = await getDeviceId(context);
    
    try {
      Dio dio = Dio();
      dio.options.headers = lambdaHeaders;
      dio.options.connectTimeout = 20000;
      Response response = await dio.post(
        lambdaEndpoint + resource, 
        data: requestData,
      );
      if(response.statusCode == 200) {
        print(response.data['token']);
        print(response.data['status_login']);
        await sharedPreferences.setString('token', response.data['token']);
        login = Login.fromJson(response.data);
        pessoa = login.usuario;
        appGlobalBloc.usuario = login.usuario;
        appGlobalBloc.loja = login.lojaList[0];
        appGlobalBloc.terminal = login.terminal;
        await sharedPreferences.setString('token', response.data['token']);
        await sharedPreferences.setString('loja', json.encode(appGlobalBloc.loja));
        Transacao _transacao = Transacao();
        TransacaoDAO _transacaoDAO = TransacaoDAO(_hasuraBloc, _transacao, appGlobalBloc);
        appGlobalBloc.terminal.transacao = await _transacaoDAO.getByIdFromServer(appGlobalBloc.terminal.idTransacao);
        await sharedPreferences.setString('terminal', json.encode(appGlobalBloc.terminal));
        sincronizacaoBloc.initBloc();
        syncLogin();
        _transacaoDAO = null;
        _transacao = null;
        statusCode = response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<int> getEmailTokenFromServer(BuildContext context, TipoLogin tipoLogin, {Map<String,String> emailData}) async {
    List<Contato> contatoList = [];
    Contato contato = Contato(
      email: emailData.keys.single.toString()
    );
    contatoList.add(contato);
    pessoa = Pessoa(
      password: emailData.isEmpty ? '' : emailData.values.single.toString(),
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

    Map<String,dynamic> requestData = pessoa.toJson();
    //requestData["id_device"] = await DeviceId.getID;
    String deviceId = await getDeviceId(context);
    print("<getEmailTokenFromServer> deviceId: $deviceId");
    requestData["id_device"] = await getDeviceId(context);
    
    try {
      Dio dio = Dio();
      dio.options.headers = lambdaHeaders;
      dio.options.connectTimeout = 20000; 

      Response response = await dio.post(
        lambdaEndpoint + "login-email", 
        data: requestData,
      );
      if(response.statusCode == 200) {
        print(response.data['token']);
        print(response.data['status_login']);
        if(response.data['status_login'] == 0){
          await sharedPreferences.setString('token', response.data['token']);
          login = Login.fromJson(response.data);
          appGlobalBloc.usuario = login.usuario;
          appGlobalBloc.loja = login.lojaList[0];
          appGlobalBloc.terminal = login.terminal;
          await sharedPreferences.setString('token', response.data['token']);
          await sharedPreferences.setString('loja', json.encode(appGlobalBloc.loja));
          await sharedPreferences.setString('usuario', json.encode(appGlobalBloc.usuario));
          Transacao _transacao = Transacao();
          TransacaoDAO _transacaoDAO = TransacaoDAO(_hasuraBloc, _transacao, appGlobalBloc);
          appGlobalBloc.terminal.transacao = await _transacaoDAO.getByIdFromServer(appGlobalBloc.terminal.idTransacao);
          await sharedPreferences.setString('terminal', json.encode(appGlobalBloc.terminal));
          await Intercom.registerIdentifiedUser(userId: appGlobalBloc.loja.id.toString());
          await Intercom.updateUser(
            name: appGlobalBloc.loja.contato[0].nome, 
            email: appGlobalBloc.loja.contato[0].email,
            phone: appGlobalBloc.loja.contato[0].telefone1,  
            companyId: appGlobalBloc.loja.idPessoaGrupo.toString(),
          );
          sincronizacaoBloc.initBloc();
          syncLogin();
          _transacaoDAO = null;
          _transacao = null;
          statusCode = response.statusCode;
          return response.statusCode;
        }
      }
      return 500;
    } on DioError catch(e) {
      print("<getEmailTokenFromServer> Exception: $e");
      if (e.response == null) { 
        login = Login(statusLogin: StatusLogin.semConexao);
      }  
      return 500;
    }
  }

  Future<int> vinculaFacebook() async {
    try {
      Dio dio = Dio();
      dio.options.headers = lambdaHeaders;
      dio.options.connectTimeout = 20000; 
      Response response = await dio.post(
        '${lambdaEndpoint}vincula-facebook', 
        data: pessoa.toJson(),
      );
      if(response.statusCode == 200){
        statusCode = response.statusCode;
        await sharedPreferences.setString('token', response.data['token']);
      }
      return response.statusCode;
    } catch (e) {
      print(e);
      return 500;
    }
  }

  Future<int> vinculaGoogle() async {
    try {
      Dio dio = Dio();
      dio.options.headers = lambdaHeaders;
      dio.options.connectTimeout = 20000; 
      Response response = await dio.post(
        '${lambdaEndpoint}vincula-google', 
        data: pessoa.toJson(),
      );
      if(response.statusCode == 200){
        statusCode = response.statusCode;
        await sharedPreferences.setString('token', response.data['token']);
      }
      return response.statusCode;
    } catch (e) {
      print(e);
      return 500;
    }
  }

  syncLogin() async {
    await sincronizacaoBloc.initBloc();
    await sincronizacaoBloc.sincronizacaoHasura.getSincronizacaoFromServer();
    sincronizacaoBloc.sincronizacaoLambda.start();
  }
  
  Future<bool>getVersaoEhValida() async {
    Aplicativo aplicativo = Aplicativo();
    AplicativoDAO aplicativoDao = AplicativoDAO(_hasuraBloc, appGlobalBloc);
    List<Aplicativo> aplicativoList = await aplicativoDao.getAllFromServer(
      preLoad: true,
      filtroKey: "#FLU22@APPGGY11!2020",
      id: true
    );
    aplicativo = aplicativoList[0];
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versaoApp = packageInfo.version;

    return (Version.parse(versaoApp) >= Version.parse(aplicativo.aplicativoVersao[0].versao));
  }

  @override
  void dispose() {
    super.dispose();
    usernameInvalidoController.close();
    passwordInvalidoController.close();
  }
}