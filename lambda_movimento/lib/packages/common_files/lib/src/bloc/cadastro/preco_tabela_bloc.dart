import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/src/bloc/hasura_bloc.dart';
import 'package:common_files/src/model/entities/cadastro/preco_tabela/preco_tabela.dart';
import 'package:common_files/src/model/entities/cadastro/preco_tabela/preco_tabelaDao.dart';
import 'package:rxdart/rxdart.dart';

class PrecoTabelaBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  String filtroNome="";
  
  PrecoTabela precoTabela;
  PrecoTabelaDAO precoTabelaDAO;
  List<PrecoTabela> precoTabelaList = [];
  BehaviorSubject<PrecoTabela> precoTabelaController;
  Observable<PrecoTabela> get precoTabelaOut => precoTabelaController.stream;
  BehaviorSubject<List<PrecoTabela>> precoTabelaListController;
  Observable<List<PrecoTabela>> get precoTabelaListOut => precoTabelaListController.stream;

  bool formInvalido = false;

  bool nomeInvalido = false;
  BehaviorSubject<bool> nomeInvalidoController;
  Observable<bool> get nomeInvalidoOut => nomeInvalidoController.stream;

  PrecoTabelaBloc(this._hasuraBloc) {
    precoTabela = PrecoTabela();
    precoTabelaDAO = PrecoTabelaDAO(_hasuraBloc, precoTabela);
    precoTabelaController = BehaviorSubject.seeded(precoTabela);
    precoTabelaListController = BehaviorSubject.seeded(precoTabelaList);
    nomeInvalidoController = BehaviorSubject.seeded(nomeInvalido);
  }

  getAllPrecoTabela() async {
    PrecoTabela _precoTabela = PrecoTabela();
    PrecoTabelaDAO _precoTabelaDAO = PrecoTabelaDAO(_hasuraBloc, _precoTabela);
    precoTabelaList = await _precoTabelaDAO.getAllFromServer(id: true, filtroNome: filtroNome);
    precoTabelaListController.add(precoTabelaList);
  } 

  getPrecoTabelaById(int id) async {
    PrecoTabela _precoTabela = PrecoTabela();
    PrecoTabelaDAO _precoTabelaDAO = PrecoTabelaDAO(_hasuraBloc, _precoTabela);
    precoTabela = await _precoTabelaDAO.getByIdFromServer(id);
    precoTabelaController.add(precoTabela);
  }

  newPrecoTabela() async {
    precoTabela = PrecoTabela();
    precoTabela.nome = "";
    precoTabelaController.add(precoTabela);
  }

  savePrecoTabela() async  {
    precoTabela.dataCadastro = precoTabela.dataCadastro == null ? DateTime.now() : precoTabela.dataCadastro;
    precoTabela.dataAtualizacao = DateTime.now();
    PrecoTabelaDAO _precoTabelaDAO = PrecoTabelaDAO(_hasuraBloc, precoTabela);
    precoTabela = await _precoTabelaDAO.saveOnServer();
    await getAllPrecoTabela();
    await resetBloc();
  }

  deletePrecoTabela() async {
    precoTabela.ehDeletado = 1; 
    precoTabela.dataAtualizacao = DateTime.now();
    PrecoTabelaDAO _precoTabelaDAO = PrecoTabelaDAO(_hasuraBloc, precoTabela);
    precoTabela = await _precoTabelaDAO.saveOnServer();
    await resetBloc();
  }

  validaNome() {
    nomeInvalido = precoTabela.nome == "" ? true : false;
    formInvalido = nomeInvalido;
    nomeInvalidoController.add(nomeInvalido);
  }

  limpaValidacoes(){
    nomeInvalido = false;
    nomeInvalidoController.add(nomeInvalido);
  }

  resetBloc() async  {
    precoTabela = PrecoTabela();
    precoTabelaController.add(precoTabela);
  }

  @override
  void dispose() {
    precoTabelaController.close();
    precoTabelaListController.close();
    nomeInvalidoController.close();
    super.dispose();
  }
}
