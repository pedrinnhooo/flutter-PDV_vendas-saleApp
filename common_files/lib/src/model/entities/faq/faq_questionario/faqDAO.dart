import 'dart:convert';

import 'package:common_files/common_files.dart';

class FaqDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "faq_categoria";
  int filterIdFaqCategoria = 0; 
  String filterText = "";

  FaqQuestionario faqQuestionario;
  List<FaqQuestionario> faqQuestionarioList;

  @override
  Dao dao;

  FaqDAO(this._hasuraBloc,this.faqQuestionario) {
    dao = Dao();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    this.faqQuestionario.id = map['id'];
    this.faqQuestionario.idFaqCategoria =map['id_categoria'];
    this.faqQuestionario.pergunta =map['pergunta'];
    this.faqQuestionario.resposta =map['resposta'];
    this.faqQuestionario.ehDeletado = map['ehdeletado'];
    this.faqQuestionario.dataCadastro = DateTime.parse(map['data_cadastro']);
    this.faqQuestionario.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
  
    return this.faqQuestionario;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where = "";
    List<dynamic> args = [];

    if (filterText != "") {
      where = where + "and (pergunta like '%" + filterText + "%')";
    }

    List list = await dao.getList(this, where, args);
   faqQuestionarioList = List.generate(list.length, (i) {
      return FaqQuestionario(
        id: list[i]['id'],
        idFaqCategoria: list[i]['id_faq_categoria'],
        pergunta: list[i]['pergunta'],
        resposta: list[i]['resposta'],
         ehDeletado: list[i]['ehdeletado'],
        dataCadastro: list[i]['data_cadastro'] != null ? DateTime.parse(list[i]['data_cadastro']) : null,
        dataAtualizacao: list[i]['data_atualizacao'] != null ? DateTime.parse(list[i]['data_atualizacao']) : null,
      );
    });
    return faqQuestionarioList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool id=false, bool idFaqCategoria=false,
    bool ehDeletado=false, FilterEhDeletado filterEhDeletado=FilterEhDeletado.naoDeletados,
    bool dataCadastro=false, bool dataAtualizacao=false, int offset = 0}) async {
    String query = """ 
      {
        faq(limit: $queryLimit, offset: $offset,)
         {
            ${id ? "id" : ""}
            ${idFaqCategoria ? "idFaqCategoria" : ""}
            pergunta
            resposta
            ${ehDeletado ? "ehdeletado" : ""}
            ${dataCadastro ? "data_cadastro" : ""}
            ${dataAtualizacao ? "data_atualizacao" : ""}
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    faqQuestionarioList = [];

      for(var i = 0; i < data['data']['faq'].length; i++){
        faqQuestionarioList.add(
          FaqQuestionario(
            id: data['data']['faq'][i]['id'],
            idFaqCategoria: data['data']['faq'][i]['id_faq_categoria'],
            pergunta: data['data']['faq'][i]['pergunta'],
            resposta: data['data']['faq'][i]['resposta'],
            ehDeletado: data['data']['faq_questionario'][i]['ehdeletado'],
            dataCadastro: data['data']['faq_questionario'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['faq_questionario'][i]['data_cadastro']) : null,
            dataAtualizacao: data['data']['faq_questionario'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['faq_questionario'][i]['data_atualizacao']) : null,
            
          )       
        );
      }
      return faqQuestionarioList;
    }
  
  @override
  Future<IEntity> getById(int id) async {
    return await dao.getById(this, id);
  }

  Future<IEntity> getByIdFromServer(int id) async {
    String query = """ 
      {
        faq(where: {id: {_eq: $id}}) {
          id
          id_faq_categoria
          pergunta
          resposta
          data_cadastro
          data_atualizacao
          ehdeletado
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    FaqQuestionario _faqQuestionario = FaqQuestionario(
      id: data['data']['faq'][0]['id'],
      idFaqCategoria: data['data']['faq'][0]['id_faq_categoria'],
      pergunta: data['data']['faq'][0]['pergunta'],
      resposta: data['data']['faq'][0]['resposta'],
      dataCadastro: data['data']['faq'][0]['data_cadastro'],
      dataAtualizacao: data['data']['faq'][0]['data_atualizacao'],
      ehDeletado: data['data']['faq'][0]['ehdeletado'],
    );
    return _faqQuestionario;
  }


  @override
  Future<IEntity> delete(int id) async {
    return this.faqQuestionario;
  }  

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': this.faqQuestionario.id,
      'id_faq_categoria': this.faqQuestionario.idFaqCategoria,
      'pergunta': this.faqQuestionario.pergunta,
      'resposta': this.faqQuestionario.resposta,
      'data_cadastro': this.faqQuestionario.dataCadastro,
      'data_atualizacao': this.faqQuestionario.dataAtualizacao,
      'ehdeletado' : this.faqQuestionario.ehDeletado,
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

  @override
  Future<IEntity> insert() {
    // TODO: implement insert
    return null;
  }
}
