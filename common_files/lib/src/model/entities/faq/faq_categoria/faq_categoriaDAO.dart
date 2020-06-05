import 'dart:convert';

import 'package:common_files/common_files.dart';

class FaqCategoriaDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "faq_categoria";
  int filterId = 0;
  String filterText = "";
  bool loadFaq = false;

  FaqCategoria faqCategoria;
  FaqQuestionario _faqQuestionario;
  List<FaqCategoria> faqCategoriaList;

  @override
  Dao dao;

  FaqCategoriaDAO(this._hasuraBloc, this._appGlobalBloc, {this.faqCategoria}) {
    dao = Dao();
    _faqQuestionario = FaqQuestionario();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    this.faqCategoria.id = map['id'];
    this.faqCategoria.nome = map['nome'];
    this.faqCategoria.ehDeletado = map['ehdeletado'];
    this.faqCategoria.dataCadastro = DateTime.parse(map['data_cadastro']);
    this.faqCategoria.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
  
    return this.faqCategoria;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where = "id_pessoa_grupo = ${_appGlobalBloc.loja.idPessoaGrupo}";
    List<dynamic> args = [];

    if (filterText != "") {
      where = where + "and (nome like '%" + filterText + "%')";
    }

    List list = await dao.getList(this, where, args);
   faqCategoriaList = List.generate(list.length, (i) {
      return FaqCategoria(
        id: list[i]['id'],
        nome: list[i]['nome'],
        ehDeletado: list[i]['ehdeletado'],
        dataCadastro: list[i]['data_cadastro'] != null ? DateTime.parse(list[i]['data_cadastro']) : null,
        dataAtualizacao: list[i]['data_atualizacao'] != null ? DateTime.parse(list[i]['data_atualizacao']) : null,
      );
    });

    if (preLoad) {
      for (var faqCategoria in faqCategoriaList) {
        FaqDAO faqDAO = FaqDAO(_hasuraBloc, _faqQuestionario);
        if (loadFaq) {
          faqDAO.filterIdFaqCategoria = faqCategoria.id;
          List<FaqQuestionario> faqList =
              await faqDAO.getAll();
          faqCategoria.faqQuestionario = faqList;
        }
      }
    }

          return faqCategoriaList;
        }

  Future<List> getAllFromServer({bool preLoad=false, bool id=false, bool completo=false,
    bool ehDeletado=false, bool ehServico=false, bool dataCadastro=false, bool dataAtualizacao=false, String filtroNome="",
    DateTime filtroDataAtualizacao, FilterEhDeletado filterEhDeletado=FilterEhDeletado.naoDeletados,
    bool faq=false, bool faqApenasPergunta=true, int offset = 0}) async {
   
    faqApenasPergunta = completo ? false : faqApenasPergunta;     

    String queryFaq = """
        faqs{
          pergunta
          resposta   
        }
    """;
    
    
      String query = """ 
        {
          faq_categoria(limit: $queryLimit, offset: $offset, where: {
            nome: {${filtroNome != "" ? '_ilike:  '+'"$filtroNome%"' : ''}},
            ehdeletado: {${filterEhDeletado != FilterEhDeletado.todos ? filterEhDeletado == FilterEhDeletado.naoDeletados ? '_eq:  0' : '_eq:  1' : ''}},
            data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
            order_by: {${filtroDataAtualizacao == null ? 'nome: asc' : 'data_atualizacao: asc'}}) {
              ${id ? "id" : ""}
              nome
              ${ehDeletado ? "ehdeletado" : ""}
              ${dataCadastro ? "data_cadastro" : ""}
              ${dataAtualizacao ? "data_atualizacao" : ""}
              ${faq ? queryFaq : ""}
          }
        }
      """;

     print(query);

    var data = await _hasuraBloc.hasuraConnect.query(query);
    faqCategoriaList = [];

    

      for(var i = 0; i < data['data']['faq_categoria'].length; i++){
        List<FaqQuestionario> faqList = [];
        if (data['data']['faq_categoria'][i]['faqs'] != null) {
          data['data']['faq_categoria'][i]['faqs'].forEach((v) {
            faqList.add(new FaqQuestionario.fromJson(v));
          });
       }  


        faqCategoriaList.add(
          FaqCategoria(
            id: data['data']['faq_categoria'][i]['id'],
            nome: data['data']['faq_categoria'][i]['nome'],
            ehDeletado: data['data']['faq_categoria'][i]['ehdeletado'],
            dataCadastro: data['data']['faq_categoria'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['faq_categoria'][i]['data_cadastro']) : null,
            dataAtualizacao: data['data']['faq_categoria'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['faq_categoria'][i]['data_atualizacao']) : null,
            faqQuestionario: faqList
          )       
        );
      }
      return faqCategoriaList;
    }
  
  @override
  Future<IEntity> getById(int id) async {
    return await dao.getById(this, id);
  }

  Future<IEntity> getByIdFromServer(int id) async {
    String query = """ 
      {
        faq_categoria(where: {id: {_eq: $id}}) {
          id
          nome
          ehdeletado
          data_cadastro
          data_atualizacao
        }
         faqs {
            id
            id_faq_categoria
            pergunta
            resposta
          }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);

    var faqList = new List<FaqQuestionario>();
    
    if (data['data']['faq_categoria'][0]['faqs'] != null) {
      data['data']['fac_categoria'][0]['faqs'].forEach((v) {
        faqList.add(new FaqQuestionario.fromJson(v));
      });
    }


    FaqCategoria _faqCategoria = FaqCategoria(
      id: data['data']['faq_categoria'][0]['id'],
      nome: data['data']['faq_categoria'][0]['nome'],
      ehDeletado: data['data']['faq_categoria'][0]['ehdeletado'],
      dataCadastro: DateTime.parse(data['data']['faq_categoria'][0]['data_cadastro']),
      dataAtualizacao: DateTime.parse(data['data']['faq_categoria'][0]['data_atualizacao']),
      faqQuestionario: faqList
    );
    return _faqCategoria;
  }

  Future<DateTime> getUltimaSincronizacao() async {
    List<Map> data = await dao.getRawQuery("select max(data_atualizacao) as data_atualizacao from categoria where id_pessoa_grupo = ${_appGlobalBloc.loja.idPessoaGrupo} ");
    return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
  }

  @override
  Future<IEntity> delete(int id) async {
    return this.faqCategoria;
  }  

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': this.faqCategoria.id,
      'nome': this.faqCategoria.nome,
      'ehdeletado': this.faqCategoria.ehDeletado,
      'data_cadastro': this.faqCategoria.dataCadastro.toString(),
      'data_atualizacao': this.faqCategoria.dataAtualizacao.toString(),
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




 

