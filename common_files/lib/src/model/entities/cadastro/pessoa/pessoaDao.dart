import 'package:common_files/common_files.dart';
import 'package:sqflite/sqflite.dart';

class PessoaDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "pessoa";
  int filterId;
  String filterText;
  bool filterEhLoja = false;
  bool filterEhCliente = false;
  bool filterEhFornecedor = false;
  bool filterEhVendedor = false;
  bool filterEhUsuario = false;
  bool filterEhRevenda = false;
  bool loadEndereco = false;
  bool loadContato = false;
  bool loadIntegracao =false;

  Pessoa pessoa; 
  List<Pessoa> pessoaList;
  Endereco _endereco;
  Contato _contato;
  Integracao _integracao;

  @override
  Dao dao;

  PessoaDAO(this._hasuraBloc, this._appGlobalBloc, this.pessoa) {
    dao = Dao();
    _endereco = Endereco();
    _integracao = Integracao();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    try {
      this.pessoa.id = map['id'];
      this.pessoa.idPessoaGrupo = map['id_pessoa_grupo'];
      this.pessoa.razaoNome = map['razao_nome'];
      this.pessoa.fantasiaApelido = map['fantasia_apelido'];
      this.pessoa.cnpjCpf = map['cnpj_cpf'];
      this.pessoa.ieRg = map['ie_rg'];
      this.pessoa.im = map['im'];
      this.pessoa.ehFisica = map['ehfisica'];
      this.pessoa.ehLoja = map['ehloja'];
      this.pessoa.ehCliente = map['ehcliente'];
      this.pessoa.ehFornecedor = map['ehfornecedor'];
      this.pessoa.ehVendedor = map['ehvendedor'];
      this.pessoa.ehUsuario = map['ehusuario'];
      this.pessoa.ehRevenda = map['ehrevenda'];
      this.pessoa.ehDeletado = map['ehdeletado'];
      this.pessoa.dataCadastro = map['data_cadastro'] != null ? DateTime.parse(map['data_cadastro']) : null;
      this.pessoa.dataAtualizacao = map['data_atualizacao'] != null ? DateTime.parse(map['data_atualizacao']) : null;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoaDao> fromMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoaDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
    return this.pessoa;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where;
    try {
      where = "id_pessoa_grupo = ${_appGlobalBloc.loja.idPessoaGrupo} and ehdeletado = 0 ";
      List<dynamic> args = [];
      if ((filterId > 0) || (filterText != "")) {
        if (filterId > 0) {
          where = where + "and (id = " + filterText + ")";
        }
        if (filterText != "") {
          where = where + "and (nome like '%" + filterText + "%')";
        }
      }

      where = filterEhLoja ? where + " and ehloja = 1 " : where;
      where = filterEhCliente ? where + " and ehcliente = 1 " : where;
      where = filterEhFornecedor ? where + " and ehfornecedor = 1 " : where;
      where = filterEhVendedor ? where + " and ehvendedor = 1 " : where;
      where = filterEhRevenda ? where + " and ehrevenda = 1 " : where;

      List list = await dao.getList(this, where, args);
      pessoaList = List.generate(list.length, (i) {
        return Pessoa(
          id: list[i]['id'],
          idPessoaGrupo: list[i]['id_pessoa_grupo'],
          razaoNome: list[i]['razao_nome'],
          fantasiaApelido: list[i]['fantasia_apelido'],
          cnpjCpf: list[i]['cnpj_cpf'],
          ieRg: list[i]['ie_rg'],
          im: list[i]['im'],
          ehFisica: list[i]['ehfisica'],
          ehLoja: list[i]['ehloja'],
          ehCliente: list[i]['ehcliente'],
          ehFornecedor: list[i]['ehfornecedor'],
          ehVendedor: list[i]['ehvendedor'],
          ehUsuario: list[i]['ehusuario'],
          ehRevenda: list[i]['ehrevenda'],
          ehDeletado: list[i]['ehdeletado'],
          dataCadastro: list[i]['data_cadastro'] != null ? DateTime.parse(list[i]['data_cadastro']) : null,
          dataAtualizacao: list[i]['data_atualizacao'] != null ? DateTime.parse(list[i]['data_atualizacao']) : null
        );
      });
    
      if (preLoad) {
        for (var pessoa in pessoaList) {
          EnderecoDAO enderecoDAO = EnderecoDAO(_hasuraBloc, _endereco);
          ContatoDAO contatoDAO = ContatoDAO(_hasuraBloc, _contato);
          IntegracaoDAO integracaoDAO = IntegracaoDAO(_hasuraBloc, _appGlobalBloc);
          if (loadEndereco) {
            enderecoDAO.filterIdPessoa = pessoa.id;
            List<Endereco> enderecoList =
                await enderecoDAO.getAll();
            pessoa.endereco = enderecoList;
          }
        
          if (loadContato) {
            enderecoDAO.filterIdPessoa = pessoa.id;
            List<Contato> contatoList =
                await contatoDAO.getAll();
            pessoa.contato = contatoList;
          }
          if (loadIntegracao) {
            List<Integracao> integracaoList =
                await integracaoDAO.getAll();
            pessoa.integracao = integracaoList;
          }
          enderecoDAO = null;
        }
      }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoaDao> getAll');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoaDao",
        nomeFuncao: "getAll",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: where
      );
    }   
    return pessoaList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool completo=false, 
    bool id=false, bool idPessoaGrupo=false, bool cnpjCpf=false, bool ieRg=false,
    bool im=false, bool ehFisica=false, bool ehDeletado=false, 
    bool ehLoja=false, bool ehCliente=false, bool ehFornecedor=false,
    bool ehVendedor=false, bool ehRevenda=false, bool ehUsuario=false, bool dataCadastro=false, 
    bool dataAtualizacao=false, bool contato=false, bool contatoApenasNome=true, 
    bool endereco=false, bool enderecoApenasApelido=true,bool integracaoMercadopago =false, String filtroNome="", int offset = 0,
    DateTime filtroDataAtualizacao, FilterEhDeletado filterEhDeletado=FilterEhDeletado.naoDeletados}) async {
    
    String query;
    try {
      contatoApenasNome = completo ? false : contatoApenasNome;
      enderecoApenasApelido = completo ? false : enderecoApenasApelido;

      String queryContato = """
        contatos(where: {ehdeletado: {_eq: 0}}) {
          nome
          ${!contatoApenasNome ? "telefone1" : ""}
          ${!contatoApenasNome ? "telefone2" : ""}
          ${!contatoApenasNome ? "email" : ""}
          ehprincipal
          ${!contatoApenasNome ? "data_cadastro" : ""}
          ${!contatoApenasNome ? "data_atualizacao" : ""}
        }
      """;
      
      String queryEndereco = """
        enderecos(where: {ehdeletado: {_eq: 0}}) {
          apelido
          ${!enderecoApenasApelido ? "cep" : ""}
          ${!enderecoApenasApelido ? "logradouro" : ""}
          ${!enderecoApenasApelido ? "numero" : ""}
          ${!enderecoApenasApelido ? "complemento" : ""}
          ${!enderecoApenasApelido ? "bairro" : ""}
          ${!enderecoApenasApelido ? "municipio" : ""}
          ${!enderecoApenasApelido ? "estado" : ""}
          ${!enderecoApenasApelido ? "ibge_municipio" : ""}
          ${!enderecoApenasApelido ? "pais" : ""}
          ${!enderecoApenasApelido ? "data_cadastro" : ""}
          ${!enderecoApenasApelido ? "data_atualizacao" : ""}
        }
      """;

      String queryIntegracao = """
        integracao(where: {ehdeletado: {_eq: 0}}) {
          mercadopago
          ${!integracaoMercadopago ? "mercadopago_access_token" : ""}
          ${!integracaoMercadopago ? "mercadopago_id_loja" : ""}
          ${!integracaoMercadopago ? "mercadopago_user_id" : ""}
        }
      """;
      
      query = """ 
        {
          pessoa(limit: $queryLimit, offset: $offset, where: {
            ehdeletado: {${filterEhDeletado != FilterEhDeletado.todos ? filterEhDeletado == FilterEhDeletado.naoDeletados ? "_eq: 0" : "_eq: 1" : ""}},
            ehcliente: {${filterEhCliente ?'_eq: "1"': ''}},
            ehfornecedor: {${filterEhFornecedor ?'_eq: "1"': ''}},
            ehloja: {${filterEhLoja ?'_eq: "1"': ''}},
            ehvendedor: {${filterEhVendedor ?'_eq: "1"': ''}}, 
            ehusuario: {${filterEhUsuario ?'_eq: "1"': ''}}, 
            ehrevenda: {${filterEhRevenda ?'_eq: "1"': ''}},
            _or: [
              {fantasia_apelido: {${filtroNome != "" ? '_ilike:  '+'"$filtroNome%"' : ''}}}, 
              {razao_nome: {${filtroNome != "" ? '_ilike:  '+'"$filtroNome%"' : ''}}}
            ], 
            data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
            order_by: {${filtroDataAtualizacao == null ? 'fantasia_apelido: asc' : 'data_atualizacao: asc'}}) {
            ${completo || id ? "id" : ""}
            ${completo || idPessoaGrupo ? "id_pessoa_grupo" : ""}
            razao_nome
            fantasia_apelido
            ${completo || cnpjCpf ? "cnpj_cpf" : ""}
            ${completo || ieRg ? "ie_rg" : ""}
            ${completo || im ? "im" : ""}
            ${completo || ehFisica ? "ehfisica" : ""}
            ${completo || ehLoja ? "ehloja" : ""}
            ${completo || ehCliente ? "ehcliente" : ""}
            ${completo || ehFornecedor ? "ehfornecedor" : ""}
            ${completo || ehVendedor ? "ehvendedor" : ""}
            ${completo || ehRevenda ? "ehrevenda" : ""}
            ${completo || ehUsuario ? "ehusuario" : ""}
            ${completo || ehDeletado ? "ehdeletado" : ""}
            ${completo || dataCadastro ? "data_cadastro" : ""}
            ${completo || dataAtualizacao ? "data_atualizacao" : ""}
            ${completo || contato ? queryContato : ""}
            ${completo || endereco ? queryEndereco : ""}
          }
        }        
      """;

      print(query);
      var data = await _hasuraBloc.hasuraConnect.query(query);
      pessoaList = [];

      var contatoList = new List<Contato>();
      var enderecoList = new List<Endereco>();
      var integracaoList = new List<Integracao>();
      
      for(var i = 0; i < data['data']['pessoa'].length; i++){
        if (data['data']['pessoa'][i]['contatos'] != null) {
          data['data']['pessoa'][i]['contatos'].forEach((v) {
            contatoList.add(new Contato.fromJson(v));
          });
        }
        
        if (data['data']['pessoa'][i]['enderecos'] != null) {
          data['data']['pessoa'][i]['enderecos'].forEach((v) {
            enderecoList.add(new Endereco.fromJson(v));
          });
        }

        if (data['data']['pessoa'][i]['integracaos'] != null) {
          data['data']['pessoa'][i]['integracaos'].forEach((v) {
            integracaoList.add(new Integracao.fromJson(v));
          });
        }

        pessoaList.add(
          Pessoa(
            id: data['data']['pessoa'][i]['id'],
            idPessoaGrupo: data['data']['pessoa'][i]['id_pessoa_grupo'],
            razaoNome: data['data']['pessoa'][i]['razao_nome'],
            fantasiaApelido: data['data']['pessoa'][i]['fantasia_apelido'],
            cnpjCpf: data['data']['pessoa'][i]['cnpj_cpf'],
            ieRg: data['data']['pessoa'][i]['ie_rg'],
            im: data['data']['pessoa'][i]['im'],
            ehFisica: data['data']['pessoa'][i]['ehfisica'],
            ehCliente: data['data']['pessoa'][i]['ehcliente'],
            ehFornecedor: data['data']['pessoa'][i]['ehfornecedor'],
            ehVendedor: data['data']['pessoa'][i]['ehvendedor'],
            ehLoja: data['data']['pessoa'][i]['ehloja'],
            ehRevenda: data['data']['pessoa'][i]['ehrevenda'],
            ehUsuario: data['data']['pessoa'][i]['ehusuario'],
            ehDeletado: data['data']['pessoa'][i]['ehdeletado'],
            dataCadastro: data['data']['pessoa'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['pessoa'][i]['data_cadastro']) : null,
            dataAtualizacao: data['data']['pessoa'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['pessoa'][i]['data_atualizacao']) : null,
            contato: contatoList,
            endereco: enderecoList
          )       
        );
      }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoaDao> getAllFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoaDao",
        nomeFuncao: "getAllFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
    }   
    return pessoaList;
  }

  @override
  Future<IEntity> getById(int id) async {
    try {
      pessoa = await dao.getById(this, id);
      return pessoa;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoaDao> getById');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoaDao",
        nomeFuncao: "getById",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: "id: ${id.toString()}"
      );
      return null;
    }   
  }

  Future<IEntity> getByIdFromServer(int id) async {
    String query;
    try {
      query = """ 
        {
          pessoa(where: {id: {_eq: $id}}) {
            id
            id_pessoa_grupo
            razao_nome
            fantasia_apelido
            cnpj_cpf
            ie_rg
            im
            ehfisica
            ehcliente
            ehfornecedor
            ehvendedor
            ehloja
            ehrevenda
            ehusuario
            ehdeletado
            data_cadastro
            data_atualizacao
            contatos(where: {ehdeletado: {_eq: 0}}) {
              id
              id_pessoa
              nome
              telefone1
              telefone2
              email
              ehprincipal
              ehdeletado
              data_cadastro
              data_atualizacao
            }
            enderecos(where: {ehdeletado: {_eq: 0}}) {
              id
              id_pessoa
              apelido
              cep
              logradouro
              numero
              complemento
              bairro
              municipio
              estado
              ibge_municipio
              pais
              ehdeletado
              data_cadastro
              data_atualizacao
            }
            integracaos(where: {ehdeletado: {_eq:0}}){
              mercadopago_access_token
              mercadopago_id_loja
              mercadopago_user_id
            }
          }
        }
      """;

      var data = await _hasuraBloc.hasuraConnect.query(query);
      
      var contatoList = new List<Contato>();
      var enderecoList = new List<Endereco>();
      var integracaoList= new List<Integracao>();
      if (data['data']['pessoa'][0]['contatos'] != null) {
        data['data']['pessoa'][0]['contatos'].forEach((v) {
          contatoList.add(new Contato.fromJson(v));
        });
      }
      
      if (data['data']['pessoa'][0]['enderecos'] != null) {
        data['data']['pessoa'][0]['enderecos'].forEach((v) {
          enderecoList.add(new Endereco.fromJson(v));
        });
      }
      
      if (data['data']['pessoa'][0]['integracaos'] != null) {
        data['data']['pessoa'][0]['integracaos'].forEach((v) {
          integracaoList.add(new Integracao.fromJson(v));
        });
      }

      Pessoa _pessoa = Pessoa(
        id: data['data']['pessoa'][0]['id'],
        idPessoaGrupo: data['data']['pessoa'][0]['id_pessoa_grupo'],
        razaoNome: data['data']['pessoa'][0]['razao_nome'],
        fantasiaApelido: data['data']['pessoa'][0]['fantasia_apelido'],
        cnpjCpf: data['data']['pessoa'][0]['cnpj_cpf'],
        ieRg: data['data']['pessoa'][0]['ie_rg'],
        im: data['data']['pessoa'][0]['im'],
        ehFisica: data['data']['pessoa'][0]['ehfisica'],
        ehCliente: data['data']['pessoa'][0]['ehcliente'],
        ehFornecedor: data['data']['pessoa'][0]['ehfornecedor'],
        ehVendedor: data['data']['pessoa'][0]['ehvendedor'],
        ehUsuario: data['data']['pessoa'][0]['ehusuario'],
        ehLoja: data['data']['pessoa'][0]['ehloja'],
        ehRevenda: data['data']['pessoa'][0]['ehrevenda'],
        ehDeletado: data['data']['pessoa'][0]['ehdeletado'],
        dataCadastro: DateTime.parse(data['data']['pessoa'][0]['data_cadastro']),
        dataAtualizacao: DateTime.parse(data['data']['pessoa'][0]['data_atualizacao']),
        contato: contatoList,
        endereco: enderecoList,
        integracao: integracaoList
      );
      return _pessoa;
      } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoaDao> getByIdFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoaDao",
        nomeFuncao: "getByIdFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
      return null;
    }   
}

  Future<DateTime> getUltimaSincronizacao() async {
    try {
      List<Map> data = await dao.getRawQuery("select max(data_atualizacao) as data_atualizacao from pessoa where id_pessoa_grupo = ${_appGlobalBloc.loja.idPessoaGrupo} ");
      return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoaDao> getUltimaSincronizacao');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoaDao",
        nomeFuncao: "getUltimaSincronizacao",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      return DateTime.now();
    }   
  }

  @override
  Future<IEntity> insert() async {
    try {
      Database db = await dao.getDatabase();
      await db.transaction((txn) async {
        var batch = txn.batch();
        pessoa.id = await txn.insert(tableName, this.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
        for (Contato contato in pessoa.contato) {
          contato.idPessoa = pessoa.id;
          batch.insert('contato', contato.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
        }
        for (Endereco endereco in pessoa.endereco) {
          endereco.idPessoa = pessoa.id;
          batch.insert('endereco', endereco.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
        }
        var result = await batch.commit();
      });  
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoaDao> insert');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoaDao",
        nomeFuncao: "insert",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: this.pessoa.toString()
      );
    }   
    return this.pessoa;
  }

  Future<IEntity> saveOnServer() async {
    String _query;
    try {
      String _queryContato="";
      String _queryEndereco="";

      for (var i = 0; i < pessoa.contato.length; i++) {
        if (i == 0) {
          _queryContato = '{data: [';
        }    

        if ((pessoa.contato[i].id != null) && (pessoa.contato[i].id > 0)) {
          _queryContato = _queryContato + "{id: ${pessoa.contato[i].id},";
        } else {
          _queryContato = _queryContato + "{";
        }   
        
        _queryContato = _queryContato + 
          """
            nome: "${pessoa.contato[i].nome}",
            telefone1: "${pessoa.contato[i].telefone1}",
            telefone2: "${pessoa.contato[i].telefone2}",
            email: "${pessoa.contato[i].email}",
            ehprincipal: ${pessoa.contato[i].ehPrincipal},
            ehdeletado: ${pessoa.contato[i].ehDeletado},
            data_atualizacao: "now()" 
          },  
          """; 

        if (i == pessoa.contato.length-1){
          _queryContato = _queryContato + 
            """],
                on_conflict: {
                  constraint: contato_pkey, 
                  update_columns: [
                    nome,
                    telefone1,
                    telefone2,
                    email,
                    ehprincipal,
                    ehdeletado,
                    data_atualizacao
                  ]
                }  
              },
            """;
        }                  
      }

      for (var i = 0; i < pessoa.endereco.length; i++) {
        if (i == 0) {
          _queryEndereco = '{data: [';
        }    

        if ((pessoa.endereco[i].id != null) && (pessoa.endereco[i].id > 0)) {
          _queryEndereco = _queryEndereco + "{id: ${pessoa.endereco[i].id},";
        } else {
          _queryEndereco = _queryEndereco + "{";
        }   
        
        _queryEndereco = _queryEndereco + 
          """
            apelido: "${pessoa.endereco[i].apelido}",
            cep: "${pessoa.endereco[i].cep}",
            logradouro: "${pessoa.endereco[i].logradouro}",
            numero: "${pessoa.endereco[i].numero}",
            complemento: "${pessoa.endereco[i].complemento}",
            bairro: "${pessoa.endereco[i].bairro}",
            municipio: "${pessoa.endereco[i].municipio}",
            estado: "${pessoa.endereco[i].estado}",
            ibge_municipio: "${pessoa.endereco[i].ibgeMunicipio}",
            pais: "${pessoa.endereco[i].pais}",
            ehdeletado: ${pessoa.endereco[i].ehDeletado},
            data_atualizacao: "now()" 
          },  
          """; 

        if (i == pessoa.endereco.length-1){
          _queryEndereco = _queryEndereco + 
            """],
                on_conflict: {
                  constraint: endereco_pkey, 
                  update_columns: [
                    apelido,
                    cep,
                    logradouro,
                    numero,
                    complemento,
                    bairro,
                    municipio,
                    estado,
                    ibge_municipio,
                    pais,
                    ehdeletado,
                    data_atualizacao
                  ]
                }  
              },
            """;
        }                  
      } 

      _query = """ mutation savePessoa {
        update_sincronizacao(where: {}, _set: {data_atualizacao: "now()"}) {
          returning {
            data_atualizacao
          }
        }

        insert_pessoa(objects: {
      """;

      if ((pessoa.id != null) && (pessoa.id > 0)) {
        _query = _query + "id: ${pessoa.id},";
      }    

      _query = _query + """
          razao_nome: "${pessoa.razaoNome}", 
          fantasia_apelido: "${pessoa.fantasiaApelido}", 
          cnpj_cpf: "${pessoa.cnpjCpf}", 
          ie_rg: "${pessoa.ieRg}", 
          im: "${pessoa.im}", 
          ehfisica: ${pessoa.ehFisica}, 
          ehcliente: ${pessoa.ehCliente}, 
          ehfornecedor: ${pessoa.ehFornecedor}, 
          ehvendedor: ${pessoa.ehVendedor}, 
          ehusuario: ${pessoa.ehUsuario}, 
          ehloja: ${pessoa.ehLoja}, 
          ehrevenda: ${pessoa.ehRevenda}, 
          ehdeletado: ${pessoa.ehDeletado}, 
          data_atualizacao: "now()",""";
          _query = _queryContato!= "" ? _query + "contatos: $_queryContato" : _query; 
          _query = _queryEndereco!= "" ? _query + "enderecos: $_queryEndereco" : _query; 
          _query = _query + """
          }
          on_conflict: {
            constraint: pessoa_pkey, 
            update_columns: [
              razao_nome, 
              fantasia_apelido,
              cnpj_cpf,
              ie_rg,
              im,
              ehfisica,
              ehcliente,
              ehfornecedor,
              ehvendedor,
              ehusuario,
              ehloja
              ehrevenda,
              ehdeletado,
              data_atualizacao
            ]
          }) {
          returning {
            id
          }
        }
      }  
      """; 

      var data = await _hasuraBloc.hasuraConnect.mutation(_query);
      pessoa.id = data["data"]["insert_pessoa"]["returning"][0]["id"];
      return pessoa;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoaDao> saveOnServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoaDao",
        nomeFuncao: "saveOnServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: _query,
        object: pessoa.toString()
      );
      return null;
    }   
  }

  @override
  Future<IEntity> delete(int id) async {
    return pessoa;
  } 

  @override
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': pessoa.id,
        'id_pessoa_grupo': pessoa.idPessoaGrupo,
        'razao_nome': pessoa.razaoNome,
        'fantasia_apelido': pessoa.fantasiaApelido,
        'cnpj_cpf': pessoa.cnpjCpf,
        'ie_rg': pessoa.ieRg,
        'im': pessoa.im,
        'ehfisica': pessoa.ehFisica,
        'ehloja': pessoa.ehLoja,
        'ehcliente': pessoa.ehCliente,
        'ehfornecedor': pessoa.ehFornecedor,
        'ehvendedor': pessoa.ehVendedor,
        'ehusuario': pessoa.ehUsuario,
        'ehrevenda': pessoa.ehRevenda,
        'ehdeletado': pessoa.ehDeletado,
        'data_cadastro': pessoa.dataCadastro.toString(),
        'data_atualizacao': pessoa.dataAtualizacao.toString(),
      };
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoaDao> toMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoaDao",
        nomeFuncao: "toMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      return null;
    }   
  }
}
