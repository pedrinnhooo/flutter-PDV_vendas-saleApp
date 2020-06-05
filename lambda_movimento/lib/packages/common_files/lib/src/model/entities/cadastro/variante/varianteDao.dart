import 'package:common_files/src/bloc/hasura_bloc.dart';
import 'package:common_files/src/model/dao/dao.dart';
import 'package:common_files/src/model/entities/cadastro/variante/variante.dart';
import 'package:common_files/src/model/entities/interfaces.dart';

class VarianteDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  final String tableName = "variante";
  int filter_id;
  String filter_text;

  Variante variante;
  List<Variante> varianteList;

  @override
  Dao dao;

  VarianteDAO(this._hasuraBloc, {this.variante}) {
    dao = Dao();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    this.variante.id = map['id'];
    this.variante.idPessoaGrupo = map['id_pessoa_grupo'];
    this.variante.nome = map['nome'];
    this.variante.nomeAvatar = map['nome_avatar'];
    this.variante.possuiImagem = map['possui_imagem'];
    this.variante.corIcone = map['coricone'];
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
        possuiImagem: list[i]['possui_imagem'],
        corIcone: list[i]['coricone'],
        ehDeletado: list[i]['ehdeletado'],
        dataCadastro: list[i]['data_cadastro'],
        dataAtualizacao: list[i]['data_atualizacao'],
      );
    });

    return varianteList;
  }

  Future<List<Variante>> getAllFromServer({bool preLoad=false, bool id=false, bool idPessoaGrupo=false, 
    bool ehDeletado=false, bool dataCadastro=false, bool dataAtualizacao=false, bool possuiImagem=false, bool iconeCor=false,  
    String filtroNome="",}) async {
      String query = """ 
      {
        variante(where: {
         nome: {${filtroNome != "" ? '_ilike:  '+'"$filtroNome%"' : ''}}},
         order_by: {nome: asc}) {
          ${id ? "id" : ""}
          ${idPessoaGrupo ? "id_pessoa_grupo" : ""}
          nome
          nome_avatar
          ${possuiImagem ? "possuiImagem" : ""}
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
            idPessoaGrupo: data['data']['variante'][i]['id_pessoa'],
            nome: data['data']['variante'][i]['nome'],
            nomeAvatar: data['data']['variante'][i]['nome_avatar'],
            possuiImagem: data['data']['variante'][i]['possui_imagem'],
            corIcone: data['data']['variante'][i]['iconecor'],
            ehDeletado: data['data']['variante'][i]['ehdeletado'],
            dataCadastro: DateTime.parse(data['data']['variante'][i]['data_cadastro']),
            dataAtualizacao: DateTime.parse(data['data']['variante'][i]['data_atualizacao'])
          )       
        );
      }
      return varianteList;
  }

  Future<IEntity> getByIdFromServer(int id) async {
    String query = """ 
      {
        variante(where: {id: {_eq: $id}}) {
          id
          id_pessoa_grupo
          nome
          nome_avatar
          possui_imagem
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
      possuiImagem: data['data']['variante'][0]['possui_imagem'],
      ehDeletado: data['data']['variante'][0]['ehdeletado'],
      corIcone: data['data']['variante'][0]['iconecor'],
      dataCadastro: DateTime.parse(data['data']['variante'][0]['data_cadastro']),
      dataAtualizacao: DateTime.parse(data['data']['variante'][0]['data_atualizacao'])
    );
    return _variante;
  }

  Future<IEntity> saveOnServer() async {
    String _query = """ mutation saveVariante {
        insert_variante(objects: {""";

    if ((variante.id != null) && (variante.id > 0)) {
      _query = _query + "id: ${variante.id},";
    }    

    _query = _query + """
        nome: "${variante.nome}", 
        nome_avatar: "${variante.nomeAvatar}"
        ehdeletado: ${variante.ehDeletado}, 
        possui_imagem: "${variante.possuiImagem}",
        iconecor: "${variante.corIcone}",
        data_cadastro: "${variante.dataCadastro}",
        data_atualizacao: "${variante.dataAtualizacao}"},
        on_conflict: {
          constraint: variante_pkey, 
          update_columns: [
            nome, 
            nome_avatar
            possui_imagem, 
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
  Future<IEntity> getById(int id) async {
    variante = await dao.getById(this, id);
    return variante;
  }

  @override
  Future<IEntity> insert() async {
    this.variante.id = await dao.insert(this);
    return this.variante;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': variante.id,
      'id_pessoa_grupo': variante.idPessoaGrupo,
      'nome': variante.nome,
      'nome_avatar': variante.nomeAvatar,
      'possui_imagem': variante.possuiImagem,
      'coricone': variante.corIcone,
      'ehdeletado' : variante.ehDeletado,
      'data_cadastro': variante.dataCadastro,
      'data_atualizacao': variante.dataAtualizacao,
    };
  }
}
