import 'dart:async';
import '../packages/common_files/lib/common_files.dart';
import '../packages/postgresql-dart-master/lib/postgres.dart';
import 'usuario_hasura.dart';
import 'hasura_singleton.dart';

class VinculaGoogle {
  UsuarioHasura _usuarioHasura;
  //Pessoa _usuario;
  Login _login;

  VinculaGoogle(this._login){
    _usuarioHasura = UsuarioHasura();
  }

  Future<Login> vinculaGoogle() async {
    print("VinculaGoogle - INICIO");
    if ((_login.usuario.id != null) && (_login.usuario.id > 0 ) && 
        (_login.usuario.idGoogle != "")) {
      String _query = """ mutation savePessoa {
          update_pessoa(
            where: {id: {_eq: ${_login.usuario.id}}},
              _set: {id_google: "${_login.usuario.idGoogle}"}) {
            returning {
              id
              id_google
            }  
          }  
        }  """;

      print(_query);
      try {
        _login.lojaList = await getLojaByPessoaGrupo(_login.usuario.idPessoaGrupo);
        print("_login.lojaList.length = "+_login.lojaList.length.toString());
        UsuarioHasura usuarioHasura = UsuarioHasura();
        if (_login.lojaList.length > 1) {
          
        } else {
          print(_login.lojaList[0].id.toString());
          _usuarioHasura.idPessoa = _login.lojaList[0].id;
        }
        _usuarioHasura.id = _login.usuario.id;
        _usuarioHasura.idPessoaGrupo = _login.usuario.idPessoaGrupo;
        print("generateToken");
        _login.token = await usuarioHasura.generateToken();
        print("token: "+_login.token);
        print("getHasuraConnect");
        await hasuraSingleton.getHasuraConnect(admin: false, token: _login.token.split("|")[1]);
        print("executa mutation");
        var data = await hasuraSingleton.hasuraConnect.mutation(_query);
        print("data: "+data.toString());
        _login.usuario.id = data["data"]["update_pessoa"]["returning"][0]["id"];
        _login.usuario.idPessoaGrupo = data["data"]["update_pessoa"]["returning"][0]["id_pessoa"];
        _login.usuario.razaoNome = data["data"]["update_pessoa"]["returning"][0]["razao_nome"];
        _login.usuario.idGoogle = data["data"]["update_pessoa"]["returning"][0]["id_google"];
        print("VinculaGoogle - FIM");
        return _login;
      } catch (error) {
        print("Erro <VinculaGoogle>: "+error);
        _login.token = null;
        print("VinculaGoogle - FIM");
        return _login;
      }  
    } else {
      print("VinculaGoogle - FIM");
      return _login;
    }
  }

  Future<List<Pessoa>> getLojaByPessoaGrupo(int _idPessoaGrupo) async {
    var postgresConnection = PostgreSQLConnection(postgresUrl, 5432, 
      postgresDatabase, username: postgresUsername, password: postgresPassword);
    List<Pessoa> pessoaList = [];

    if (postgresConnection.isClosed) {
      print("Abre conexao");
      await postgresConnection.open();
    }  
    await postgresConnection.transaction((ctx) async {
      print("select loja");
      String sql = """
        select p.id, p.id_pessoa_grupo, p.razao_nome, p.fantasia_apelido, p.ehloja
        from pessoa p where p.ehloja = 1 and id_pessoa_grupo = ${_idPessoaGrupo}
        order by p.id
      """; 
      print("sql: "+sql);
      var result = await ctx.query(sql);
      print(result);
      try{
        for (var i = 0; i < result.length; i++) {
          print("for: "+i.toString());
          print(result[i][0]);
          print(result[i][1]);
          print(result[i][2]);
          print(result[i][3]);
          Pessoa pessoa = Pessoa();
          pessoa.id = result[i][0];
          pessoa.idPessoaGrupo = result[i][1];
          pessoa.razaoNome =result[i][2];
          pessoa.fantasiaApelido =result[i][3];
          pessoa.ehLoja =result[i][4];
          print("pessoaList.add");
          pessoaList.add(pessoa);
          pessoa = null;
        }
      } catch (e) {
        pessoaList = null;
      }
    });
    return pessoaList;
  }

}