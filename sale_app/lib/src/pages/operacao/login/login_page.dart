
import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/home/menu_page.dart';
import 'package:fluggy/src/pages/operacao/login_cadastro/login_cadastro_module.dart';
import 'package:fluggy/src/pages/operacao/login/login_bloc.dart';
import 'package:fluggy/src/pages/operacao/login/login_module.dart';
import 'package:fluggy/src/venda/venda_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  LoginBloc loginBloc;
  SharedVendaBloc vendaBloc;
  TextEditingController usernameController, passwordController;
  bool login = false;

  @override
  void initState() {
    super.initState();
    loginBloc = LoginModule.to.getBloc<LoginBloc>();
    vendaBloc = AppModule.to.getBloc<SharedVendaBloc>();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    init();
  }
  
  clearLogin() {
    usernameController.clear();
    passwordController.clear();
  }

  init() async {
    if (await loginBloc.temTokenSharedPreferences()) {
      loginBloc.syncLogin();
      //  Navigator.push(context, 
      //   MaterialPageRoute(
      //     settings: RouteSettings(name: '/Menu'),
      //     builder: (context) => MenuPage()
      //   )
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: SizedBox(
                    height: 100,
                    width: 300,
                    child: Image.asset("assets/palavraFluggy.png"),
                  ),
                ),
              ),
              Container(
                height: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
                      child: StreamBuilder<bool>(
                        initialData: false,
                        stream: loginBloc.usernameInvalidoOut,
                        builder: (context, snapshot) {
                          return Container(
                            child: customTextField(context,
                              controller: usernameController,
                              errorText: snapshot.data ? locale.mensagem.usernameIncorreto : null,
                              labelText: locale.palavra.usuario,
                              onChanged: (text) async {
                                loginBloc.username = text;
                              }
                            ),
                          );
                        }
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 60),
                      child: StreamBuilder<bool>(
                        initialData: false,
                        stream: loginBloc.passwordInvalidoOut,
                        builder: (context, snapshot) {
                          return Container(
                            child: customTextField(context,
                              obscureText: true,
                              controller: passwordController,
                              errorText: snapshot.data ? locale.mensagem.senhaIncorreta : null ,
                              labelText: locale.palavra.senha,
                              onChanged: (text) {
                                loginBloc.password = text;
                              }
                            ),
                          );
                        }
                      ),
                    ),
                    InkWell(
                      child: Container(
                        width: 340,
                        height: 50,
                        child: Center(
                          child: Text(locale.palavra.login, style: TextStyle(color: Colors.white,fontSize: 16),)),
                        decoration: BoxDecoration(
                          border:  Border.all(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      onTap: () async {
                        loginBloc.validaUsername();
                        loginBloc.validaPassword();
                        if(!loginBloc.formInvalido){
                          showLoading(context);
                          await loginBloc.doLogin(context);
                          if (loginBloc.login.statusLogin == StatusLogin.semConexao) {
                            Navigator.pop(context);
                            showMessage(
                              context: context,
                              titulo: "Erro",
                              mensagem: "Sem conexão com o servidor",
                              botaoList: [
                                FlatButton(
                                  child: Text("Fechar", style: Theme.of(context).textTheme.body2,),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ]
                            );
                          }
                          if(loginBloc.login.statusLogin == StatusLogin.usuarioSenhaInvalida){
                            Navigator.pop(context);
                            showMessage(
                              context: context,
                              titulo: "Erro",
                              mensagem: "Usuário e/ou senha inválido",
                              botaoList: [
                                FlatButton(
                                  child: Text("Fechar", style: Theme.of(context).textTheme.body2,),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ]
                            );
                          }
                          if(loginBloc.login.statusLogin == StatusLogin.loginOk){
                            if (await loginBloc.getVersaoEhValida()) {
                              print("********  versaoOk: TRUE ********");
                              Navigator.pop(context);
                              Navigator.push(context, 
                                MaterialPageRoute(
                                  settings: RouteSettings(name: '/Venda'),
                                  builder: (context) => VendaModule()
                                )
                              );
                              clearLogin();
                            } else {
                              print("********  versaoOk: FALSE ********");
                            }  
                          }
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: InkWell(
                        child: Container(
                          width: 340,
                          height: 50,
                          child: Center(child: Text(locale.telaLogin.criarConta, style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor))),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, 
                            MaterialPageRoute(
                              settings: RouteSettings(name: '/LoginCadastro'),
                              builder: (context) => 
                                LoginCadastroModule()
                            )
                          );
                        },
                      ),
                    ),  
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Container(
                    height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget> [ 
                          Align(
                            alignment: Alignment.bottomCenter,
                              child: Text(locale.telaLogin.ouEntreCom, style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              ), 
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                InkWell(
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset("assets/facebookLogo.png",width: 40),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text("Facebook", style: TextStyle(color: Colors.white)),
                                      )
                                    ],
                                  ),
                                  onTap: () async {
                                    showLoading(context);
                                    await loginBloc.getFacebookAuthorization(context);
                                    if(loginBloc.login != null){
                                      if(loginBloc.login.statusLogin == StatusLogin.usuarioJaCadastrado){
                                        showMessage(
                                          context: context,
                                          titulo: "E-mail já cadastrado",
                                          mensagem: "Deseja vincular o login com o Facebook à sua conta atual?",
                                          botaoList: [
                                            FlatButton(
                                              child: Text("Cancelar", style: Theme.of(context).textTheme.subtitle,),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            FlatButton(
                                              child: Text("Confirmar", style: Theme.of(context).textTheme.subtitle,),
                                              onPressed: () async {
                                                showLoading(context);
                                                await loginBloc.vinculaFacebook();
                                                if(loginBloc.statusCode == 200){
                                                  Navigator.pop(context);
                                                  loginBloc.syncLogin();
                                                  Navigator.push(context, 
                                                    MaterialPageRoute(
                                                      settings: RouteSettings(name: '/Venda'),
                                                      builder: (context) => VendaModule()
                                                    )
                                                  );
                                                }
                                              },
                                            ),
                                          ]
                                        );
                                      } else if(loginBloc.login.statusLogin == StatusLogin.loginOk){
                                        Navigator.pop(context);
                                        Navigator.push(context, 
                                          MaterialPageRoute(
                                            settings: RouteSettings(name: '/Venda'),
                                            builder: (context) => VendaModule()
                                          )
                                        );
                                      }
                                    } else {
                                      Navigator.pop(context);
                                      showMessage(
                                        context: context,
                                        titulo: "Erro",
                                        mensagem: "Algo de errado ocorreu, tente novamente em instantes",
                                        botaoList: [
                                          FlatButton(
                                            child: Text("OK", style: Theme.of(context).textTheme.body2,),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },           
                                          )
                                        ]
                                      );
                                    }
                                  },
                                ),
                                InkWell(
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset("assets/googleLogo.png",width: 40),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text("Google", style: TextStyle(color: Colors.white)),
                                      )
                                    ],
                                  ),
                                  onTap: () async {
                                    showLoading(context);
                                    await loginBloc.doGoogleSignIn(context);
                                    if(loginBloc.login.statusLogin == StatusLogin.usuarioJaCadastrado){
                                      showMessage(
                                        context: context,
                                        titulo: "E-mail já cadastrado",
                                        mensagem: "Deseja vincular o login com o Google à sua conta atual?",
                                        botaoList: [
                                          FlatButton(
                                            child: Text("Cancelar", style: Theme.of(context).textTheme.body2,),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Confirmar", style: Theme.of(context).textTheme.body2,),
                                            onPressed: () async {
                                              showLoading(context);
                                              await loginBloc.vinculaGoogle();
                                              if(loginBloc.statusCode == 200){
                                                Navigator.pop(context);
                                                loginBloc.syncLogin();
                                                Navigator.push(context, 
                                                  MaterialPageRoute(
                                                    settings: RouteSettings(name: '/Venda'),
                                                    builder: (context) => VendaModule()
                                                  )
                                                );
                                              }
                                            },
                                          ),
                                        ]
                                      );
                                    } else if(loginBloc.statusCode == 200){
                                      Navigator.pop(context);
                                      Navigator.push(context, 
                                        MaterialPageRoute(
                                          settings: RouteSettings(name: '/Venda'),
                                          builder: (context) => VendaModule()
                                        )
                                      );
                                    } else {
                                      Navigator.pop(context);
                                      showMessage(
                                        context: context,
                                        titulo: "Erro",
                                        mensagem: "Algo de errado ocorreu, tente novamente em instantes",
                                        botaoList: [
                                          FlatButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }
                                          )
                                        ]
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          )
                        ]
                      ),
                    ),
                ),
              )
            ],
          ), 
        ),
      ),
    );
  }

  showMessage({@required String titulo, @required String mensagem, @required BuildContext context, List<Widget> botaoList}){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).accentColor,
          title: Text(titulo),
          content: Text(mensagem, style: Theme.of(context).textTheme.body2,),
          actions: botaoList
        );
      }
    );
  }

  showLoading(BuildContext _context) {
    showDialog(
      barrierDismissible: true,
      context: _context,
      builder: (_context)  {
        return AlertDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          content:Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          )
        );
      }
    );
  } 

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }   
}
