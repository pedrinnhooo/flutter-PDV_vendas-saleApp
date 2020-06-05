import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:device_id/device_id.dart';
import 'package:rxdart/rxdart.dart';

class TerminalBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc appGlobalBloc;
  String mercadopagoIdLoja = "";
  String mercadopagoUserId = "";
  String mercadopagoAccessToken = "";
  String picpayAcessToken = "";
  String filtroNome="";
  int offset = 0;
  Terminal terminal;
  TerminalDAO terminalDAO;
  MercadopagoLoja mercadopagoLoja;
  MercadopagoTerminal mercadopagoTerminal;
  List<Terminal> terminalList = [];
  BehaviorSubject<Terminal> terminalController;
  Stream<Terminal> get terminalOut => terminalController.stream;
  BehaviorSubject<List<Terminal>> terminalListController;
  Stream<List<Terminal>> get terminalListOut => terminalListController.stream;

  bool formInvalido = false;

  bool nomeInvalido = false;
  BehaviorSubject<bool> nomeInvalidoController;
  Stream<bool> get nomeInvalidoOut => nomeInvalidoController.stream;

  bool transacaoInvalida = false;
  BehaviorSubject<bool> transacaoInvalidaController;
  Stream<bool> get transacaoInvalidaOut => transacaoInvalidaController.stream;

  TerminalBloc(this._hasuraBloc, this.appGlobalBloc) {
    terminal = Terminal(
      terminalImpressoraList: List<TerminalImpressora>()
    );
    terminalDAO = TerminalDAO(_hasuraBloc, appGlobalBloc, terminal: terminal);
    mercadopagoLoja = MercadopagoLoja();
    mercadopagoTerminal = MercadopagoTerminal();
    terminalController = BehaviorSubject.seeded(terminal);
    terminalListController = BehaviorSubject.seeded(terminalList);
    nomeInvalidoController = BehaviorSubject.seeded(nomeInvalido);
    transacaoInvalidaController = BehaviorSubject.seeded(transacaoInvalida);
  }

  getAllTerminal() async {
    Terminal _terminal = Terminal();
    TerminalDAO _terminalDAO = TerminalDAO(_hasuraBloc, appGlobalBloc, terminal: _terminal);
    terminalList = offset == 0 ? [] : terminalList;
    terminalList += await _terminalDAO.getAllFromServer(id: true, filtroNome: filtroNome, offset: offset);
    terminalListController.add(terminalList);
    offset += queryLimit;
    return terminalList;
  } 

  getTerminalById(int id) async {
    Terminal _terminal = Terminal();
    TerminalDAO _terminalDAO = TerminalDAO(_hasuraBloc, appGlobalBloc, terminal: _terminal);
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

  setImpressora(TerminalImpressora _terminalImpressora){
    _terminalImpressora.id = terminal.terminalImpressora.length > 0 ? terminal.terminalImpressora.first.id : null;
    _terminalImpressora.idTerminal = terminal.id;
    _terminalImpressora.tipoImpressora = "Rede";
    _terminalImpressora.macAddress = null;
    _terminalImpressora.ehDeletado = 0;
    _terminalImpressora.dataAtualizacao = DateTime.now();
    _terminalImpressora.dataCadastro = terminal.terminalImpressora.length > 0 ? terminal.terminalImpressora.first.dataCadastro : DateTime.now();
    if(terminal.terminalImpressora.length == 0){
      terminal.terminalImpressora.add(_terminalImpressora);
    } else {
      terminal.terminalImpressora.first = _terminalImpressora;
    }
    terminalController.add(terminal);
  }

  setImpressoraBluetooth(TerminalImpressora _terminalImpressora){
    _terminalImpressora.id = terminal.terminalImpressora.length > 0 ? terminal.terminalImpressora.first.id : null;
    _terminalImpressora.tipoImpressora = "Bluetooth";
    _terminalImpressora.ip = null;
    _terminalImpressora.idTerminal = terminal.id;
    _terminalImpressora.ehDeletado = 0;
    _terminalImpressora.dataAtualizacao = DateTime.now();
    _terminalImpressora.dataCadastro = terminal.terminalImpressora.length > 0 ? terminal.terminalImpressora.first.dataCadastro : DateTime.now();
    if(terminal.terminalImpressora.length == 0){
      terminal.terminalImpressora.add(_terminalImpressora);
    } else {
      terminal.terminalImpressora.first = _terminalImpressora;
    }
    terminalController.add(terminal);
  }

  saveTerminal() async  {
    await setIdDevice();
    terminal.dataCadastro = terminal.dataCadastro == null ? DateTime.now() : terminal.dataCadastro;
    terminal.dataAtualizacao = DateTime.now();
    TerminalDAO _terminalDAO = TerminalDAO(_hasuraBloc, appGlobalBloc, terminal: terminal);
    terminal = await _terminalDAO.saveOnServer();
    offset = 0;
    await getAllTerminal();
    await resetBloc();
  }

  deleteTerminal() async {
    terminal.ehDeletado = 1; 
    terminal.dataAtualizacao = DateTime.now();
    TerminalDAO _terminalDAO = TerminalDAO(_hasuraBloc, appGlobalBloc, terminal: terminal);
    terminal = await _terminalDAO.saveOnServer();
    await resetBloc();
  }

  deleteImpressora() async {
    terminal.terminalImpressora.first.ehDeletado = 1;
    terminalController.add(terminal);
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

  setIdDevice() async {
    terminal.idDevice = await DeviceId.getID;
  }

  updateStream() async {
    terminalController.add(terminal);
    terminalListController.add(terminalList);
  }

  resetBloc() async  {
    terminal = Terminal();
    terminalController.add(terminal);
  } 

  setMercadadopagoIDLoja(String value){
    mercadopagoIdLoja = value;
  }

  setMercadadopagoUserId(String value){
    mercadopagoUserId = value;
  }

  setMercadadopagoAccessToken(String value){
    mercadopagoAccessToken = value;
  }

  setPicpayAccessToken(String value){
    picpayAcessToken = value;
  }

   Future<List<String>> postMercadopagoTerminal() async{
     mercadopagoTerminal.name = terminal.nome;
     mercadopagoTerminal.fixedAmount = true;
     mercadopagoTerminal.category = null; 
     mercadopagoTerminal.storeId = mercadopagoIdLoja; 
     mercadopagoTerminal.externalStoreId= terminal.idPessoa.toString();
     mercadopagoTerminal.externalId = "terminal"+terminal.id.toString();
     return await mercadopagoTerminal.mercadopagoTerminalPost(mercadopagoAccessToken); 
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
