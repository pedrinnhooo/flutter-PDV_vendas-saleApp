import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:common_files/common_files.dart';

class GradeBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  String filtroNome="";
  
  Grade grade;
  GradeDAO gradeDAO;
  List<Grade> gradeList = [];
  BehaviorSubject<Grade> gradeController;
  Observable<Grade> get gradeOut => gradeController.stream;
  BehaviorSubject<List<Grade>> gradeListController;
  Observable<List<Grade>> get gradeListOut => gradeListController.stream;

  bool formInvalido = false;

  bool nomeInvalido = false;
  BehaviorSubject<bool> nomeInvalidoController;
  Observable<bool> get nomeInvalidoOut => nomeInvalidoController.stream;

  bool t1Invalido = false;
  BehaviorSubject<bool> t1InvalidoController;
  Observable<bool> get t1InvalidoOut => t1InvalidoController.stream;

  bool t2Invalido = false;
  BehaviorSubject<bool> t2InvalidoController;
  Observable<bool> get t2InvalidoOut => t2InvalidoController.stream;

  bool t3Invalido = false;
  BehaviorSubject<bool> t3InvalidoController;
  Observable<bool> get t3InvalidoOut => t3InvalidoController.stream;

  bool t4Invalido = false;
  BehaviorSubject<bool> t4InvalidoController;
  Observable<bool> get t4InvalidoOut => t4InvalidoController.stream;

  bool t5Invalido = false;
  BehaviorSubject<bool> t5InvalidoController;
  Observable<bool> get t5InvalidoOut => t5InvalidoController.stream;

  bool t6Invalido = false;
  BehaviorSubject<bool> t6InvalidoController;
  Observable<bool> get t6InvalidoOut => t6InvalidoController.stream;

  bool t7Invalido = false;
  BehaviorSubject<bool> t7InvalidoController;
  Observable<bool> get t7InvalidoOut => t7InvalidoController.stream;

  bool t8Invalido = false;
  BehaviorSubject<bool> t8InvalidoController;
  Observable<bool> get t8InvalidoOut => t8InvalidoController.stream;

  bool t9Invalido = false;
  BehaviorSubject<bool> t9InvalidoController;
  Observable<bool> get t9InvalidoOut => t9InvalidoController.stream;

  bool t10Invalido = false;
  BehaviorSubject<bool> t10InvalidoController;
  Observable<bool> get t10InvalidoOut => t10InvalidoController.stream;

  bool t11Invalido = false;
  BehaviorSubject<bool> t11InvalidoController;
  Observable<bool> get t11InvalidoOut => t11InvalidoController.stream;

  bool t12Invalido = false;
  BehaviorSubject<bool> t12InvalidoController;
  Observable<bool> get t12InvalidoOut => t12InvalidoController.stream;

  bool t13Invalido = false;
  BehaviorSubject<bool> t13InvalidoController;
  Observable<bool> get t13InvalidoOut => t13InvalidoController.stream;

  bool t14Invalido = false;
  BehaviorSubject<bool> t14InvalidoController;
  Observable<bool> get t14InvalidoOut => t14InvalidoController.stream;

  GradeBloc(this._hasuraBloc) {
    grade = Grade();
    gradeDAO = GradeDAO(_hasuraBloc, grade: grade);
    gradeController = BehaviorSubject.seeded(grade);
    gradeListController = BehaviorSubject.seeded(gradeList);
    nomeInvalidoController = BehaviorSubject.seeded(nomeInvalido);
    t1InvalidoController = BehaviorSubject.seeded(t1Invalido);
    t2InvalidoController = BehaviorSubject.seeded(t2Invalido);
    t3InvalidoController = BehaviorSubject.seeded(t3Invalido);
    t4InvalidoController = BehaviorSubject.seeded(t4Invalido);
    t5InvalidoController = BehaviorSubject.seeded(t5Invalido);
    t6InvalidoController = BehaviorSubject.seeded(t6Invalido);
    t7InvalidoController = BehaviorSubject.seeded(t7Invalido);
    t8InvalidoController = BehaviorSubject.seeded(t8Invalido);
    t9InvalidoController = BehaviorSubject.seeded(t9Invalido);
    t10InvalidoController = BehaviorSubject.seeded(t10Invalido);
    t11InvalidoController = BehaviorSubject.seeded(t11Invalido);
    t12InvalidoController = BehaviorSubject.seeded(t12Invalido);
    t13InvalidoController = BehaviorSubject.seeded(t13Invalido);
    t14InvalidoController = BehaviorSubject.seeded(t14Invalido);
  }

  getAllGrade() async {
    Grade _grade = Grade();
    GradeDAO _gradeDAO = GradeDAO(_hasuraBloc, grade: _grade);
    gradeList = await _gradeDAO.getAllFromServer(id: true, filtroNome: filtroNome);
    gradeListController.add(gradeList);
  } 

  getGradeById(int id) async {
    Grade _grade = Grade();
    GradeDAO _gradeDAO = GradeDAO(_hasuraBloc, grade: _grade);
    grade = await _gradeDAO.getByIdFromServer(id);
    gradeController.add(grade);
  }

  newGrade() async {
    grade = Grade();
    grade.nome = "";
    gradeController.add(grade);
  }

  saveGrade() async  {
    grade.dataCadastro = grade.dataCadastro == null ? DateTime.now() : grade.dataCadastro;
    grade.dataAtualizacao = DateTime.now();
    GradeDAO _gradeDAO = GradeDAO(_hasuraBloc, grade: grade);
    grade = await _gradeDAO.saveOnServer();
    await getAllGrade();
    await resetBloc();
  }

  deleteGrade() async {
    grade.ehDeletado = 1; 
    grade.dataAtualizacao = DateTime.now();
    GradeDAO _gradeDAO = GradeDAO(_hasuraBloc, grade: grade);
    grade = await _gradeDAO.saveOnServer();
    await resetBloc();
  }

  validaNome() async {
    nomeInvalido = grade.nome == "" ? true : false;
    formInvalido = nomeInvalido;
    nomeInvalidoController.add(nomeInvalido);
  }

  validat1() async {
    t1Invalido = grade.t1 == "" ? true : false;
    formInvalido = !formInvalido ? t1Invalido : formInvalido;
    t1InvalidoController.add(t1Invalido);
  }

  validat2() async {
    t2Invalido = grade.t2 == "" && grade.t3 != "" ? true : false;
    formInvalido = !formInvalido ? t2Invalido : formInvalido;
    t2InvalidoController.add(t2Invalido);
  }

  validat3() async {
    t3Invalido = grade.t3 == "" && grade.t4 != "" ? true : false;
    formInvalido = !formInvalido ? t3Invalido : formInvalido;
    t3InvalidoController.add(t3Invalido);
  }

  validat4() async {
    t4Invalido = grade.t4 == "" && grade.t5 != "" ? true : false;
    formInvalido = !formInvalido ? t4Invalido : formInvalido;
    t4InvalidoController.add(t4Invalido);
  }

  validat5() async {
    t5Invalido = grade.t5 == "" && grade.t6 != "" ? true : false;
    formInvalido = !formInvalido ? t5Invalido : formInvalido;
    t5InvalidoController.add(t5Invalido);
  }

  validat6() async {
    t6Invalido = grade.t6 == "" && grade.t7 != "" ? true : false;
    formInvalido = !formInvalido ? t6Invalido : formInvalido;
    t6InvalidoController.add(t6Invalido);
  }

  validat7() async {
    t7Invalido = grade.t7 == "" && grade.t8 != "" ? true : false;
    formInvalido = !formInvalido ? t7Invalido : formInvalido;
    t7InvalidoController.add(t7Invalido);
  }

  validat8() async {
    t8Invalido = grade.t8 == "" && grade.t9 != "" ? true : false;
    formInvalido = !formInvalido ? t8Invalido : formInvalido;
    t8InvalidoController.add(t8Invalido);
  }

  validat9() async {
    t9Invalido = grade.t9 == "" && grade.t10 != "" ? true : false;
    formInvalido = !formInvalido ? t9Invalido : formInvalido;
    t9InvalidoController.add(t9Invalido);
  }

  validat10() async {
    t10Invalido = grade.t10 == "" && grade.t11 != "" ? true : false;
    formInvalido = !formInvalido ? t10Invalido : formInvalido;
    t10InvalidoController.add(t10Invalido);
  }

  validat11() async {
    t11Invalido = grade.t11 == "" && grade.t12 != "" ? true : false;
    formInvalido = !formInvalido ? t11Invalido : formInvalido;
    t11InvalidoController.add(t11Invalido);
  }

  validat12() async {
    t12Invalido = grade.t12 == "" && grade.t13 != "" ? true : false;
    formInvalido = !formInvalido ? t12Invalido : formInvalido;
    t12InvalidoController.add(t12Invalido);
  }

  validat13() async {
    t13Invalido = grade.t13 == "" && grade.t14 != "" ? true : false;
    formInvalido = !formInvalido ? t13Invalido : formInvalido;
    t13InvalidoController.add(t13Invalido);
  }

  validat14() async {
    t14Invalido = grade.t14 == "" && grade.t15 != "" ? true : false;
    formInvalido = !formInvalido ? t14Invalido : formInvalido;
    t14InvalidoController.add(t14Invalido);
  }

  validaForm() async {
    await validaNome();
    await validat1();
    await validat2();
    await validat3();
    await validat4();
    await validat5();
    await validat6();
    await validat7();
    await validat8();
    await validat9();
    await validat10();
    await validat11();
    await validat12();
    await validat13();
    await validat14();
  }

  limpaValidacoes(){
    nomeInvalido = false;
    nomeInvalidoController.add(nomeInvalido);
    t1Invalido = false;
    t1InvalidoController.add(t1Invalido);
    t2Invalido = false;
    t2InvalidoController.add(t2Invalido);
    t3Invalido = false;
    t3InvalidoController.add(t3Invalido);
    t4Invalido = false;
    t4InvalidoController.add(t4Invalido);
    t5Invalido = false;
    t5InvalidoController.add(t5Invalido);
    t6Invalido = false;
    t6InvalidoController.add(t6Invalido);
    t7Invalido = false;
    t7InvalidoController.add(t7Invalido);
    t8Invalido = false;
    t8InvalidoController.add(t8Invalido);
    t9Invalido = false;
    t9InvalidoController.add(t9Invalido);
    t10Invalido = false;
    t10InvalidoController.add(t10Invalido);
    t11Invalido = false;
    t11InvalidoController.add(t11Invalido);
    t12Invalido = false;
    t12InvalidoController.add(t12Invalido);
    t13Invalido = false;
    t13InvalidoController.add(t13Invalido);
    t14Invalido = false;
    t14InvalidoController.add(t14Invalido);
  }

  updateStream() {
    gradeController.add(grade);
  }

  resetBloc() async  {
    grade = Grade();
    gradeController.add(grade);
  }

  @override
  void dispose() {
    gradeController.close();
    gradeListController.close();
    nomeInvalidoController.close();
    t1InvalidoController.close();
    t2InvalidoController.close();
    t3InvalidoController.close();
    t4InvalidoController.close();
    t5InvalidoController.close();
    t6InvalidoController.close();
    t7InvalidoController.close();
    t8InvalidoController.close();
    t9InvalidoController.close();
    t10InvalidoController.close();
    t11InvalidoController.close();
    t12InvalidoController.close();
    t13InvalidoController.close();
    t14InvalidoController.close();
    super.dispose();
  }
}
