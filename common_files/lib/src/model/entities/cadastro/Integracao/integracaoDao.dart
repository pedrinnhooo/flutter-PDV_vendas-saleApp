import 'dart:convert';

import 'package:common_files/common_files.dart';



class IntegracaoDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "integracao";
  int filterId = 0;
  int filterIdPessoa = 0;
  String filterText = "";
  bool loadPessoa =false;
  bool loadEndereco = false;


  Integracao integracao;
  List<Integracao> integracaoList;
  Pessoa _pessoa;
  Endereco _endereco;

  @override
  Dao dao;

  IntegracaoDAO(this._hasuraBloc, this._appGlobalBloc, {this.integracao}){
    dao = Dao();
    _pessoa = Pessoa();
    _endereco = Endereco();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    this.integracao.id = map['id'];
    this.integracao.idPessoa = map['id_pessoa'];
    this.integracao.mercadopagoAcessToken = map['mercadopago_acess_token'];
    this.integracao.picpayAcessToken = map['picpay_acess_token'];
    this.integracao.mercadopagoUserId = map['mercadopago_user_id'];
    this.integracao.ehDeletado = map['ehdeletado'];
    this.integracao.dataCadastro = DateTime.parse(map['data_cadastro']);
    this.integracao.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
    this.integracao.mercadopagoIdLoja = map['mercadopago_id_loja'];

    return this.integracao;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where = "id_pessoa = ${_appGlobalBloc.loja.idPessoa}";
    List<dynamic> args = [];

    if (filterText != "") {
      where = where + "and (id like '%" + filterText + "%')";
    }
 
    List list = await dao.getList(this, where, args);
    integracaoList = List.generate(list.length, (i) {
      return Integracao(
        id: list[i]['id'],
        idPessoa: list[i]['id_pessoa'],
        mercadopagoAcessToken: list[i]['mercadopago_acess_token'],
        picpayAcessToken: list[i]['picpay_acess_token'],
        mercadopagoUserId: list[i]['mercadopago_user_id'],
        ehDeletado: list[i]['ehdeletado'],
        dataCadastro: list[i]['data_cadastro'] != null ? DateTime.parse(list[i]['data_cadastro']) : null,
        dataAtualizacao: list[i]['data_atualizacao'] != null ? DateTime.parse(list[i]['data_atualizacao']) : null,
        mercadopagoIdLoja: list[i]['mercadopago_id_loja'], 
      );
    });
   
    if (preLoad) {
      for (var integracao in integracaoList) {
        PessoaDAO pessoaDAO = PessoaDAO (_hasuraBloc, _appGlobalBloc, _pessoa);
        EnderecoDAO enderecoDAO = EnderecoDAO(_hasuraBloc, _endereco);
        
        if (loadEndereco) {
          enderecoDAO.filterIdPessoa = integracao.idPessoa;
          List<Endereco> enderecoList =
              await enderecoDAO.getAll();
          integracao.endereco = enderecoList;
        }
        enderecoDAO = null;
      }
    }
    return integracaoList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool completo=false, bool id=false, bool idPessoa=false,
    bool ehDeletado=false, bool dataCadastro=false, bool dataAtualizacao=false, String filtroAcessToken,
    DateTime filtroDataAtualizacao, FilterEhDeletado filterEhDeletado=FilterEhDeletado.naoDeletados, int offset = 0,
    String mercadopagoAcessToken, String picpayAcessToken, String mercadopagoUserId, bool endereco=false, bool enderecoApenasApelido=true, bool pessoa=false, bool pessoaApenasNome=true 
  }) async {
    
    pessoaApenasNome = completo ? false : pessoaApenasNome;
    enderecoApenasApelido = completo ? false : enderecoApenasApelido;

    String query = """ 
      {
        integracao(limit: $queryLimit, offset: $offset, where: {
          ehdeletado: {${filterEhDeletado != FilterEhDeletado.todos ? filterEhDeletado == FilterEhDeletado.naoDeletados ? '_eq:  0' : '_eq:  1' : ''}},
          data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
          order_by: {${filtroDataAtualizacao == null ? 'id: asc' : 'data_atualizacao: asc'}}) {
            ${id ? "id" : ""}
            ${idPessoa ? "id_pessoa" : ""}
            mercadopago_acess_token
            picpay_acess_token
            mercadopago_user_id
              pessoa {
              razao_nome
              enderecos {
                numero
                logradouro
                municipio
                estado
                complemento
              }
            }
            ${ehDeletado ? "ehdeletado" : ""}
            ${dataCadastro ? "data_cadastro" : ""}
            ${dataAtualizacao ? "data_atualizacao" : ""}
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    integracaoList = [];
    var enderecoList = new List<Endereco>();

      for(var i = 0; i < data['data']['integracao'].length; i++){


        if (data['data']['integracao'][0]['pessoa']['enderecos'][0] != null) {
         enderecoList.add(new Endereco.fromJson(data['data']['integracao'][0]['pessoa']['enderecos'][0]));
        }
      
  
        integracaoList.add(
          Integracao(
            id: data['data']['integracao'][i]['id'],
            idPessoa: data['data']['integracao'][i]['id_pessoa'],
            mercadopagoAcessToken: data['data']['integracao'][i]['mercadopago_acess_token'],
            picpayAcessToken: data['data']['integracao'][i]['picpay_acess_token'],
            mercadopagoUserId: data['data']['integracao'][i]['mercadopago_user_id'],
            ehDeletado: data['data']['integracao'][i]['ehdeletado'],
            dataCadastro: data['data']['integracao'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['mercadopago'][i]['data_cadastro']) : null,
            dataAtualizacao: data['data']['integracao'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['mercadopago'][i]['data_atualizacao']) : null,
            //idLoja: data['data']['integracao'][i]['mercadopago_id_loja'],
            pessoa: Pessoa(
              id: data['data']['integracao'][0]['pessoa']['id'],
              razaoNome: data['data']['integracao'][0]['pessoa']['razao_nome'],
            ),
            endereco: enderecoList
          )       
        );
      
      }
      return integracaoList;
    }
  
  @override
  Future<IEntity> getById(int id) async {
    return await dao.getById(this, id);
  }

  Future<IEntity> getByIdFromServer(int id) async {
    String query = """ 
      {
        integracao(where: {id_pessoa: {_eq: $id}}) {
          id
          id_pessoa
          mercadopago_acess_token
          picpay_acess_token
          mercadopago_user_id
          ehdeletado
          data_cadastro
          data_atualizacao
          mercadopago_id_loja
          pessoa {
            razao_nome
            enderecos {
              numero
              logradouro
              municipio
              estado
              complemento
            }
          }
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    var enderecoList = new List<Endereco>();

    
    if (data['data']['integracao'][0]['pessoa']['enderecos'][0] != null) {
      enderecoList.add(new Endereco.fromJson(data['data']['integracao'][0]['pessoa']['enderecos'][0]));      
      print(enderecoList.toString());
    }

    Integracao _integracao = Integracao(
      id: data['data']['integracao'][0]['id'],
      idPessoa: data['data']['integracao'][0]['id_pessoa'],
      mercadopagoAcessToken: data['data']['integracao'][0]['mercadopago_acess_token'],
      picpayAcessToken: data['data']['integracao'][0]['picpay_acess_token'],
      mercadopagoUserId: data['data']['integracao'][0]['mercadopago_user_id'],
      ehDeletado: data['data']['integracao'][0]['ehdeletado'],
      dataCadastro: DateTime.parse(data['data']['integracao'][0]['data_cadastro']),
      dataAtualizacao: DateTime.parse(data['data']['integracao'][0]['data_atualizacao']),
      //idLoja: data['data']['integracao'][0]['mercadopago_id_loja'],
      pessoa: Pessoa(
              id: data['data']['integracao'][0]['pessoa']['id'],
              razaoNome: data['data']['integracao'][0]['pessoa']['razao_nome'],
            ),
      endereco: enderecoList,
    );
    return _integracao;
  }

  Future<IEntity> getByIdPessoaFromServer(int idPessoa) async {
    String query = """ 
      {
        integracao(where: {id_pessoa: {_eq: $idPessoa}}) {
          id
          id_pessoa
          mercadopago_acess_token
          picpay_acess_token
          mercadopago_user_id
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);

    Integracao _integracao = Integracao(
      id: data['data']['integracao'][0]['id'],
      idPessoa: data['data']['integracao'][0]['id_pessoa'],
      mercadopagoAcessToken: data['data']['integracao'][0]['mercadopago_acess_token'],
      picpayAcessToken: data['data']['integracao'][0]['picpay_acess_token'],
      mercadopagoUserId: data['data']['integracao'][0]['mercadopago_user_id'],
      ehDeletado: data['data']['integracao'][0]['ehdeletado'],
    );
    return _integracao;
  }



  @override
  Future<IEntity> insert() async {
    this.integracao.id = await dao.insert(this);
    return this.integracao;
  }

  Future<IEntity> saveOnServer() async {
    String _query = """  mutation saveIntegracao {
      update_sincronizacao(where: {}, _set: {data_atualizacao: "now()"}) {
        returning {
          data_atualizacao
        }
      }

      insert_integracao(objects: {
    """;      

    if ((integracao.id != null) && (integracao.id > 0)) {
      _query = _query + "id: ${integracao.id},";
    }    

    _query = _query + """
        
        mercadopago_acess_token: "${integracao.mercadopagoAcessToken}", 
        picpay_acess_token: "${integracao.picpayAcessToken}",
        mercadopago_user_id: "${integracao.mercadopagoUserId}",
        mercadopago_id_loja: "${integracao.mercadopagoIdLoja}",
        ehdeletado: ${integracao.ehDeletado}, 
        data_atualizacao: "now()"},
        on_conflict: {
          constraint: integracao_pkey, 
          update_columns: [
            mercadopago_acess_token,
            picpay_acess_token,
            mercadopago_user_id, 
            mercadopago_id_loja,
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

    try {
      var data = await _hasuraBloc.hasuraConnect.mutation(_query);
      integracao.id = data["data"]["insert_integracao"]["returning"][0]["id"];
      return integracao;
    } catch (error) {
      return null;
    }  
  }

  @override
  Future<IEntity> delete(int id) async {
    return this.integracao;
  }  

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': this.integracao.id,
      'id_pessoa_grupo': this.integracao.idPessoa,
      'mercadopago_acess_token': this.integracao.mercadopagoAcessToken,
      'picpay_acess_token': this.integracao.picpayAcessToken,
      'mercadopago_user_id': this.integracao.mercadopagoUserId,
      'ehdeletado': this.integracao.ehDeletado,
      'data_cadastro': this.integracao.dataCadastro.toString(),
      'data_atualizacao': this.integracao.dataAtualizacao.toString(),
      'mercadopago_id_loja': this.integracao.mercadopagoIdLoja,
    };
  }

  String entityToJson() {
    final dyn = toMap();
    return json.encode(dyn);
  }

  IEntity entityFromJson(String str) {
    final jsonData = json.decode(str);
    return fromMap(jsonData);
  }

    Future<IEntity> getByIdFromServerMercadopado(int idPessoa) async {
    String query = """ 
      {
        integracao(where: {id_pessoa: {_eq: $idPessoa}}) {
          id
          id_pessoa
          mercadopago_acess_token
          picpay_acess_token
          mercadopago_user_id
          ehdeletado
          data_cadastro
          data_atualizacao
          mercadopago_id_loja
          pessoa {
            razao_nome
            enderecos {
              numero
              logradouro
              municipio
              estado
              complemento
            }
          }
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    var enderecoList = new List<Endereco>();

    
    if (data['data']['integracao'][0]['pessoa']['enderecos'][0] != null) {
      enderecoList.add(new Endereco.fromJson(data['data']['integracao'][0]['pessoa']['enderecos'][0]));      
    print(enderecoList.toString());
    }

    Integracao _integracao = Integracao(
      id: data['data']['integracao'][0]['id'],
      idPessoa: data['data']['integracao'][0]['id_pessoa'],
      mercadopagoAcessToken: data['data']['integracao'][0]['mercadopago_acess_token'],
      picpayAcessToken: data['data']['integracao'][0]['picpay_acess_token'],
      mercadopagoUserId: data['data']['integracao'][0]['mercadopago_user_id'],
      ehDeletado: data['data']['integracao'][0]['ehdeletado'],
      dataCadastro: DateTime.parse(data['data']['integracao'][0]['data_cadastro']),
      dataAtualizacao: DateTime.parse(data['data']['integracao'][0]['data_atualizacao']),
      //idLoja: data['data']['integracao'][0]['mercadopago_id_loja'],
      pessoa: Pessoa(
              id: data['data']['integracao'][0]['pessoa']['id'],
              razaoNome: data['data']['integracao'][0]['pessoa']['razao_nome'],
            ),
      endereco: enderecoList,
    );
    return _integracao;
  }
}
