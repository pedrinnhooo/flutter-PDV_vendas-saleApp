import '../../common_files.dart';


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

int getStatusLoginIndex(StatusLogin value) {
  switch (value) {
    case StatusLogin.loginOk: return StatusLogin.loginOk.index;
    case StatusLogin.usuarioSenhaInvalida: return StatusLogin.usuarioSenhaInvalida.index;
    case StatusLogin.usuarioJaCadastrado: return StatusLogin.usuarioJaCadastrado.index;
    case StatusLogin.usuarioBloqueado: return StatusLogin.usuarioBloqueado.index;
  }
}
// Future<Cep> consultaCep(String value) async {
//   var dio = Dio();
//   try {
//     Response response = await dio.get("https://viacep.com.br/ws/$value/json/");
//     if (response.statusCode == 200) {
//         return Cep.fromMap(response.data);
//     } else {
//       throw null;
//     }   
//   } catch (erro) {
//     return null;  
//   }
//}