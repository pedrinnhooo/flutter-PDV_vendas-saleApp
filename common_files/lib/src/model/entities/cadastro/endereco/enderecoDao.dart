import 'package:common_files/common_files.dart';

class EnderecoDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  final String tableName = "endereco";
  int filterId = 0;
  String filterText = "";
  int filterIdPessoa = 0;
  int filterEhDeletado = 0;

  Endereco endereco;
  List<Endereco> enderecoList;

  @override
  Dao dao;

  EnderecoDAO(this._hasuraBloc, this.endereco) {
    dao = Dao();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    this.endereco.id = map['id'];
    this.endereco.idPessoa = map['id_pessoa'];
    this.endereco.apelido = map['apelido'];
    this.endereco.cep = map['cep'];
    this.endereco.logradouro = map['logradouro'];
    this.endereco.numero = map['numero'];
    this.endereco.complemento = map['complemento'];
    this.endereco.bairro = map['bairro'];
    this.endereco.municipio = map['municipio'];
    this.endereco.estado = map['estado'];
    this.endereco.ibgeMunicipio = map['ibge_municipio'];
    this.endereco.pais = map['pais'];
    this.endereco.ehDeletado = map['ehdeletado'];
    this.endereco.dataCadastro = map['data_cadastro'];
    this.endereco.dataAtualizacao = map['data_atualizacao'];
    return this.endereco;
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
    enderecoList = List.generate(list.length, (i) {
      return Endereco(
        id: list[i]['id'],
        idPessoa: list[i]['id_pessoa'],
        apelido: list[i]['apelido'],
        cep: list[i]['cep'],
        logradouro: list[i]['logradouro'],
        numero: list[i]['numero'],
        complemento: list[i]['complemento'],
        bairro: list[i]['bairro'],
        municipio: list[i]['municipio'],
        estado: list[i]['estado'],
        ibgeMunicipio: list[i]['ibge_municipio'],
        pais: list[i]['pais'],
        ehDeletado: list[i]['ehdeletado'],
        dataCadastro: list[i]['data_cadastro'],
        dataAtualizacao: list[i]['data_atualizacao'],
      );
    });

    return enderecoList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool id=false, bool idPessoa=false,
    bool apelido=false, bool cep=false, bool logradouro=false, bool numero=false, 
    bool complemento=false, bool bairro=false, bool municipio=false, bool estado=false, 
    bool ibgeMunicipio=false, bool pais=false, bool ehDeletado=false,
    bool dataCadastro=false, bool dataAtualizacao=false, String filtroNome=""}) async {
    String query = """ 
      {
        contato(where: {
          ehdeletado: {_eq: $filterEhDeletado},
          apelido: {${filtroNome != "" ? '_ilike:  '+'"$filtroNome%"' : ''}}}, 
          order_by: {apelido: asc}
        ) {
          ${id ? "id" : ""}
          ${idPessoa ? "id_pessoa" : ""}
          apelido
          ${cep ? "cep" : ""}
          ${logradouro ? "logradouro" : ""}
          ${numero ? "numero" : ""}
          ${bairro ? "bairro" : ""}
          ${municipio ? "municipio" : ""}
          ${estado ? "estado" : ""}
          ${ibgeMunicipio ? "ibge_municipio" : ""}
          ${pais ? "pais" : ""}
          ${ehDeletado ? "ehdeletado" : ""}
          ${dataCadastro ? "data_cadastro" : ""}
          ${dataAtualizacao ? "data_atualizacao" : ""}
        }
      }        
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    enderecoList = [];

    for(var i = 0; i < data['data']['endereco'].length; i++){
      enderecoList.add(
        Endereco(
          id: data['data']['endereco'][i]['id'],
          idPessoa: data['endereco']['pessoa'][i]['id_pessoa'],
          apelido: data['data']['endereco'][i]['apelido'],
          cep: data['data']['endereco'][i]['cep'],
          logradouro: data['data']['endereco'][i]['logradouro'],
          numero: data['data']['endereco'][i]['numero'],
          bairro: data['data']['endereco'][i]['bairro'],
          municipio: data['data']['endereco'][i]['municipio'],
          estado: data['data']['endereco'][i]['estado'],
          ibgeMunicipio: data['data']['endereco'][i]['ibge_municipio'],
          pais: data['data']['endereco'][i]['pais'],
          ehDeletado: data['data']['endereco'][i]['ehdeletado'],
          dataCadastro: data['data']['endereco'][i]['data_cadastro'],
          dataAtualizacao: data['data']['endereco'][i]['data_atualizacao']
        )       
      );
    }
    return enderecoList;
  }  

  @override
  Future<IEntity> getById(int id) async {
    endereco = await dao.getById(this, id);
    return endereco;
  }

  Future<IEntity> getByIdFromServer(int id) async {
    String query = """ 
      {
        endereco(where: {id: {_eq: $id}}) {
          id
          id_pessoa
          apelido
          cep
          logradouro
          numero
          bairro
          municipio
          estado
          ibge_municipio
          pais
          ehdeletado
          data_cadastro
          data_atualizacao
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    Endereco _endereco = Endereco(
      id: data['data']['endereco'][0]['id'],
      idPessoa: data['data']['endereco'][0]['id_pessoa'],
      apelido: data['data']['endereco'][0]['apelido'],
      cep: data['data']['endereco'][0]['cep'],
      logradouro: data['data']['endereco'][0]['logradouro'],
      numero: data['data']['endereco'][0]['numero'],
      bairro: data['data']['endereco'][0]['bairro'],
      municipio: data['data']['endereco'][0]['municipio'],
      estado: data['data']['endereco'][0]['estado'],
      ibgeMunicipio: data['data']['endereco'][0]['ibge_municipio'],
      pais: data['data']['endereco'][0]['pais'],
      ehDeletado: data['data']['endereco'][0]['ehdeletado'],
      dataCadastro: DateTime.parse(data['data']['endereco'][0]['data_cadastro']),
      dataAtualizacao: DateTime.parse(data['data']['endereco'][0]['data_atualizacao']),
    );
    return _endereco;
  }

  @override
  Future<IEntity> insert() async {
    this.endereco.id = await dao.insert(this);
    return this.endereco;
  }


  Future<IEntity> saveOnServer() async {
    String _query = """ mutation saveEndereco {
        insert_endereco(objects: {""";

    if ((endereco.id != null) && (endereco.id > 0)) {
      _query = _query + "id: ${endereco.id},";
    }    

    _query = _query + """
        apelido: "${endereco.apelido}", 
        cep: "${endereco.cep}", 
        logradouro: "${endereco.logradouro}", 
        numero: "${endereco.numero}", 
        bairro: "${endereco.bairro}", 
        municipio: "${endereco.municipio}", 
        estado: "${endereco.estado}", 
        ibge_municipio: "${endereco.ibgeMunicipio}", 
        pais: "${endereco.pais}", 
        ehdeletado: "${endereco.ehDeletado}", 
        data_cadastro: "${endereco.dataCadastro}",
        data_atualizacao: "${endereco.dataAtualizacao}"},
        on_conflict: {
          constraint: endereco_pkey, 
          update_columns: [
            apelido, 
            cep,
            lograouro,
            numero,
            bairro,
            municipio,
            estado,
            ibge_municipio,
            pais,
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
      endereco.id = data["data"]["insert_endereco"]["returning"][0]["id"];
      return endereco;
    } catch (error) {
      return null;
    }  
  }  

  @override
  Future<IEntity> delete(int id) async {
    return endereco;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': endereco.id,
      'id_pessoa': endereco.idPessoa,
      'apelido': endereco.apelido,
      'cep': endereco.cep,
      'logradouro': endereco.logradouro,
      'numero': endereco.numero,
      'complemento': endereco.complemento,
      'bairro': endereco.bairro,
      'municipio': endereco.municipio,
      'estado': endereco.estado,
      'ibge_municipio': endereco.ibgeMunicipio,
      'pais': endereco.pais,
      'ehDeletado': endereco.ehDeletado,
      'data_cadastro': endereco.dataCadastro,
      'data_atualizacao': endereco.dataAtualizacao,
    };
  }
}
