import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/home/home_module.dart';
import 'package:fluggy/src/pages/operacao/login/login_bloc.dart';
import 'package:fluggy/src/venda/venda_module.dart';
import 'package:flutter/material.dart';

class LoginCadastroPage extends StatefulWidget {
  LoginCadastroPage({Key key}) : super(key: key);

  @override
  _LoginCadastroPageState createState() => _LoginCadastroPageState();
}

class _LoginCadastroPageState extends State<LoginCadastroPage> {
  LoginCadastroBloc loginCadastroBloc;
  LoginBloc loginBloc;
  TextEditingController usernameController, emailController, passwordController, retypedPasswordController;
  bool login = false;

  @override
  void initState() {
    super.initState();
    loginCadastroBloc = LoginCadastroBloc(AppModule.to.getBloc<AppGlobalBloc>());
    loginBloc = AppModule.to.getBloc<LoginBloc>();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    retypedPasswordController = TextEditingController();
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
                height: 450,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25),
                      child: StreamBuilder<bool>(
                        initialData: false,
                        stream: loginCadastroBloc.usernameInvalidoOut,
                        builder: (context, snapshot) {
                          return Container(
                            child: customTextField(context,
                              autofocus: true,
                              controller: usernameController,
                              errorText: snapshot.data ? locale.mensagem.usernameIncorreto : null,
                              labelText: locale.palavra.usuario,
                              onChanged: (text) {
                                loginCadastroBloc.username = text;
                              }
                            ),
                          );
                        }
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
                      child: StreamBuilder<bool>(
                        initialData: false,
                        stream: loginCadastroBloc.emailInvalidoOut,
                        builder: (context, snapshot) {
                          return Container(
                            child: customTextField(context,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              errorText: snapshot.data ? locale.mensagem.emailIncorreto : null,
                              labelText: locale.palavra.email, 
                              onChanged: (text) {
                                loginCadastroBloc.email = text;
                              }
                            ),
                          );
                        }
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 8),
                      child: StreamBuilder<bool>(
                        initialData: false,
                        stream: loginCadastroBloc.passwordInvalidoOut,
                        builder: (context, snapshot) {
                          return Container(
                            child: customTextField(context,
                              obscureText: true,
                              controller: passwordController,
                              errorText: snapshot.data ? locale.mensagem.senhaIncorreta : null,
                              labelText: locale.palavra.senha,
                              onChanged: (text) {
                                loginCadastroBloc.password = text;
                              }
                            ),
                          );
                        }
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
                      child: StreamBuilder<bool>(
                        initialData: false,
                        stream: loginCadastroBloc.retypedPasswordInvalidaOut,
                        builder: (context, snapshot) {
                          return Container(
                            child: customTextField(context,
                              obscureText: true,
                              controller: retypedPasswordController,
                              errorText: snapshot.data ? locale.mensagem.senhasDiferentes : null,
                              labelText: locale.telaCadastroUsuario.redigiteASenha,
                              onChanged: (text) {
                                loginCadastroBloc.retypedPassword = text;
                              }
                            ),
                          );
                        }
                      ),
                    ),
                    FlatButton(
                      child: Container(
                        width: 340,
                        height: 50,
                        child: Center(
                          child: Text(locale.telaLogin.criarConta, style: TextStyle(color: Colors.white,fontSize: 16),)),
                        decoration: BoxDecoration(
                          border:  Border.all(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      onPressed: () async {
                        loginCadastroBloc.validaUsuario();
                        loginCadastroBloc.validaEmail();
                        loginCadastroBloc.validaSenha();
                        loginCadastroBloc.validaSenhaRedigitada();
                        if(!loginCadastroBloc.formInvalido){
                          showLoading(context);
                          await loginCadastroBloc.doSignUp(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          if (loginCadastroBloc.login.token != null) {
                            loginBloc.syncLogin();
                            Navigator.push(context, 
                              MaterialPageRoute(
                                settings: RouteSettings(name: '/Venda'),
                                builder: (context) => VendaModule()
                              )
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ), 
        ),
      ),
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
}
  
  