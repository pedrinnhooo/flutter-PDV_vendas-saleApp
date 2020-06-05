import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/src/bloc/hasura_bloc.dart';
import 'package:common_files/src/model/entities/configuracao/terminal/terminal.dart';
import 'package:common_files/src/model/entities/configuracao/terminal/terminalDao.dart';
import 'package:common_files/src/model/entities/configuracao/transacao/transacao.dart';
import 'package:rxdart/rxdart.dart';

class TerminalBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  String filtroNome="";
  
  Terminal terminal;
  TerminalDAO terminalDAO;
  List<Terminal> terminalList = [];
  BehaviorSubject<Terminal> terminalController;
  Observable<Terminal> get terminalOut => terminalController.stream;
  BehaviorSubject<List<Terminal>> terminalListController;
  Observable<List<Terminal>> get terminalListOut => terminalListController.stream;

  bool formInvalido = false;

  bool nomeInvalido = false;
  BehaviorSubject<bool> nomeInvalidoController;
  Observable<bool> get nomeInvalidoOut => nomeInvalidoController.stream;

  bool transacaoInvalida = false;
  BehaviorSubject<bool> transacaoInvalidaController;
  Observable<bool> get transacaoInvalidaOut => transacaoInvalidaController.stream;

  TerminalBloc(this._hasuraBloc) {
    terminal = Terminal();
    terminalDAO = TerminalDAO(_hasuraBloc, terminal: terminal);
    terminalController = BehaviorSubject.seeded(terminal);
    terminalListController = BehaviorSubject.seeded(terminalList);
    nomeInvalidoController = BehaviorSubject.seeded(nomeInvalido);
    transacaoInvalidaController = BehaviorSubject.seeded(transacaoInvalida);
  }

  getAllTerminal() async {
    Terminal _terminal = Terminal();
    TerminalDAO _terminalDAO = TerminalDAO(_hasuraBloc, terminal: _terminal);
    terminalList = await _terminalDAO.getAllFromServer(id: true, filtroNome: filtroNome);
    terminalListController.add(terminalList);
  } 

  getTerminalById(int id) async {
    Terminal _terminal = Terminal();
    TerminalDAO _terminalDAO = TerminalDAO(_hasuraBloc, terminal: _terminal);
    terminal = await _terminalDAO.getByIdFromServer(id);
    terminalController.add(terminal);
  }

  newTerminal() async {
    terminal = Terminal();
    terminal.nome = "";
    terminalController.add(terminal);
  }

  setTransacao(Transacao value) async {
    terminal.transacao = value;
    terminal.idTransacao = terminal.transacao.id;
    validaTransacao();
    terminalController.add(terminal);
  }

  saveTerminal() async  {
    terminal.dataCadastro = terminal.dataCadastro == null ? DateTime.now() : terminal.dataCadastro;
    terminal.dataAtualizacao = DateTime.now();
    TerminalDAO _terminalDAO = TerminalDAO(_hasuraBloc, terminal: terminal);
    terminal = await _terminalDAO.saveOnServer();
    await getAllTerminal();
    await resetBloc();
  }

  deleteTerminal() async {
    terminal.ehDeletado = 1; 
    terminal.dataAtualizacao = DateTime.now();
    TerminalDAO _terminalDAO = TerminalDAO(_hasuraBloc, terminal: terminal);
    terminal = await _terminalDAO.saveOnServer();
    await resetBloc();
  }

  validaNome() async {
    nomeInvalido = terminal.nome == "" ? true : false;
    formInvalido = nomeInvalido;
    nomeInvalidoController.add(nomeInvalido);
  }

  validaTransacao() async {
    transacaoInvalida = terminal.transacao.id == null || terminal.transacao.id == 0 ? true : false;
    formInvalido = transacaoInvalida;
    transacaoInvalidaController.add(transacaoInvalida);
  }

  validaForm() async {
    await validaNome(); 
    await validaTransacao();   
  }

  limpaValidacoes(){
    nomeInvalido = false;
    nomeInvalidoController.add(nomeInvalido);
    transacaoInvalida = false;
    transacaoInvalidaController.add(transacaoInvalida);
  }

  resetBloc() async  {
    terminal = Terminal();
    terminalController.add(terminal);
  }

  @override
  void dispose() {
    terminalController.close();
    terminalListController.close();
    nomeInvalidoController.close();
    transacaoInvalidaController.close();
    super.dispose();
  }
}
