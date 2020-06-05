import 'package:common_files/common_files.dart';

class VarianteDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "variante";
  int filter_id;
  String filter_text;

  Variante variante;
  List<Variante> varianteList;

  @override
  Dao dao;

  VarianteDAO(this._hasuraBloc, this._appGlobalBloc, {this.variante}) {
    dao = Dao();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    this.variante.id = map['id'];
    this.variante.idPessoaGrupo = map['id_pessoa_grupo'];
    this.variante.nome = map['nome'];
    this.variante.nomeAvatar = map['nome_avatar'];
    this.variante.temImagem = map['tem_imagem'];
    this.variante.iconecor = map['iconecor'];
    this.variante.ehDeletado = map['ehdeletado'];
    //this.variante.dataCadastro= DateTime.tryParse(map['data_cadastro']);
    //this.variante.dataAtualizacao = DateTime.tryParse(map['data_atualizacao']);
    return this.variante;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where = "";
    List<dynamic> args = [];
    if ((filter_id > 0) || (filter_text != "")) {
      where = "1 = 1 ";
      if (filter_id > 0) {
        where = where + "and (id = " + filter_text + ")";
      }
      if (filter_text != "") {
        where = where + "and (nome like '%" + filter_text + "%')";
      }
    }

    List list = await dao.getList(this, where, args);
    varianteList = List.generate(list.length, (i) {
      return Variante(
        id: list[i]['id'],
        idPessoaGrupo: list[i]['id_pessoa_grupo'],
        nome: list[i]['nome'],
        nomeAvatar: list[i]['nome_avatar'],
        temImagem: list[i]['tem_imagem'],
        iconecor: list[i]['iconecor'],
        ehDeletado: list[i]['ehdeletado'],
        dataCadastro: list[i]['data_cadastro'],
        dataAtualizacao: list[i]['data_atualizacao'],
      );
    });

    return varianteList;
  }

  Future<List<Variante>> getAllFromServer({bool preLoad=false, bool id=false, bool idPessoaGrupo=false, 
    bool ehDeletado=false, bool dataCadastro=false, bool dataAtualizacao=false, bool temImagem=false, bool iconeCor=false,  
    String filtroNome="", int offset = 0, DateTime filtroDataAtualizacao, FilterEhDeletado filterEhDeletado=FilterEhDeletado.naoDeletados}) async {
      String query = """ 
      {
        variante(limit: $queryLimit, offset: $offset, where: {
          ehdeletado: {${filterEhDeletado != FilterEhDeletado.todos ? filterEhDeletado == FilterEhDeletado.naoDeletados ? "_eq: 0" : "_eq: 1" : ""}},
          nome: {${filtroNome != "" ? '_ilike:  '+'"$filtroNome%"' : ''}},
          data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
          order_by: {${filtroDataAtualizacao == null ? 'nome: asc' : 'data_atualizacao: asc'}}) {
          ${id ? "id" : ""}
          ${idPessoaGrupo ? "id_pessoa_grupo" : ""}
          nome
          nome_avatar
          ${temImagem ? "tem_imagem" : ""}
          ${iconeCor ? "iconecor" : ""}
          ${ehDeletado ? "ehdeletado" : ""}
          ${dataCadastro ? "data_cadastro" : ""}
          ${dataAtualizacao ? "data_atualizacao" : ""}
        }
      }""";

      var data = await _hasuraBloc.hasuraConnect.query(query);
      varianteList = [];

      for(var i = 0; i < data['data']['variante'].length; i++){
        varianteList.add(
          Variante(
            id: data['data']['variante'][i]['id'],
            idPessoaGrupo: data['data']['variante'][i]['id_pessoa_grupo'],
            nome: data['data']['variante'][i]['nome'],
            nomeAvatar: data['data']['variante'][i]['nome_avatar'],
            temImagem: data['data']['variante'][i]['tem_imagem'],
            iconecor: data['data']['variante'][i]['iconecor'],
            ehDeletado: data['data']['variante'][i]['ehdeletado'],
            dataCadastro: data['data']['variante'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['variante'][i]['data_cadastro']) : null,
            dataAtualizacao: data['data']['variante'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['variante'][i]['data_atualizacao']): null
          )       
        );
      }
      return varianteList;
  }

  @override
  Future<IEntity> getById(int id) async {
    variante = await dao.getById(this, id);
    return variante;
  }

  Future<IEntity> getByIdFromServer(int id) async {
    String query = """ 
      {
        variante(where: {id: {_eq: $id}}) {
          id
          id_pessoa_grupo
          nome
          nome_avatar
          tem_imagem
          iconecor
          ehdeletado
          data_atualizacao
          data_cadastro
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    Variante _variante = Variante(
      id: data['data']['variante'][0]['id'],
      idPessoaGrupo: data['data']['variante'][0]['id_pessoa_grupo'],
      nome: data['data']['variante'][0]['nome'],
      nomeAvatar: data['data']['variante'][0]['nome_avatar'],
      temImagem: data['data']['variante'][0]['tem_imagem'],
      ehDeletado: data['data']['variante'][0]['ehdeletado'],
      iconecor: data['data']['variante'][0]['iconecor'],
      dataCadastro: DateTime.parse(data['data']['variante'][0]['data_cadastro']),
      dataAtualizacao: DateTime.parse(data['data']['variante'][0]['data_atualizacao'])
    );
    return _variante;
  }

  Future<DateTime> getUltimaSincronizacao() async {
    List<Map> data = await dao.getRawQuery("select max(data_atualizacao) as data_atualizacao from variante where id_pessoa_grupo = ${_appGlobalBloc.loja.idPessoaGrupo} ");
    return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
  }

  @override
  Future<IEntity> insert() async {
    this.variante.id = await dao.insert(this);
    return this.variante;
  }

  Future<IEntity> saveOnServer() async {
    String _query = """ mutation saveVariante {
      update_sincronizacao(where: {}, _set: {data_atualizacao: "now()"}) {
        returning {
          data_atualizacao
        }
      }

      insert_variante(objects: {
    """;

    if ((variante.id != null) && (variante.id > 0)) {
      _query = _query + "id: ${variante.id},";
    }    

    _query = _query + """
        nome: "${variante.nome}", 
        nome_avatar: "${variante.nomeAvatar}"
        ehdeletado: ${variante.ehDeletado}, 
        tem_imagem: "${variante.temImagem}",
        iconecor: "${variante.iconecor}",
        data_atualizacao: "now()"},
        on_conflict: {
          constraint: variante_pkey, 
          update_columns: [
            nome, 
            nome_avatar
            tem_imagem, 
            iconecor,
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
      variante.id = data["data"]["insert_variante"]["returning"][0]["id"];
      return variante;
    } catch (error) {
      return null;
    }  
  }

  @override
  Future<IEntity> delete(int id) async {
    return variante;
  }  

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': variante.id,
      'id_pessoa_grupo': variante.idPessoaGrupo,
      'nome': variante.nome,
      'nome_avatar': variante.nomeAvatar,
      'tem_imagem': variante.temImagem,
      'iconecor': variante.iconecor,
      'ehdeletado' : variante.ehDeletado,
      'data_cadastro': variante.dataCadastro.toString(),
      'data_atualizacao': variante.dataAtualizacao.toString(),
    };
  }
}
