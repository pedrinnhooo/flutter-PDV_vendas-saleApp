import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/src/bloc/hasura_bloc.dart';
import 'package:common_files/src/model/entities/cadastro/preco_tabela/preco_tabela.dart';
import 'package:common_files/src/model/entities/configuracao/transacao/transacao.dart';
import 'package:common_files/src/model/entities/configuracao/transacao/transacaoDao.dart';
import 'package:rxdart/rxdart.dart';

class TransacaoBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  String filtroNome="";
  
  Transacao transacao;
  TransacaoDAO transacaoDAO;
  List<Transacao> transacaoList = [];
  BehaviorSubject<Transacao> transacaoController;
  Observable<Transacao> get transacaoOut => transacaoController.stream;
  BehaviorSubject<List<Transacao>> transacaoListController;
  Observable<List<Transacao>> get transacaoListOut => transacaoListController.stream;

  bool formInvalido = false;

  bool nomeInvalido = false;
  BehaviorSubject<bool> nomeInvalidoController;
  Observable<bool> get nomeInvalidoOut => nomeInvalidoController.stream;

  bool precoTabelaInvalido = false;
  BehaviorSubject<bool> precoTabelaInvalidoController;
  Observable<bool> get precoTabelaInvalidoOut => precoTabelaInvalidoController.stream;

  TransacaoBloc(this._hasuraBloc) {
    transacao = Transacao();
    transacaoDAO = TransacaoDAO(_hasuraBloc, transacao);
    transacaoController = BehaviorSubject.seeded(transacao);
    transacaoListController = BehaviorSubject.seeded(transacaoList);
    nomeInvalidoController = BehaviorSubject.seeded(nomeInvalido);
    precoTabelaInvalidoController = BehaviorSubject.seeded(precoTabelaInvalido);
  }

  getAllTransacao() async {
    Transacao _transacao = Transacao();
    TransacaoDAO _transacaoDAO = TransacaoDAO(_hasuraBloc, _transacao);
    transacaoList = await _transacaoDAO.getAllFromServer(id: true, filtroNome: filtroNome);
    transacaoListController.add(transacaoList);
  } 

  getTransacaoById(int id) async {
    Transacao _transacao = Transacao();
    TransacaoDAO _transacaoDAO = TransacaoDAO(_hasuraBloc, _transacao);
    transacao = await _transacaoDAO.getByIdFromServer(id);
    transacaoController.add(transacao);
  }

  newTransacao() async {
    transacao = Transacao();
    transacao.nome = "";
    transacaoController.add(transacao);
  }

  saveTransacao() async  {
    transacao.dataCadastro = transacao.dataCadastro == null ? DateTime.now() : transacao.dataCadastro;
    transacao.dataAtualizacao = DateTime.now();
    TransacaoDAO _transacaoDAO = TransacaoDAO(_hasuraBloc, transacao);
    transacao = await _transacaoDAO.saveOnServer();
    await getAllTransacao();
    await resetBloc();
  }

  deleteTransacao() async {
    transacao.ehDeletado = 1; 
    transacao.dataAtualizacao = DateTime.now();
    TransacaoDAO _transacaoDAO = TransacaoDAO(_hasuraBloc, transacao);
    transacao = await _transacaoDAO.saveOnServer();
    await resetBloc();
  }

  setTipoEstoque(int value) async {
    transacao.tipoEstoque = value;
    transacaoController.add(transacao);
  }

  setTemPagamento(bool value) async {
    transacao.temPagamento = value ? 1 : 0;
    transacaoController.add(transacao);
  }

  setTemVendedor(bool value) async {
    transacao.temVendedor = value ? 1 : 0;
    transacaoController.add(transacao);
  }

  setTemCliente(bool value) async {
    transacao.temCliente = value ? 1 : 0;
    transacaoController.add(transacao);
  }

  setDesconto(String value) async {
    transacao.descontoPercentual = double.parse(value);
    transacaoController.add(transacao);
  }

  setTabelaPreco(PrecoTabela value) async {
    transacao.precoTabela = value;
    transacao.idPrecoTabela = transacao.precoTabela.id;
    validaPrecoTabela();
    transacaoController.add(transacao);
  }

  validaNome() async {
    nomeInvalido = transacao.nome == "" ? true : false;
    formInvalido = nomeInvalido;
    nomeInvalidoController.add(nomeInvalido);
  }

  validaPrecoTabela() async {
    precoTabelaInvalido = transacao.precoTabela.id == null || transacao.precoTabela.id == 0 ? true : false;
    formInvalido = precoTabelaInvalido;
    precoTabelaInvalidoController.add(precoTabelaInvalido);
  }

  validaForm() async {
    await validaNome(); 
    await validaPrecoTabela();   
  }

  limpaValidacoes(){
    nomeInvalido = false;
    nomeInvalidoController.add(nomeInvalido);
    precoTabelaInvalido = false;
    precoTabelaInvalidoController.add(precoTabelaInvalido);
  }

  resetBloc() async  {
    transacao = Transacao();
//    precoTabela = PrecoTabela();
    transacaoController.add(transacao);
    //precoTabelaController.add(precoTabela);
  }

  updateStream() async {
    transacaoController.add(transacao);
  }

  @override
  void dispose() {
    transacaoController.close();
    transacaoListController.close();
    nomeInvalidoController.close();
    precoTabelaInvalidoController.close();
    super.dispose();
  }
}
