import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:common_files/src/model/entities/configuracao/configuracao_geral/configuracao_geral.dart';
import 'package:common_files/src/model/entities/configuracao/configuracao_geral/configuracao_geralDao.dart';
import 'package:rxdart/rxdart.dart';

class ConfiguracaoGeralBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc appGlobalBloc;
  String filtroNome="";
  
  ConfiguracaoGeral configuracaoGeral;
  ConfiguracaoGeralDAO configuracaoGeralDAO;
  List<ConfiguracaoGeral> configuracaoGeralList = [];
  BehaviorSubject<ConfiguracaoGeral> configuracaoGeralController;
  Stream<ConfiguracaoGeral> get configuracaoGeralOut => configuracaoGeralController.stream;

  bool formInvalido = false;

  bool nomeInvalido = false;
  BehaviorSubject<bool> nomeInvalidoController;
  Stream<bool> get nomeInvalidoOut => nomeInvalidoController.stream;

  bool configuracaoGeralInvalida = false;
  BehaviorSubject<bool> configuracaoGeralInvalidaController;
  Stream<bool> get configuracaoGeralInvalidaOut => configuracaoGeralInvalidaController.stream;

  ConfiguracaoGeralBloc(this._hasuraBloc, this.appGlobalBloc) {
    configuracaoGeral = ConfiguracaoGeral();
    configuracaoGeralDAO = ConfiguracaoGeralDAO(_hasuraBloc, configuracaoGeral, appGlobalBloc);
    configuracaoGeralController = BehaviorSubject.seeded(configuracaoGeral);
  }

  getAllConfiguracaoGeral() async {
    ConfiguracaoGeral _configuracaoGeral = ConfiguracaoGeral();
    ConfiguracaoGeralDAO _configuracaoGeralDAO = ConfiguracaoGeralDAO(_hasuraBloc, configuracaoGeral, appGlobalBloc);
    configuracaoGeralList = await _configuracaoGeralDAO.getAllFromServer(id: true, ehMenuClassico: true);
    if (configuracaoGeralList.length > 0) {
      configuracaoGeral = configuracaoGeralList.first;
      configuracaoGeralController.add(configuracaoGeral);
    }
  } 

  getConfiguracaoGeralById(int id) async {
    ConfiguracaoGeral _configuracaoGeral = ConfiguracaoGeral();
    ConfiguracaoGeralDAO _configuracaoGeralDAO = ConfiguracaoGeralDAO(_hasuraBloc, configuracaoGeral, appGlobalBloc);
    configuracaoGeral = await _configuracaoGeralDAO.getByIdFromServer(id);
    configuracaoGeralController.add(configuracaoGeral);
  }

  saveConfiguracaoGeral() async  {
    configuracaoGeral.dataCadastro = configuracaoGeral.dataCadastro == null ? DateTime.now() : configuracaoGeral.dataCadastro;
    configuracaoGeral.dataAtualizacao = DateTime.now();
    ConfiguracaoGeralDAO _configuracaoGeralDAO = ConfiguracaoGeralDAO(_hasuraBloc, configuracaoGeral, appGlobalBloc);
    configuracaoGeral = await _configuracaoGeralDAO.saveOnServer();
  }

   setTemServico(bool value) async {
    configuracaoGeral.temServico = value ? 1 : 0;
    configuracaoGeralController.add(configuracaoGeral);
  }

  setMenu(int value) async {
    configuracaoGeral.ehMenuClassico = value;
    configuracaoGeralController.add(configuracaoGeral);
  }
    
  setEhServicoDefault(bool value) async {
    configuracaoGeral.ehServicoDefault = value ? 1 : 0;
    configuracaoGeralController.add(configuracaoGeral);
  }
  
  resetBloc() async  {
    configuracaoGeral = ConfiguracaoGeral();
    configuracaoGeralController.add(configuracaoGeral);
  }

  @override
  void dispose() {
    configuracaoGeralController.close();
    super.dispose();
  }
}
