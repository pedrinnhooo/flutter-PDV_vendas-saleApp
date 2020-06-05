import 'dart:convert';
import 'package:common_files/common_files.dart';
import 'package:common_files/src/model/entities/configuracao/cupom_layout/cupom_layout.dart';

class CupomLayoutDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "cupom_layout";
  int filterId = 0;
  String filterText = "";
  CupomLayout _cupomLayout;
  List<CupomLayout> _cupomLayoutList;

  @override
  Dao dao;

  CupomLayoutDAO(this._cupomLayout, this._hasuraBloc, this._appGlobalBloc) {
    dao = Dao();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    this._cupomLayout.id = map['id'];
    this._cupomLayout.nome = map['nome'];
    this._cupomLayout.layout = map['layout'];
    this._cupomLayout.tamanhoPapel = map['tamanho_papel'];
    this._cupomLayout.dataCadastro = DateTime.parse(map['data_cadastro']);
    this._cupomLayout.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
    return this._cupomLayout;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where = "1 = 1 ";
    //"id_pessoa = ${_appGlobalBloc.loja.idPessoa} ";
    List<dynamic> args = [];

    if (filterText != "") {
      where = where + "and (nome like '%" + filterText + "%') ";
    }

    List list = await dao.getList(this, where, args);
    _cupomLayoutList = List.generate(list.length, (i) {
      return CupomLayout(
        id: list[i]['id'],
        nome: list[i]['nome'],
        layout: list[i]['layout'],
        tamanhoPapel: list[i]['tamanho_papel'],
        dataCadastro: list[i]['data_cadastro'] != null ? DateTime.parse(list[i]['data_cadastro']) : null,
        dataAtualizacao: list[i]['data_atualizacao'] != null ? DateTime.parse(list[i]['data_atualizacao']) : null,
      );
    });
    return _cupomLayoutList;
  }

  Future<List> getAllFromServer({bool id=false,
    bool layout=false, bool tamanhoPapel=false,
    bool dataCadastro=false, bool dataAtualizacao=false, 
    DateTime filtroDataAtualizacao}) async {
    String query = """ 
    {
      cupom_layout(where: {
        data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
        order_by: {data_atualizacao: asc}) {
          ${id ? "id" : ""}
          nome
          ${layout ? "layout" : ""}
          ${tamanhoPapel ? "tamanho_papel" : ""}
          ${dataCadastro ? "data_cadastro" : ""}
          ${dataAtualizacao ? "data_atualizacao" : ""}
      } 
    }""";
    
    var data = await _hasuraBloc.hasuraConnect.query(query);
    _cupomLayoutList = [];

      for(var i = 0; i < data['data']['cupom_layout'].length; i++){
        _cupomLayoutList.add(
          CupomLayout(
            id: data['data']['cupom_layout'][i]['id'],
            nome: data['data']['cupom_layout'][i]['nome'],
            layout: data['data']['cupom_layout'][i]['layout'],
            tamanhoPapel: data['data']['cupom_layout'][i]['tamanho_papel'],
            dataCadastro: data['data']['cupom_layout'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['cupom_layout'][i]['data_cadastro']) : null,
            dataAtualizacao: data['data']['cupom_layout'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['cupom_layout'][i]['data_atualizacao']) : null
          )       
        );
      }
      return _cupomLayoutList;
    }
  
  @override
  Future<IEntity> getById(int id) async {
    return await dao.getById(this, id);
  }

  Future<IEntity> getByIdFromServer(int id) async {
    String query = """ query cupom_layout {
      cupom_layout(where: {id: {_eq: $id}}) {
        id
        layout
        nome
        tamanho_papel
        data_cadastro
        data_atualizacao
      }
    }""";

    print(query);

    var data = await _hasuraBloc.hasuraConnect.query(query);
    CupomLayout _cupomLayout = CupomLayout(
        id: data['data']['cupom_layout'][0]['id'],
        nome: data['data']['cupom_layout'][0]['nome'],
        layout: data['data']['cupom_layout'][0]['layout'],
        tamanhoPapel: data['data']['cupom_layout'][0]['tamanho_papel'],
        dataCadastro: data['data']['cupom_layout'][0]['data_cadastro'] != null ? DateTime.parse(data['data']['cupom_layout'][0]['data_cadastro']) : null,
        dataAtualizacao: data['data']['cupom_layout'][0]['data_atualizacao'] != null ? DateTime.parse(data['data']['cupom_layout'][0]['data_atualizacao']) : null
      );
     return _cupomLayout;
  }

  Future<DateTime> getUltimaSincronizacao() async {
    List<Map> data = await dao.getRawQuery("select max(data_atualizacao) as data_atualizacao from configuracao_cadastro where id_pessoa = ${_appGlobalBloc.loja.idPessoa} ");
    return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
  }

  @override
  Future<IEntity> insert() async {
    this._cupomLayout.id = await dao.insert(this);
    return this._cupomLayout;
  }

  Future<IEntity> saveOnServer() async {
    String _query = """  mutation saveConfiguracaoImpressora {
      update_sincronizacao(where: {}, _set: {data_atualizacao: "now()"}) {
        returning {
          data_atualizacao
        }
      }

      insert_cupom_layout(objects: {
    """;      

    if ((_cupomLayout.id != null) && (_cupomLayout.id > 0)) {
      _query = _query + "id: ${_cupomLayout.id},";
    }    

    _query = _query + """ 
        nome: "${_cupomLayout.nome}",
        layout: "${_cupomLayout.layout}",
        tamanho_papel: "${_cupomLayout.tamanhoPapel}",
        data_cadastro: "now()",
        data_atualizacao: "now()"},
        on_conflict: {
          constraint: cupom_layout_pkey, 
          update_columns: [
            nome,
            layout,
            tamanho_papel,
            data_atualizacao
          ]
        }) {
        returning {
          id
        }
      }
    }  
    """; 

    print(_query);

    try {
      var data = await _hasuraBloc.hasuraConnect.mutation(_query);
      _cupomLayout.id = data["data"]["cupom_layout"]["returning"][0]["id"];
      return _cupomLayout;
    } catch (error) {
      return null;
    }  
  }

  @override
  Future<IEntity> delete(int id) async {
    return _cupomLayout;
  }  

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': this._cupomLayout.id,
      'nome': this._cupomLayout.nome,
      'layout': this._cupomLayout.layout,
      'tamanho_papel': this._cupomLayout.tamanhoPapel,
      'data_cadastro': this._cupomLayout.dataCadastro.toString(),
      'data_atualizacao': this._cupomLayout.dataAtualizacao.toString(),
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
}
