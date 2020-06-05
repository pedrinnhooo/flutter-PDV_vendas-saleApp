import 'package:common_files/common_files.dart';

class ContatoDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  final String tableName = "contato";
  int filterId = 0;
  String filterText = "";
  int filterIdPessoa = 0;
  int filterEhDeletado = 0;

  Contato contato;
  List<Contato> contatoList;

  @override
  Dao dao;

  ContatoDAO(this._hasuraBloc, this.contato) {
    dao = Dao();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    this.contato.id = map['id'];
    this.contato.idPessoa = map['id_pessoa'];
    this.contato.nome = map['nome'];
    this.contato.telefone1 = map['telefone1'];
    this.contato.telefone2 = map['telefone2'];
    this.contato.email = map['email'];
    this.contato.ehPrincipal = map['ehprincipal'];
    this.contato.ehDeletado = map['ehdeletado'];
    this.contato.dataCadastro = map['data_cadastro'];
    this.contato.dataAtualizacao = map['data_atualizacao'];
    return this.contato;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where = "1 = 1 ";
    List<dynamic> args = [];
    if ((filterId > 0) || (filterText != "")) {
      if (filterId > 0) {
        where = where + "and (id = " + filterText + ")";
      }
      if (filterText != "") {
        where = where + "and (nome like '%" + filterText + "%')";
      }
    }

    where = filterIdPessoa > 0 ? where + " and id_pessoa = $filterIdPessoa" : where;

    List list = await dao.getList(this, where, args);
    contatoList = List.generate(list.length, (i) {
      return Contato(
        id: list[i]['id'],
        idPessoa: list[i]['id_pessoa'],
        nome: list[i]['nome'],
        telefone1: list[i]['telefone1'],
        telefone2: list[i]['telefone2'],
        email: list[i]['email'],
        ehPrincipal: list[i]['ehprincipal'],
        ehDeletado: list[i]['ehdeletado'],
        dataCadastro: list[i]['data_cadastro'],
        dataAtualizacao: list[i]['data_atualizacao'],
      );
    });

    return contatoList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool id=false, bool idPessoa=false,
    bool nome=false, bool telefone1=false, bool telefone2=false, bool email=false,
    bool ehPrincipal=false, bool ehDeletado=false, bool dataCadastro=false,
    bool dataAtualizacao=false, String filtroNome=""}) async {
    String query = """ 
      {
        contato(where: {
          ehdeletado: {_eq: $filterEhDeletado},
          nome: {${filtroNome != "" ? '_ilike:  '+'"$filtroNome%"' : ''}}}, 
          order_by: {nome: asc}
        ) {
          ${id ? "id" : ""}
          ${idPessoa ? "id_pessoa_grupo" : ""}
          nome
          ${telefone1 ? "telefone1" : ""}
          ${telefone2 ? "telefone2" : ""}
          ${email ? "email" : ""}
          ${ehPrincipal ? "ehprincipal" : ""}
          ${ehDeletado ? "ehdeletado" : ""}
          ${dataCadastro ? "data_cadastro" : ""}
          ${dataAtualizacao ? "data_atualizacao" : ""}
        }
      }        
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    contatoList = [];

    for(var i = 0; i < data['data']['contato'].length; i++){
      contatoList.add(
        Contato(
          id: data['data']['contato'][i]['id'],
          idPessoa: data['contato']['pessoa'][i]['id_pessoa'],
          nome: data['data']['contato'][i]['nome'],
          telefone1: data['data']['contato'][i]['telefone1'],
          telefone2: data['data']['contato'][i]['telefone2'],
          email: data['data']['contato'][i]['email'],
          ehPrincipal: data['data']['contato'][i]['ehprincipal'],
          ehDeletado: data['data']['contato'][i]['ehdeletado'],
          dataCadastro: data['data']['contato'][i]['data_cadastro'],
          dataAtualizacao: data['data']['contato'][i]['data_atualizacao']
        )       
      );
    }
    return contatoList;
  }

  @override
  Future<IEntity> getById(int id) async {
    contato = await dao.getById(this, id);
    return contato;
  }

  Future<IEntity> getByIdFromServer(int id) async {
    String query = """ 
      {
        contato(where: {id: {_eq: $id}}) {
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
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    Contato contato = Contato(
      id: data['data']['contato'][0]['id'],
      idPessoa: data['data']['contato'][0]['id_pessoa'],
      nome: data['data']['contato'][0]['nome'],
      telefone1: data['data']['contato'][0]['telefone1'],
      telefone2: data['data']['contato'][0]['telefone2'],
      email: data['data']['contato'][0]['email'],
      ehPrincipal: data['data']['contato'][0]['ehprincipal'],
      ehDeletado: data['data']['contato'][0]['ehdeletado'],
      dataCadastro: DateTime.parse(data['data']['contato'][0]['data_cadastro']),
      dataAtualizacao: DateTime.parse(data['data']['contato'][0]['data_atualizacao']),
    );
    return contato;
  }

  @override
  Future<IEntity> insert() async {
    this.contato.id = await dao.insert(this);
    return this.contato;
  }

  Future<IEntity> saveOnServer() async {
    String _query = """ mutation saveContato {
        insert_contato(objects: {""";

    if ((contato.id != null) && (contato.id > 0)) {
      _query = _query + "id: ${contato.id},";
    }    

    _query = _query + """
        nome: "${contato.nome}", 
        telefone1: "${contato.telefone1}", 
        telefone2: "${contato.telefone2}", 
        email: "${contato.email}", 
        ehprincipal: "${contato.ehPrincipal}", 
        ehdeletado: "${contato.ehDeletado}", 
        data_cadastro: "${contato.dataCadastro}",
        data_atualizacao: "${contato.dataAtualizacao}"},
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
        }) {
        returning {
          id
        }
      }
    }  
    """; 

    try {
      var data = await _hasuraBloc.hasuraConnect.mutation(_query);
      contato.id = data["data"]["insert_contato"]["returning"][0]["id"];
      return contato;
    } catch (error) {
      return null;
    }  
  }  

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': contato.id,
      'id_pessoa': contato.idPessoa,
      'nome': contato.nome,
      'telefone1': contato.telefone1,
      'telefone2': contato.telefone2,
      'email': contato.email,
      'ehprincipal': contato.ehPrincipal,
      'ehdeletado': contato.ehDeletado,
      'data_cadastro': contato.dataCadastro,
      'data_atualizacao': contato.dataAtualizacao,
    };
  }
}
