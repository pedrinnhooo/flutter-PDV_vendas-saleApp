import 'package:common_files/src/bloc/hasura_bloc.dart';
import 'package:common_files/src/model/dao/dao.dart';
import 'package:common_files/src/model/entities/cadastro/grade/grade.dart';
import 'package:common_files/src/model/entities/interfaces.dart';

class GradeDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  final String tableName = "grade";
  int filterId;
  String filterText;

  Grade grade;
  List<Grade> gradeList;

  @override
  Dao dao;

  GradeDAO(this._hasuraBloc, {this.grade}) {
    dao = Dao();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    this.grade.id = map['id'];
    this.grade.idPessoaGrupo = map['id_pessoa_grupo'];
    this.grade.nome = map['nome'];
    this.grade.t1 = map['t1'];
    this.grade.t2 = map['t2'];
    this.grade.t3 = map['t3'];
    this.grade.t4 = map['t4'];
    this.grade.t5 = map['t5'];
    this.grade.t6 = map['t6'];
    this.grade.t7 = map['t7'];
    this.grade.t8 = map['t8'];
    this.grade.t9 = map['t9'];
    this.grade.t10 = map['t10'];
    this.grade.t11 = map['t11'];
    this.grade.t12 = map['t12'];
    this.grade.t13 = map['t13'];
    this.grade.t14 = map['t14'];
    this.grade.t15 = map['t15'];
    this.grade.ehDeletado = map['ehdeletado'];
    this.grade.dataCadastro = DateTime.parse(map['data_cadastro']);
    this.grade.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
    return this.grade;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where = "";
    List<dynamic> args = [];
    where = "1 = 1 ";
    if ((filterId > 0) || (filterText != "")) {
      where = "1 = 1 ";
      if (filterId > 0) {
        where = where + "and (id = " + filterText + ")";
      }
      if (filterText != "") {
        where = where + "and (nome like '%" + filterText + "%')";
      }
    }

    List list = await dao.getList(this, where, args);
    gradeList = List.generate(list.length, (i) {
      return Grade(
        id: list[i]['id'],
        idPessoaGrupo: list[i]['id_pessoa_grupo'],
        nome: list[i]['nome'],
        t1: list[i]['t1'],
        t2: list[i]['t2'],
        t3: list[i]['t3'],
        t4: list[i]['t4'],
        t5: list[i]['t5'],
        t6: list[i]['t6'],
        t7: list[i]['t7'],
        t8: list[i]['t8'],
        t9: list[i]['t9'],
        t10: list[i]['t10'],
        t11: list[i]['t11'],
        t12: list[i]['t12'],
        t13: list[i]['t13'],
        t14: list[i]['t14'],
        t15: list[i]['t15'],
        ehDeletado: list[i]['ehdeletado'],
        dataCadastro: list[i]['data_cadastro'],
        dataAtualizacao: list[i]['data_atualizacao'],
      );
    });

    return gradeList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool id=false, bool idPessoaGrupo=false,
    bool tamanhos=false, bool ehDeletado=false, bool dataCadastro=false, bool dataAtualizacao=false, 
    String filtroNome=""}) async {
    String query = """ 
      {
        grade(where: {
          nome: {${filtroNome != "" ? '_ilike:  '+'"$filtroNome%"' : ''}}}, 
          order_by: {nome: asc}) {
            ${id ? "id" : ""}
            ${idPessoaGrupo ? "id_pessoa_grupo" : ""}
            nome
            ${tamanhos ? "t1" : ""}
            ${tamanhos ? "t2" : ""}
            ${tamanhos ? "t3" : ""}
            ${tamanhos ? "t4" : ""}
            ${tamanhos ? "t5" : ""}
            ${tamanhos ? "t6" : ""}
            ${tamanhos ? "t7" : ""}
            ${tamanhos ? "t8" : ""}
            ${tamanhos ? "t9" : ""}
            ${tamanhos ? "t10" : ""}
            ${tamanhos ? "t11" : ""}
            ${tamanhos ? "t12" : ""}
            ${tamanhos ? "t13" : ""}
            ${tamanhos ? "t14" : ""}
            ${tamanhos ? "t15" : ""}
            ${ehDeletado ? "ehdeletado" : ""}
            ${dataCadastro ? "data_cadastro" : ""}
            ${dataAtualizacao ? "data_atualizacao" : ""}
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    gradeList = [];

      for(var i = 0; i < data['data']['grade'].length; i++){
        gradeList.add(
          Grade(
            id: data['data']['grade'][i]['id'],
            idPessoaGrupo: data['data']['grade'][i]['id_pessoa'],
            nome: data['data']['grade'][i]['nome'],
            t1: data['data']['grade'][i]['t1'],
            t2: data['data']['grade'][i]['t2'],
            t3: data['data']['grade'][i]['t3'],
            t4: data['data']['grade'][i]['t4'],
            t5: data['data']['grade'][i]['t5'],
            t6: data['data']['grade'][i]['t6'],
            t7: data['data']['grade'][i]['t7'],
            t8: data['data']['grade'][i]['t8'],
            t9: data['data']['grade'][i]['t9'],
            t10: data['data']['grade'][i]['t10'],
            t11: data['data']['grade'][i]['t11'],
            t12: data['data']['grade'][i]['t12'],
            t13: data['data']['grade'][i]['t13'],
            t14: data['data']['grade'][i]['t14'],
            t15: data['data']['grade'][i]['t15'],
            ehDeletado: data['data']['grade'][i]['ehdeletado'],
            dataCadastro: data['data']['grade'][i]['data_cadastro'],
            dataAtualizacao: data['data']['grade'][i]['data_atualizacao']
          )       
        );
      }
      return gradeList;
    }

  @override
  Future<IEntity> getById(int id) async {
    grade = await dao.getById(this, id);
    return grade;
  }

  Future<IEntity> getByIdFromServer(int id) async {
    String query = """ 
      {
        grade(where: {id: {_eq: $id}}) {
          id
          id_pessoa_grupo
          nome
          t1
          t2
          t3
          t4
          t5
          t6
          t7
          t8
          t9
          t10
          t11
          t12
          t13
          t14
          t15
          ehdeletado
          data_cadastro
          data_atualizacao
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    Grade _grade = Grade(
      id: data['data']['grade'][0]['id'],
      idPessoaGrupo: data['data']['grade'][0]['id_pessoa'],
      nome: data['data']['grade'][0]['nome'],
      t1: data['data']['grade'][0]['t1'],
      t2: data['data']['grade'][0]['t2'],
      t3: data['data']['grade'][0]['t3'],
      t4: data['data']['grade'][0]['t4'],
      t5: data['data']['grade'][0]['t5'],
      t6: data['data']['grade'][0]['t6'],
      t7: data['data']['grade'][0]['t7'],
      t8: data['data']['grade'][0]['t8'],
      t9: data['data']['grade'][0]['t9'],
      t10: data['data']['grade'][0]['t10'],
      t11: data['data']['grade'][0]['t11'],
      t12: data['data']['grade'][0]['t12'],
      t13: data['data']['grade'][0]['t13'],
      t14: data['data']['grade'][0]['t14'],
      t15: data['data']['grade'][0]['t15'],
      ehDeletado: data['data']['grade'][0]['ehdeletado'],
      dataCadastro: DateTime.parse(data['data']['grade'][0]['data_cadastro']),
      dataAtualizacao: DateTime.parse(data['data']['grade'][0]['data_atualizacao'])
    );
    return _grade;
  }

  @override
  Future<IEntity> insert() async {
    this.grade.id = await dao.insert(this);
    return this.grade;
  }

  Future<IEntity> saveOnServer() async {
    String _query = """ mutation saveGrade {
        insert_grade(objects: {""";

    if ((grade.id != null) && (grade.id > 0)) {
      _query = _query + "id: ${grade.id},";
    }    

    _query = _query + """
        nome: "${grade.nome}", 
        t1: "${grade.t1}", 
        t2: "${grade.t2}", 
        t3: "${grade.t3}", 
        t4: "${grade.t4}", 
        t5: "${grade.t5}", 
        t6: "${grade.t6}", 
        t7: "${grade.t7}", 
        t8: "${grade.t8}", 
        t9: "${grade.t9}", 
        t10: "${grade.t10}", 
        t11: "${grade.t11}", 
        t12: "${grade.t12}", 
        t13: "${grade.t13}", 
        t14: "${grade.t14}", 
        t15: "${grade.t15}", 
        ehdeletado: ${grade.ehDeletado}, 
        data_cadastro: "${grade.dataCadastro}",
        data_atualizacao: "${grade.dataAtualizacao}"},
        on_conflict: {
          constraint: grade_pkey, 
          update_columns: [
            nome,
            t1, 
            t2, 
            t3, 
            t4, 
            t5, 
            t6, 
            t7, 
            t8, 
            t9, 
            t10, 
            t11, 
            t12, 
            t13, 
            t14, 
            t15, 
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
      grade.id = data["data"]["insert_grade"]["returning"][0]["id"];
      return grade;
    } catch (error) {
      return null;
    }  
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': grade.id,
      'id_pessoa_grupo': grade.idPessoaGrupo,
      'nome': grade.nome,
      't1': grade.t1,
      't2': grade.t2,
      't3': grade.t3,
      't4': grade.t4,
      't5': grade.t5,
      't6': grade.t6,
      't7': grade.t7,
      't8': grade.t8,
      't9': grade.t9,
      't10': grade.t10,
      't11': grade.t11,
      't12': grade.t12,
      't13': grade.t13,
      't14': grade.t14,
      't15': grade.t15,
      'ehdeletado': grade.ehDeletado,
      'data_cadastro': grade.dataCadastro,
      'data_atualizacao': grade.dataAtualizacao,
    };
  }
}
