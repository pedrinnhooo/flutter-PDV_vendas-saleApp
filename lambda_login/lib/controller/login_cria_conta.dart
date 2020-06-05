import 'dart:convert';

import '../packages/postgresql-dart-master/lib/postgres.dart';
import '../packages/common_files/lib/common_files.dart';
import 'hasura_singleton.dart';
import 'usuario_hasura.dart';
import 'functions.dart';

class LoginCriaConta {
  Login _login;
  PessoaGrupo _newPessoaGrupo; 
  Pessoa _newLoja; 
  Pessoa _newUsuario; 
  Categoria _newCategoria;
  PrecoTabela _newPrecoTabela;
  List<TipoPagamento> _newTipoPagamentoList = [];
  Transacao _newTransacao;
  Terminal _newTerminal;
  int _newProdutoAutoInc;
  List<Variante> _newVarianteList = [];
  List<Grade> _newGradeList = [];
  List<Produto> _newProdutoList = [];

  LoginCriaConta(this._login){

  }

  Future createConta() async {
    print("createConta - INICIO");
    bool _existeUsuario = await existeUsuario();
    if (!_existeUsuario) {
      _newPessoaGrupo = PessoaGrupo();
      _newLoja = Pessoa();
      _newUsuario = Pessoa();
      _newCategoria = Categoria();
      _newPrecoTabela = PrecoTabela();
      _newTransacao = Transacao();
      _newTerminal = Terminal();
      try {
        await createPessoaGrupo();
        await createLoja();
        await createUsuario();
        _login.usuario = _newUsuario;
        await createPessoaModulo();
        await createCategoria();
        await createPrecoTabela();
        await createTipoPagamento();
        await createTransacao();
        await createTerminal();
        await createConfiguracaoCadastro();
        await createConfiguracaoGeral();
        await createConfiguracaoPessoa();
        //await createVariante();      
        //await createGrade();      
        await createProduto();      
        await createProdutoAutoInc();      
        await createSincronizacao();      
      } catch (error) {
        print("Erro<createConta>: "+error);
        _newPessoaGrupo = null;
        _newLoja = null;
        _newUsuario = null;
        _newCategoria = null;
        _newPrecoTabela = null;
        _newTransacao = null;
        _newTerminal = null;
      }  
    } else {
      _login.statusLogin = StatusLogin.usuarioJaCadastrado;
    } 
  }
  
  Future<bool> existeUsuario() async {
    print("validaUsuario - INICIO");
    var postgresConnection = PostgreSQLConnection(postgresUrl, 5432, 
      postgresDatabase, username: postgresUsername, password: postgresPassword);


    if (postgresConnection.isClosed) {
      print("Abre conexao");
      await postgresConnection.open();
    }  
    
    print("select usuario");
    String sql = """
      select p.id, p.id_pessoa_grupo, p.razao_nome, p.password
      from pessoa p 
      inner join contato ct on ct.id_pessoa = p.id
      where p.ehusuario = 1 and ct.email = @pEmail 
    """; 
    print("Sql: "+sql);
    try{
      var result = await postgresConnection.query(sql, substitutionValues: {
        "pEmail" : _login.usuario.contato[0].email
      });
      print(result.length.toString());
      _login.msgErro = "";
      
      if (result.length > 0) {
        _login.usuario.id = result.first[0];
        _login.usuario.idPessoaGrupo = result.first[1];
        _login.usuario.razaoNome = result.first[2];
        return true;
      } else {
        return false;
      }  
    } catch (error) {
      print("Erro SQL: "+error);
      _login.msgErro = error;
      return true;
    }  
  }

  Future createPessoaGrupo() async {
    print("createPessoaGrupo - INICIO");
    print("id_device: ${_login.idDevice}");
    String _query = """ mutation savePessoaGrupo {
        insert_pessoa_grupo(objects: {""";

    _query = _query + """
        id_pessoa: 1,
        nome: "${_login.usuario.razaoNome}"
        }) {
        returning {
          id,
          nome
        }
      }
    }  
    """; 
    print(_query);
    try {
      print("getHasuraConnect");
      await hasuraSingleton.getHasuraConnect();
      print("executa mutation");
      var data = await hasuraSingleton.hasuraConnect.mutation(_query);
      print("data: "+data.toString());
      _newPessoaGrupo.id = data["data"]["insert_pessoa_grupo"]["returning"][0]["id"];
      _newPessoaGrupo.nome = data["data"]["insert_pessoa_grupo"]["returning"][0]["nome"];
      print("_newPessoaGrupo.id: "+_newPessoaGrupo.id.toString());
      //print("_newPessoaGrupo.nome: "+_newPessoaGrupo.nome);
    } catch (error) {
      print("Erro <createPessoaGrupo>: "+error);
      _newPessoaGrupo = null;
    }  
    print("createPessoaGrupo - FIM");
  }

  Future createLoja() async {
    print("createLoja - INICIO");
    print("id_device: ${_login.idDevice}");
    print("_newPessoaGrupo.id: "+_newPessoaGrupo.id.toString());
    print("_login.usuario.razaoNome: "+_login.usuario.razaoNome);
    print("contato.lenght: "+_login.usuario.contato.length.toString());
    print("_login.usuario.contato[0].email: "+_login.usuario.contato[0].email);
    if (_newPessoaGrupo != null) {
      String _query = """ mutation savePessoa {
          insert_pessoa(objects: {""";

      print(_query);
      _query = _query + """
          id_pessoa_grupo: ${_newPessoaGrupo.id},
          razao_nome: "${_login.usuario.razaoNome}",
          fantasia_apelido: "${_login.usuario.razaoNome}",
          ehfisica: 1,
          ehloja: 1,
          contatos: {data: {
              nome: "${_login.usuario.razaoNome}",
              email: "${_login.usuario.contato[0].email}",
              ehprincipal: 1
          }}}) {
          returning {
            id,
            id_pessoa_grupo,
            razao_nome
          }
        }
      }  
      """; 
  
      print(_query);
      try {
        print("getHasuraConnect");
        await hasuraSingleton.getHasuraConnect(admin: true);
        print("executa mutation");
        var data = await hasuraSingleton.hasuraConnect.mutation(_query);
        _newLoja.id = data["data"]["insert_pessoa"]["returning"][0]["id"];
        _newLoja.idPessoaGrupo = data["data"]["insert_pessoa"]["returning"][0]["id_pessoa_grupo"];
        _newLoja.razaoNome = data["data"]["insert_pessoa"]["returning"][0]["razao_nome"];
        _login.lojaList.add(_newLoja);
      } catch (error) {
        print("Erro <createLoja>: "+error);
        _newLoja = null;
      }  
    }
    print("createLoja - FIM");
  }

  Future createUsuario() async {
    print("createUsuario - INICIO");
    print("id_device: ${_login.idDevice}");
    if (_newLoja != null) {
      print("_login.usuario.password: "+(_login.usuario.password != null ? _login.usuario.password : "null"));
      String password = ((_login.usuario.password != null) && (_login.usuario.password != "")) ? await generatePassword(_login.usuario.password) : null;
      String _query = """ mutation savePessoa {
          insert_pessoa(objects: {""";

      _query = _query + """
          razao_nome: "${_login.usuario.razaoNome}"
          fantasia_apelido: "${_login.usuario.razaoNome}"
          ehfisica: 1
          ehusuario: 1
          password: "${password != null ? password : ''}"
          id_facebook: "${_login.usuario.idFacebook != null ? _login.usuario.idFacebook : ''}"
          id_google: "${_login.usuario.idGoogle != null ? _login.usuario.idGoogle : ''}"
          contatos: {data: {
              nome: "${_login.usuario.razaoNome}",
              email: "${_login.usuario.contato[0].email}",
              ehprincipal: 1
            
          }}}) {
          returning {
            id,
            razao_nome
          }
        }
      }  
      """; 
      print(_query);
      try {
        UsuarioHasura usuarioHasura = UsuarioHasura();
        //usuarioHasura.generateToken(_newLoja);
        print("generateToken");
        //usuarioHasura.id = _newLoja.id;
        usuarioHasura.idPessoa = _newLoja.id;
        usuarioHasura.idPessoaGrupo = _newLoja.idPessoaGrupo;
        usuarioHasura.nome = _newLoja.razaoNome;
        _login.token = await usuarioHasura.generateToken();
        print("token: "+_login.token);
        print("getHasuraConnect");
        await hasuraSingleton.getHasuraConnect(admin: false, token: _login.token.split("|")[1]);
        print("executa mutation");
        var data = await hasuraSingleton.hasuraConnect.mutation(_query);
        _newUsuario.id = data["data"]["insert_pessoa"]["returning"][0]["id"];
        _newUsuario.razaoNome = data["data"]["insert_pessoa"]["returning"][0]["razao_nome"];
      } catch (error) {
        print("Erro <createUsuario>: "+error);
        _newUsuario = null;
      }  
    }
  }
  
  Future createPessoaModulo() async {
    print("createPessoaModulo - INICIO");
    print("id_device: ${_login.idDevice}");
    if (_newLoja != null) {
      /*
      List<Modulo> moduloList = []; 
      var postgresConnection = PostgreSQLConnection(postgresUrl, 5432, 
        postgresDatabase, username: postgresUsername, password: postgresPassword);

      if (postgresConnection.isClosed) {
        print("Abre conexao");
        await postgresConnection.open();
      }  
      
      print("select modulo");
      String sql = """
        select m.id, m.nome, m.valor
        from modulo m 
        where m.ehativo = 1
        order by m.id
      """; 
      print("Sql: "+sql);
      try{
        var result = await postgresConnection.query(sql);
        print(result.length.toString());
        print(result);
        if (result.length > 0) {
          for (var i = 0; i < result.length; i++) {
            print("for result");
            print("result[i][0]: "+result[i][0].toString());
            print("result[i][0]: "+result[i][1]);
            print("result[i][0]: "+result[i][2].toString());
            moduloList.add(
              Modulo(
                id: result[i][0],
                nome: result[i][1],
                valor: result[i][2]
              )
            );        
          }
        }  
      } catch (error) {
        print("Erro SQL: "+error);
      }  
      */
      String _query = """ mutation savePessoaModulo {
          insert_pessoa_modulo(objects: [""";

      _query = _query + 
        """
        {
          id_modulo_grupo: 1
          valor: 0,
          ehativo: 1,
          ehdemonstracao: 0,
          data_final_demonstracao: "${DateTime.now().add(Duration(days: 365))}",
        },  
        ]) {
          returning {
            id,
            }  
          }
        }  
        """;

      print(_query);
      try {
        print("getHasuraConnect");
        await hasuraSingleton.getHasuraConnect(admin: false, token: _login.token.split("|")[1]);
        print("executa mutation");
        var data = await hasuraSingleton.hasuraConnect.mutation(_query);
        // _newUsuario.id = data["data"]["insert_pessoa_modulo"]["returning"][0]["id"];
        // _newUsuario.razaoNome = data["data"]["insert_pessoa_modulo"]["returning"][0]["razao_nome"];
      } catch (error) {
        print("Erro <createUsuario>: "+error);
        _newUsuario = null;
      }  
      print("createPessoaModulo - FIM");
    }
  }  

  Future createCategoria() async {
    print("createCategoria - INICIO");
    print("id_device: ${_login.idDevice}");
    if (_newLoja != null) {
      String _query = """ mutation saveCategoria {
          insert_categoria(objects: {""";

      _query = _query + """
          nome: "Padrão"
            
          }) {
          returning {
            id,
          }
        }
      }  
      """; 
      print(_query);
      try {
        print("getHasuraConnect");
        await hasuraSingleton.getHasuraConnect(admin: false, token: _login.token.split("|")[1]);
        print("executa mutation");
        var data = await hasuraSingleton.hasuraConnect.mutation(_query);
        print(data);
        _newCategoria.id = data["data"]["insert_categoria"]["returning"][0]["id"];
        //_newUsuario.razaoNome = data["data"]["insert_pessoa"]["returning"][0]["razao_nome"];
      } catch (error) {
        print("Erro <createCategoria>: "+error);
        //_newUsuario = null;
      }  
    }
  }

  Future createPrecoTabela() async {
    print("createPrecoTabela - INICIO");
    if (_newLoja != null) {
      String _query = """ mutation savePrecoTabela {
          insert_preco_tabela(objects: {""";

      _query = _query + """
          nome: "Padrão"
            
          }) {
          returning {
            id,
          }
        }
      }  
      """; 
      print(_query);
      try {
        print("getHasuraConnect");
        await hasuraSingleton.getHasuraConnect(admin: false, token: _login.token.split("|")[1]);
        print("executa mutation");
        var data = await hasuraSingleton.hasuraConnect.mutation(_query);
        _newPrecoTabela.id = data["data"]["insert_preco_tabela"]["returning"][0]["id"];
        //_newUsuario.razaoNome = data["data"]["insert_pessoa"]["returning"][0]["razao_nome"];
      } catch (error) {
        print("Erro <createPrecoTabela>: "+error);
        //_newUsuario = null;
      }  
    }
  }

  Future createTipoPagamento() async {
    print("createTipoPagamento - INICIOx");
    print("id_device: ${_login.idDevice}");
    Map<String, dynamic> json = jsonDecode("""
      {"tipo_pagamento": [
        {
          "nome": "Dinheiro",
          "icone": "images/tipoPagamento/dinheiro.png",
          "ehdinheiro": 1,
          "ehfiado": 0,
          "ehqrcode": 0
        },
        {
          "nome": "Débito",
          "icone": "images/tipoPagamento/debito.png",
          "ehdinheiro": 0,
          "ehfiado": 0,
          "ehqrcode": 0
        },
        {
          "nome": "Crédito",
          "icone": "images/tipoPagamento/credito.png",
          "ehdinheiro": 0,
          "ehfiado": 0,
          "ehqrcode": 0
        },
        {
          "nome": "QRCode",
          "icone": "images/tipoPagamento/qrcode.png",
          "ehdinheiro": 0,
          "ehfiado": 0,
          "ehqrcode": 1
        },
        {
          "nome": "Fiado",
          "icone": "images/tipoPagamento/fiado.png",
          "ehdinheiro": 0,
          "ehfiado": 1,
          "ehqrcode": 0
        },
        {
          "nome": "Outros",
          "icone": "images/tipoPagamento/outro.png",
          "ehdinheiro": 0,
          "ehfiado": 0,
          "ehqrcode": 0
        }
      ]}
    """);

    print("importa json");
    json['tipo_pagamento'].forEach((v) {
      _newTipoPagamentoList.add(new TipoPagamento.fromJson(v));
    });

    print(_newTipoPagamentoList.length.toString());
    if (_newTipoPagamentoList.length > 0) {
      String _query = """ mutation saveTipoPagamento {
          insert_tipo_pagamento(objects: """;
      for (var i=0; i < _newTipoPagamentoList.length; i++){
        print("for _newTipoPagamentoList");
        if (i == 0) {
          _query = _query + '[';
        }  

        _query = _query + 
          """
          {
            nome: "${_newTipoPagamentoList[i].nome}",
            icone: "${_newTipoPagamentoList[i].icone}",
            ehdinheiro: ${_newTipoPagamentoList[i].ehDinheiro},
            ehfiado: ${_newTipoPagamentoList[i].ehFiado},
            ehqrcode: ${_newTipoPagamentoList[i].ehQrcode}
          },  
          """;
        if (i == _newTipoPagamentoList.length-1){
          _query = _query + 
            """]) {
               returning {
                 id,
                 nome 
                }  
              }
            }  
            """;
        }
      }

      print(_query);
      try {
        print("getHasuraConnect");
        await hasuraSingleton.getHasuraConnect(admin: false, token: _login.token.split("|")[1]);
        print("executa mutation");
        var data = await hasuraSingleton.hasuraConnect.mutation(_query);
        print(data);
        //_newUsuario.razaoNome = data["data"]["insert_pessoa"]["returning"][0]["razao_nome"];
      } catch (error) {
        print("Erro <createTipoPagamento>: "+error);
        //_newUsuario = null;
      }  
    }
  }

  Future createTransacao() async {
    print("createTransacao - INICIO");
      String _query = """ 
        mutation saveTransacao {
        insert_transacao(objects: [
          {
            nome: "Venda",
            id_preco_tabela: ${_newPrecoTabela.id},
            tem_cliente: 0,
            tem_pagamento: 1,
            tem_vendedor: 0,
            tipo_estoque: 0,
            desconto_percentual: 0
          },  
          {
            nome: "Devolução",
            id_preco_tabela: ${_newPrecoTabela.id},
            tem_cliente: 0,
            tem_pagamento: 1,
            tem_vendedor: 0,
            tipo_estoque: 1,
            desconto_percentual: 0
          },  
          ]) {
              returning {
                id,
                nome 
              }  
            }
          }  
        """;

    print(_query);
    try {
      print("getHasuraConnect");
      await hasuraSingleton.getHasuraConnect(admin: false, token: _login.token.split("|")[1]);
      print("executa mutation");
      var data = await hasuraSingleton.hasuraConnect.mutation(_query);
      print(data);
      _newTransacao.id = data["data"]["insert_transacao"]["returning"][0]["id"];
    } catch (error) {
      print("Erro <createTransacao>: "+error);
      //_newUsuario = null;
    }  
  }  

  Future<Terminal> createTerminal({bool getTransacao=false}) async {
    print("createTerminal - INICIO");
    print("id_device: ${_login.idDevice}");
    _newTerminal = _newTerminal == null ? Terminal() : _newTerminal;
    if (getTransacao) {
      _newTransacao = await getTransacaoVenda();
    }
    
    if (_newTransacao != null) {
      String _query = """ mutation saveTerminal {
          insert_terminal(objects: {""";

      _query = _query + """
          id_transacao: ${_newTransacao.id},
          id_device: "${_login.idDevice}",
          nome: "Terminal ${_login.idDevice}"
            
          }) {
          returning {
            id,
            id_transacao,
            id_device,
            nome
          }
        }
      }  
      """; 
      print(_query);
      try {
        print("getHasuraConnect");
        await hasuraSingleton.getHasuraConnect(admin: false, token: _login.token.split("|")[1]);
        print("executa mutation");
        var data = await hasuraSingleton.hasuraConnect.mutation(_query);
        print("<createTerminal> data: ${data.toString()}");
        _newTerminal.id = data["data"]["insert_terminal"]["returning"][0]["id"];
        _newTerminal.idTransacao = data["data"]["insert_terminal"]["returning"][0]["id_transacao"];
        _newTerminal.idDevice = data["data"]["insert_terminal"]["returning"][0]["id_device"];
        _newTerminal.nome = data["data"]["insert_terminal"]["returning"][0]["nome"];
      } catch (error) {
        print("Erro <createTerminal> Exception: ${error.toString()}");
        _newTerminal = null;
      }  
    }
    _login.terminal = _newTerminal;
    return _newTerminal;
  }

  Future<ConfiguracaoCadastro> createConfiguracaoCadastro() async {
    print("createConfiguracaoCadastro - INICIO");
    
    ConfiguracaoCadastro configuracaoCadastro = ConfiguracaoCadastro(); 
    String _query = """ mutation saveConfiguracaoCadastro {
        insert_configuracao_cadastro(objects: {""";

    _query = _query + """
        eh_produto_autoinc: 1
        }) {
        returning {
          id,
        }
      }
    }  
    """; 
    print(_query);
    try {
      print("getHasuraConnect");
      await hasuraSingleton.getHasuraConnect(admin: false, token: _login.token.split("|")[1]);
      print("executa mutation");
      var data = await hasuraSingleton.hasuraConnect.mutation(_query);
      configuracaoCadastro.id = data["data"]["insert_configuracao_cadastro"]["returning"][0]["id"];
    } catch (error) {
      print("Erro <createConfiguracaoCadastro>: "+error);
      configuracaoCadastro = null;
    }  
    return configuracaoCadastro;
  }

  Future<ConfiguracaoGeral> createConfiguracaoGeral() async {
    print("createConfiguracaoGeral - INICIO");
    
    ConfiguracaoGeral configuracaoGeral = ConfiguracaoGeral(); 
    String _query = """ mutation saveConfiguracaoGeral {
        insert_configuracao_geral(objects: {""";

    _query = _query + """
        tem_servico: 0,
        ehservico_default: 0,
        ehmenu_classico: 0
        }) {
        returning {
          id,
        }
      }
    }  
    """; 
    print(_query);
    try {
      print("getHasuraConnect");
      await hasuraSingleton.getHasuraConnect(admin: false, token: _login.token.split("|")[1]);
      print("executa mutation");
      var data = await hasuraSingleton.hasuraConnect.mutation(_query);
      configuracaoGeral.id = data["data"]["insert_configuracao_geral"]["returning"][0]["id"];
    } catch (error) {
      print("Erro <createConfiguracaoGeral>: "+error);
      configuracaoGeral = null;
    }  
    return configuracaoGeral;
  }

  Future<ConfiguracaoPessoa> createConfiguracaoPessoa() async {
    print("createConfiguracaoPessoa - INICIO");
    
    ConfiguracaoPessoa configuracaoPessoa = ConfiguracaoPessoa(); 
    String _query = """ mutation saveConfiguracaoPessoa {
        insert_configuracao_pessoa(objects: {""";

    _query = _query + """
        texto_cabecalho: "Cabeçalho",
        texto_rodape: "Rodapé",
        }) {
        returning {
          id,
        }
      }
    }  
    """; 
    print(_query);
    try {
      print("getHasuraConnect");
      await hasuraSingleton.getHasuraConnect(admin: false, token: _login.token.split("|")[1]);
      print("executa mutation");
      var data = await hasuraSingleton.hasuraConnect.mutation(_query);
      configuracaoPessoa.id = data["data"]["insert_configuracao_pessoa"]["returning"][0]["id"];
    } catch (error) {
      print("Erro <createConfiguracaoPessoa>: "+error);
      configuracaoPessoa = null;
    }  
    return configuracaoPessoa;
  }

  Future createVariante() async {
    print("createVariante - INICIO");
    print("id_device: ${_login.idDevice}");
    Map<String, dynamic> json = jsonDecode("""
      {"variante": [
        {
          "nome": "BRANCO",
          "iconecor": "0XFFFFFFFF"
        },
        {
          "nome": "PRETO",
          "iconecor": "0XFF000000"
        },
        {
          "nome": "VERMELHO",
          "icone_cor": "0XFFEA0124"
        },
        {
          "nome": "VERDE",
          "iconecor": "0XFF019F01"
        },
        {
          "nome": "AMARELO",
          "iconecor": "0XFFF7F301"
        },
        {
          "nome": "MARROM",
          "iconecor": "0XFF721616"
        }
      ]}
    """);
    print("importa json");
    json['variante'].forEach((v) {
      _newVarianteList.add(new Variante.fromJson(v));
    });

    print(_newVarianteList.length.toString());
    if (_newVarianteList.length > 0) {
      String _query = """ mutation saveVariante {
          insert_variante(objects: """;
      for (var i=0; i < _newVarianteList.length; i++){
        print("for _newVarianteList");
        if (i == 0) {
          _query = _query + '[';
        }  

        _query = _query + 
          """
          {
            nome: "${_newVarianteList[i].nome}",
            iconecor: "${_newVarianteList[i].iconeCor}",
          },  
          """;
        if (i == _newVarianteList.length-1){
          _query = _query + 
            """]) {
               returning {
                 id,
                 nome 
                }  
              }
            }  
            """;
        }
      }

      print(_query);
      try {
        _newVarianteList.clear();
        print("getHasuraConnect");
        await hasuraSingleton.getHasuraConnect(admin: false, token: _login.token.split("|")[1]);
        print("executa mutation");
        var data = await hasuraSingleton.hasuraConnect.mutation(_query);
        print(data);
        data["data"]["insert_variante"]["returning"].forEach((v) {
          _newVarianteList.add(new Variante.fromJson(v));
        });
      } catch (error) {
        print("Erro <createVariante>: "+error);
        //_newUsuario = null;
      }  
    }
  }

  Future createGrade() async {
    print("createGrade - INICIO");
    Map<String, dynamic> json = jsonDecode("""
      {"grade": [
        {
          "nome": "PP ao GG",
          "t1": "PP",
          "t2": "P",
          "t3": "M",
          "t4": "G",
          "t5": "GG",
          "t6": "",
          "t7": ""
        },
        {
          "nome": "34 ao 46",
          "t1": "34",
          "t2": "36",
          "t3": "38",
          "t4": "40",
          "t5": "42",
          "t6": "44",
          "t7": "46"
        }
      ]}
    """);
    print("importa json");
    json['grade'].forEach((v) {
      _newGradeList.add(new Grade.fromJson(v));
    });

    print(_newGradeList.length.toString());
    if (_newGradeList.length > 0) {
      String _query = """ mutation saveGrade {
          insert_grade(objects: """;
      for (var i=0; i < _newGradeList.length; i++){
        print("for _newGradeList");
        if (i == 0) {
          _query = _query + '[';
        }  

        _query = _query + 
          """
          {
            nome: "${_newGradeList[i].nome}",
            t1: "${_newGradeList[i].t1}",
            t2: "${_newGradeList[i].t2}",
            t3: "${_newGradeList[i].t3}",
            t4: "${_newGradeList[i].t4}",
            t5: "${_newGradeList[i].t5}",
            t6: "${_newGradeList[i].t6}",
            t7: "${_newGradeList[i].t7}"
          },  
          """;
        if (i == _newGradeList.length-1){
          _query = _query + 
            """]) {
               returning {
                 id,
                 nome 
                }  
              }
            }  
            """;
        }
      }

      print(_query);
      try {
        _newGradeList.clear();
        print("getHasuraConnect");
        await hasuraSingleton.getHasuraConnect(admin: false, token: _login.token.split("|")[1]);
        print("executa mutation");
        var data = await hasuraSingleton.hasuraConnect.mutation(_query);
        print(data);
        data["data"]["insert_grade"]["returning"].forEach((v) {
          _newGradeList.add(new Grade.fromJson(v));
        });
      } catch (error) {
        print("Erro <createGrade>: "+error);
        //_newUsuario = null;
      } 
      print("Grade[0]: "+_newGradeList[0].toString());
    }
  }

  Future createProdutoAutoInc() async {
    print("createProdutoAutoInc - INICIO");
    if (_newTransacao != null) {
      String _query = """ mutation saveProdutoAutoInc {
          insert_produto_autoinc(objects: {""";

      _query = _query + """
          autoinc: 3,
            
          }) {
          returning {
            autoinc,
          }
        }
      }  
      """; 
      print(_query);
      try {
        print("getHasuraConnect");
        await hasuraSingleton.getHasuraConnect(admin: false, token: _login.token.split("|")[1]);
        print("executa mutation");
        var data = await hasuraSingleton.hasuraConnect.mutation(_query);
        _newProdutoAutoInc = data["data"]["insert_produto_autoinc"]["returning"][0]["autoinc"];
        print("_newProdutoAutoInc: "+_newProdutoAutoInc.toString());
        //_newUsuario.razaoNome = data["data"]["insert_pessoa"]["returning"][0]["razao_nome"];
      } catch (error) {
        print("Erro <createProdutoAutoInc>: "+error);
        //_newUsuario = null;
      }  
    }
  }

  Future createProduto() async {
    print("createProduto - INICIO");
    Map<String, dynamic> json = jsonDecode("""
      {"produto": [
        {
          "nome": "Café Pilão cápsulas",
          "preco_custo": 11.9,
          "preco_tabela_items": 
            {
              "preco": 19.9
            }
          ,
          "produto_imagem": [
             {
               "imagem": "/images/produto/demo/cafepilao.png"
             } 
          ]  
        },
        {
          "nome": "Pilha Duracell AAA",
          "preco_custo": 8.9,
          "preco_tabela_items": 
            {
              "preco": 16.9
            }
          ,
          "produto_imagem": [
             {
               "imagem": "/images/produto/demo/pilhaduracell.png"
             } 
          ]  
        }
      ]}
    """);
    print("importa json");
    json['produto'].forEach((v) {
      _newProdutoList.add(new Produto.fromJson(v));
    });

    print(_newProdutoList.length.toString());
    if (_newProdutoList.length > 0) {
      String _query = """ mutation saveProduto {
          insert_produto(objects: """;
      for (var i=0; i < _newProdutoList.length; i++){
        print("for _newProdutoList");
        if (i == 0) {
          _query = _query + '[';
        }  


       print("_newCategoria.id: "+_newCategoria.id.toString()); 
       //print("_newGradeList[i].id: "+ ((i != 2) ? _newGradeList[i].id.toString() : '')); 
       print("_newProdutoList[i].nome: "+_newProdutoList[i].nome); 
       print("_newProdutoList[i].precoCusto: "+_newProdutoList[i].precoCusto.toString()); 
       print("_newPrecoTabela.id: "+_newPrecoTabela.id.toString()); 
       print("_newProdutoList[i].precoTabelaItem.preco: "+_newProdutoList[i].precoTabelaItem.preco.toString()); 
       print("_newProdutoList[i].produtoImagem[0].imagem: "+_newProdutoList[i].produtoImagem[0].imagem); 
        _query = _query + 
          """
          {
            id_aparente: "${i+1}",
            id_categoria: ${_newCategoria.id},
            """+
            //id_grade: ${i != 2 ? _newGradeList[i].id : null},
            """
            nome: "${_newProdutoList[i].nome}",
            ehativo: 1,
            preco_custo: ${_newProdutoList[i].precoCusto},
            preco_tabela_items: {data: 
              {
                id_preco_tabela: ${_newPrecoTabela.id}, 
                preco: ${_newProdutoList[i].precoTabelaItem.preco}
              }
            }, 
            produto_imagem: {data: 
              {
                imagem: "${_newProdutoList[i].produtoImagem[0].imagem}"
              }
            }, 

          },  
          """;
        if (i == _newProdutoList.length-1){
          _query = _query + 
            """]) {
               returning {
                 id,
                 nome 
                }  
              }
            }  
            """;
        }
      }

      print(_query);
      try {
        _newProdutoList.clear();
        print("getHasuraConnect");
        await hasuraSingleton.getHasuraConnect(admin: false, token: _login.token.split("|")[1]);
        print("executa mutation");
        var data = await hasuraSingleton.hasuraConnect.mutation(_query);
        print(data);
        // data["data"]["insert_produto"]["returning"].forEach((v) {
        //   _newProdutoList.add(new Produto.fromJson(v));
        // });
      } catch (error) {
        print("Erro <createProduto>: "+error);
        //_newUsuario = null;
      }  
    }
  }

  Future createSincronizacao() async {
    print("createSincronizacao - INICIO");
    if (_newLoja != null) {
      String _query = """ mutation saveSincronizacao {
          insert_sincronizacao(objects: {""";

      _query = _query + """
          tabela: "Padrão"
            
          }) {
          returning {
            data_atualizacao
          }
        }
      }  
      """; 
      print(_query);
      try {
        print("getHasuraConnect");
        await hasuraSingleton.getHasuraConnect(admin: false, token: _login.token.split("|")[1]);
        print("executa mutation");
        var data = await hasuraSingleton.hasuraConnect.mutation(_query);
        print(data);
        String data_atualizacao = data["data"]["insert_sincronizacao"]["returning"][0]["data_atualizacao"];
        print("data_atualizacao: " + data_atualizacao);
        //_newUsuario.razaoNome = data["data"]["insert_pessoa"]["returning"][0]["razao_nome"];
      } catch (error) {
        print("Erro <createSincronizacao>: "+error);
        //_newUsuario = null;
      }  
    }
  }

  Future<Transacao> getTransacaoVenda() async {
    print("<getTransacaoVenda> --- INICIO ---");
    var postgresConnection = PostgreSQLConnection(postgresUrl, 5432, 
      postgresDatabase, username: postgresUsername, password: postgresPassword);

    Transacao transacao = Transacao();

    if (postgresConnection.isClosed) {
      print("Abre conexao");
      await postgresConnection.open();
    }  

    try {
      await postgresConnection.transaction((ctx) async {
        print("select transacao");
        print("_login.pessoaGrupo.id: "+_login.usuario.idPessoaGrupo.toString());
        String sql = """
          select t.id, t.id_pessoa_grupo, t.nome
          from transacao t 
          where t.ehdeletado = 0 and
          t.id_pessoa_grupo = ${_login.usuario.idPessoaGrupo} and 
          ((tem_pagamento = 1) and (tipo_estoque = 0))
          order by t.id 
        """; 
        print("sql: "+sql);
        var result = await ctx.query(sql);
        print(result);
        if (result.length > 0) {
          transacao.id = result[0][0];
          transacao.idPessoaGrupo = result[0][1];
          transacao.nome =result[0][2];
        } else {
          transacao = null;
        }
      });
    } catch (e) {
      transacao = null;
    } finally {
      await postgresConnection.close();
    }
    print("<getTransacaoVenda> --- FIM ---");
    return transacao;
  }

}