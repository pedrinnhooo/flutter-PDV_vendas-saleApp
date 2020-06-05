import 'dart:convert';

import 'package:common_files/common_files.dart';
import 'package:common_files/src/model/entities/configuracao/configuracao_geral/configuracao_geral.dart';

class ConfiguracaoGeralDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "configuracao_geral";
  int filterId = 0;
  String filterText = "";

  ConfiguracaoGeral configuracaoGeral;
  List<ConfiguracaoGeral> configuracaoGeralList;

  @override
  Dao dao;

  ConfiguracaoGeralDAO(this._hasuraBloc, this.configuracaoGeral, this._appGlobalBloc) {
    dao = Dao();
    //dao.createDb();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    try {
      this.configuracaoGeral.id = map['id'];
      this.configuracaoGeral.idPessoaGrupo = map['id_pessoa_grupo'];
      this.configuracaoGeral.temServico = map['tem_servico'];
      this.configuracaoGeral.temServico = map['ehservico_default'];
      this.configuracaoGeral.ehMenuClassico = map['ehmenu_classico'];
      this.configuracaoGeral.dataCadastro = DateTime.parse(map['data_cadastro']);
      this.configuracaoGeral.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_geralDao> fromMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_geralDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
    return this.configuracaoGeral;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where;
    try {
      where = "id_pessoa_grupo = ${_appGlobalBloc.loja.idPessoaGrupo} ";
      List<dynamic> args = [];

      if (filterText != "") {
        where = where + "and (nome like '%" + filterText + "%') ";
      }

      List list = await dao.getList(this, where, args);
      configuracaoGeralList = List.generate(list.length, (i) {
        return ConfiguracaoGeral(
          id: list[i]['id'],
          idPessoaGrupo: list[i]['id_pessoa_grupo'],
          temServico: list[i]['tem_servico'],
          ehServicoDefault: list[i]['ehservico_default'],
          ehMenuClassico: list[i]['ehmenu_classico'],
          dataCadastro: list[i]['data_cadastro'] != null ? DateTime.parse(list[i]['data_cadastro']) : null,
          dataAtualizacao: list[i]['data_atualizacao'] != null ? DateTime.parse(list[i]['data_atualizacao']) : null,
        );
      });
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_geralDao> getAll');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_geralDao",
        nomeFuncao: "getAll",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: where
      );
    }   
    return configuracaoGeralList;
  }

  Future<List> getAllFromServer({bool id=false, bool idPessoaGrupo=false,
    bool temServico=true, bool ehMenuClassico=false, bool ehServicoDefault=false, bool dataCadastro=false, bool dataAtualizacao=false, 
    DateTime filtroDataAtualizacao}) async {
    String query;
    try {
      query = """ 
        {
          configuracao_geral(where: {
            data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
            order_by: {data_atualizacao: asc}) {
              ${id ? "id" : ""}
              ${idPessoaGrupo ? "id_pessoa_grupo" : ""}
              ${temServico ? "tem_servico" : ""}
              ${ehServicoDefault ? "ehservico_default" : ""}
              ${ehMenuClassico ? "ehmenu_classico" : ""}
              ${dataCadastro ? "data_cadastro" : ""}
              ${dataAtualizacao ? "data_atualizacao" : ""}
          }
        }
      """;

      var data = await _hasuraBloc.hasuraConnect.query(query);
      configuracaoGeralList = [];

      for(var i = 0; i < data['data']['configuracao_geral'].length; i++){
        configuracaoGeralList.add(
          ConfiguracaoGeral(
            id: data['data']['configuracao_geral'][i]['id'],
            idPessoaGrupo: data['data']['configuracao_geral'][i]['id_pessoa_grupo'],
            temServico: data['data']['configuracao_geral'][i]['tem_servico'],
            ehServicoDefault: data['data']['configuracao_geral'][i]['ehservico_default'],
            ehMenuClassico: data['data']['configuracao_geral'][i]['ehmenu_classico'],
            dataCadastro: data['data']['configuracao_geral'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['configuracao_geral'][i]['data_cadastro']) : null,
            dataAtualizacao: data['data']['configuracao_geral'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['configuracao_geral'][i]['data_atualizacao']) : null
          )       
        );
      }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_geralDao> getAllFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_geralDao",
        nomeFuncao: "getAllFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
    }   
    return configuracaoGeralList;
  }
  
  @override
  Future<IEntity> getById(int id) async {
    try {
      return await dao.getById(this, id);
     } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_geralDao> getById');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_geralDao",
        nomeFuncao: "getById",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: "id: ${id.toString()}"        
      );
    }   
 }

  Future<IEntity> getByIdFromServer(int id) async {
    // String query = """ 
    //   {
    //     categoria(where: {id: {_eq: $id}}) {
    //       id
    //       id_pessoa_grupo
    //       nome
    //       ehdeletado
    //       data_cadastro
    //       data_atualizacao
    //     }
    //   }
    // """;

    // var data = await _hasuraBloc.hasuraConnect.query(query);
    // Categoria _categoria = Categoria(
    //   id: data['data']['categoria'][0]['id'],
    //   idPessoaGrupo: data['data']['categoria'][0]['id_pessoa_grupo'],
    //   nome: data['data']['categoria'][0]['nome'],
    //   ehDeletado: data['data']['categoria'][0]['ehdeletado'],
    //   dataCadastro: DateTime.parse(data['data']['categoria'][0]['data_cadastro']),
    //   dataAtualizacao: DateTime.parse(data['data']['categoria'][0]['data_atualizacao'])
    // );
     return configuracaoGeral;
  }

  Future<DateTime> getUltimaSincronizacao() async {
    try {
      List<Map> data = await dao.getRawQuery("select max(data_atualizacao) as data_atualizacao from configuracao_geral where id_pessoa_grupo = ${_appGlobalBloc.loja.idPessoaGrupo} ");
      return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_geralDao> fromMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_geralDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      return DateTime.now();
    }   
  }

  @override
  Future<IEntity> insert() async {
    try {
      this.configuracaoGeral.id = await dao.insert(this);
      return this.configuracaoGeral;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_geralDao> insert');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_geralDao",
        nomeFuncao: "insert",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: this.configuracaoGeral.toString()
      );
      return null;
    }   
  }

  Future<IEntity> saveOnServer() async {
    String _query;
    try {
      _query = """  mutation saveConfiguracaoGeral {
        update_sincronizacao(where: {}, _set: {data_atualizacao: "now()"}) {
          returning {
            data_atualizacao
          }
        }

        insert_configuracao_geral(objects: {
      """;      

      if ((configuracaoGeral.id != null) && (configuracaoGeral.id > 0)) {
        _query = _query + "id: ${configuracaoGeral.id},";
      }    

      _query = _query + """
          tem_servico: ${configuracaoGeral.temServico}, 
          ehservico_default: ${configuracaoGeral.ehServicoDefault},
          ehmenu_classico: ${configuracaoGeral.ehMenuClassico},
          data_atualizacao: "now()"},
          on_conflict: {
            constraint: configuracao_geral_pkey, 
            update_columns: [
              ehservico_default,
              tem_servico,
              ehmenu_classico,
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
      configuracaoGeral.id = data["data"]["configuracao_geral"]["returning"][0]["id"];
      return configuracaoGeral;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_geralDao> saveOnServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_geralDao",
        nomeFuncao: "saveOnServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: _query,
        object: configuracaoGeral.toString()
      );
      return null;
    }   
  }

  @override
  Future<IEntity> delete(int id) async {
    return configuracaoGeral;
  }  

  @override
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': this.configuracaoGeral.id,
        'id_pessoa_grupo': this.configuracaoGeral.idPessoaGrupo,
        'tem_servico': this.configuracaoGeral.temServico,
        'ehservico_default': this.configuracaoGeral.ehServicoDefault,
        'ehmenu_classico': this.configuracaoGeral.ehMenuClassico,
        'data_cadastro': this.configuracaoGeral.dataCadastro.toString(),
        'data_atualizacao': this.configuracaoGeral.dataAtualizacao.toString(),
      };
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_geralDao> toMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_geralDao",
        nomeFuncao: "toMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      return null;
    }   
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
