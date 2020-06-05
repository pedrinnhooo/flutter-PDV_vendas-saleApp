import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:hasura_connect/hasura_connect.dart';

class HasuraBlocLambda extends BlocBase {
  static String url = "http://ec2-54-233-64-9.sa-east-1.compute.amazonaws.com:8080/v1/graphql";
  UsuarioHasura _usuarioHasura;
  HasuraConnect hasuraConnect; 
  HasuraBlocLambda(this._usuarioHasura) {
    hasuraConnect = HasuraConnect(url, token: () async {
      return _usuarioHasura.getTokenToHasura();
    });
  }

  @override
  void dispose() {
    hasuraConnect.dispose();
    super.dispose();
  }
}