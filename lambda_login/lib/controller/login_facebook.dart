
import 'dart:async';

import '../packages/postgresql-dart-master/lib/postgres.dart';
import '../packages/common_files/lib/common_files.dart';
import 'usuario_hasura.dart';
import 'login_cria_conta.dart';

class LoginFacebook {
  UsuarioHasura _usuarioHasura;
  //Pessoa _usuario;
  Login _login;

  LoginFacebook(this._login){
    _usuarioHasura = UsuarioHasura();
  }

  Future<Login> efetuarLogin() async {
    await getUsuario();
    if (_login.usuario.id != null && _login.usuario.id > 0) {
      _login.lojaList = await getLojaByPessoaGrupo(_login.usuario.idPessoaGrupo);
      print("_login.lojaList.length = "+_login.lojaList.length.toString());
      if (_login.lojaList.length > 1) {
        
      } else {
        print(_login.lojaList[0].id.toString());
        _usuarioHasura.idPessoa = _login.lojaList[0].id;
      }
      _usuarioHasura.id = _login.usuario.id;
      _usuarioHasura.idPessoaGrupo = _login.usuario.idPessoaGrupo;
      print("login.usuario = "+_login.usuario.razaoNome);
      _login.token = await _usuarioHasura.generateToken();
      print("login.token = "+_login.token);

      _login.terminal = await getTerminalByIdDevice(_login.idDevice, _login.lojaList[0].id);

      return _login;
    } else {
      print("Criar conta");
      LoginCriaConta loginCriaConta = LoginCriaConta(_login);
      await loginCriaConta.createConta();
      return _login;
    }
  }

  Future getUsuario() async {
    var postgresConnection = PostgreSQLConnection(postgresUrl, 5432, 
      postgresDatabase, username: postgresUsername, password: postgresPassword);


    if (postgresConnection.isClosed) {
      print("Abre conexao");
      await postgresConnection.open();
    }  

    print("select usuario");
    String sql = """
      select p.id, p.id_pessoa_grupo, p.razao_nome
      from pessoa p where p.ehusuario = 1 and id_facebook = @pIdFacebook
    """; 
    print("sql: "+sql);
    var result = await postgresConnection.query(sql, substitutionValues: {
      "pIdFacebook" : _login.usuario.idFacebook
    });
    print(result);
    if (result.length > 0) {
      try{
        _login.usuario.id = result.first[0];
        _login.usuario.idPessoaGrupo = result.first[1];
        _login.usuario.razaoNome = result.first[2];
      } catch (error) {
        print("Erro<getUsuario>: "+error);
        //_login.usuario = null;
      }
    } else {
      _login.usuario.id = 0;
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

  Future<Terminal> getTerminalByIdDevice(String idDevice, int idPessoa) async {
    print("<getTerminalByIdDevice> --- INICIO ---");
    var postgresConnection = PostgreSQLConnection(postgresUrl, 5432, 
      postgresDatabase, username: postgresUsername, password: postgresPassword);

    Terminal terminal = Terminal();

    if (postgresConnection.isClosed) {
      print("Abre conexao");
      await postgresConnection.open();
    }  

    print("select terminal");
    String sql = """
      select t.id, t.id_pessoa, t.nome, t.id_transacao, t.id_device, 
      t.mercadopago_id_terminal, t.mercadopago_qr_code, t.tem_picpay
      from terminal t 
      where t.ehdeletado = 0 and
      t.id_pessoa = ${idPessoa} and t.id_device = @pIdDevice
    """; 
    print("sql: "+sql);
    try{
      var result = await postgresConnection.query(sql, substitutionValues: {
        "pIdDevice" : idDevice
      });

      print(result);
      if (result.length > 0) {
        terminal.id = result[0][0];
        terminal.idPessoa = result[0][1];
        terminal.nome = result[0][2];
        terminal.idTransacao = result[0][3];
        terminal.idDevice = result[0][4];
        terminal.mercadopagoIdTerminal = result[0][5];
        terminal.mercadopagoQrCode = result[0][6];
        terminal.temPicpay = result[0][7];
        print('<getTerminalByIdDevice> pegou dados do banco');
      } else {
        terminal = null;
      }

      if (terminal == null) {
        print("<getTerminalByIdDevice> createTerminal");
        LoginCriaConta loginCriaConta = LoginCriaConta(_login);
        terminal = await loginCriaConta.createTerminal(getTransacao: true);
      }    

    } catch (e) {
      print('<getTerminalByIdDevice> Exception $e');
      terminal = null;
    } finally {
      await postgresConnection.close();
    }
    print("<getTerminalByIdDevice> --- FIM ---");
    return terminal;
  }
}