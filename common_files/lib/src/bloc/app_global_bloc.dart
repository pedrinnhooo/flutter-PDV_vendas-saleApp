import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:zendesk/zendesk.dart';

import '../../common_files.dart';

class AppGlobalBloc extends BlocBase {
  Pessoa loja;
  Pessoa usuario;
  Terminal terminal;
  HasuraBloc _hasuraBloc;
  List<ModuloGrupo> moduloGrupoList;
  Logger logger;
  List<LogErro> logErroList;
  final Zendesk zendesk = Zendesk();

  ConfiguracaoGeral configuracaoGeral;
  BehaviorSubject<ConfiguracaoGeral> configuracaoGeralController;
  Stream<ConfiguracaoGeral> get configuracaoGeralOut => configuracaoGeralController.stream;

  AppGlobalBloc(this._hasuraBloc) {
    loja = Pessoa();
    usuario = Pessoa();
    terminal = Terminal();
    moduloGrupoList = [];
    configuracaoGeralController = BehaviorSubject.seeded(configuracaoGeral);
    logger = Logger();
    logErroList = [];
    initZendesk();
  }

  getMenu() async{
    ConfiguracaoGeral configuracaoGeral = ConfiguracaoGeral();
    ConfiguracaoGeralDAO configuracaoGeralDAO = ConfiguracaoGeralDAO(_hasuraBloc, configuracaoGeral, this);
    List<ConfiguracaoGeral> configuracaoGeralList = [];
    configuracaoGeralList = await configuracaoGeralDAO.getAll();
    configuracaoGeral = configuracaoGeralList.first;
    configuracaoGeralController.add(configuracaoGeral);
  }

   updateConfiguracaoGeralStream() {
     configuracaoGeralController.add(configuracaoGeral);
  }

  Future<bool> getModuloAcesso(ModuloEnum value) async {
    List<PessoaModulo> pessoaModuloList = [];
    PessoaModulo pessoaModulo = PessoaModulo();
    PessoaModuloDAO pessoaModuloDAO = PessoaModuloDAO(_hasuraBloc, this, pessoaModulo: pessoaModulo);
    pessoaModuloList = await pessoaModuloDAO.getAll();
    if (pessoaModuloList.length > 0) {
      List<int> _filtroIds = []; 
      pessoaModuloList.forEach((pessoaModulo) => _filtroIds.add(pessoaModulo.idModuloGrupo));
      ModuloGrupo _moduloGrupo = ModuloGrupo();
      ModuloGrupoDAO _moduloGrupoDAO = ModuloGrupoDAO(_hasuraBloc, this, _moduloGrupo);
      _moduloGrupoDAO.loadModuloGrupoItem = true;
      moduloGrupoList = await _moduloGrupoDAO.getAll(preLoad: true, filtroIds: _filtroIds); 
      for (var modulo in moduloGrupoList) {
        var moduloGrupoItem = modulo.moduloGrupoItem.firstWhere((_moduloGrupoItem) => _moduloGrupoItem.idModulo == value.index, orElse: () => null);
        if (moduloGrupoItem != null) {
          return true;
        }  
      }
    }
    return false; 
  }

  Future<void> initZendesk() async {
    zendesk.init(zenDeskAccountKey, department: 'Departament', appName: 'Fluggy').then((r) {
      print('init finished');
    }).catchError((error, stacktrace) {
      log(_hasuraBloc, this, 
        nomeArquivo: "app_globa_bloc",
        error: "Erro ZenDesk: ${error.toString()}",
        nomeFuncao: "ZenDesk - initZendesk",
        stacktrace: stacktrace.toString()
      );
    });
  }
  
  @override
  void dispose() {
    super.dispose();
    configuracaoGeralController.close();
  }
}     