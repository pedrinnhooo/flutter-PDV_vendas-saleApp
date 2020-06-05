import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:common_files/common_files.dart';

class CategoriaBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  String filtroNome="";
  
  Categoria categoria;
  CategoriaDAO categoriaDAO;
  List<Categoria> categoriaList = [];
  BehaviorSubject<Categoria> categoriaController;
  Observable<Categoria> get categoriaOut => categoriaController.stream;
  BehaviorSubject<List<Categoria>> categoriaListController;
  Observable<List<Categoria>> get categoriaListOut => categoriaListController.stream;

  bool formInvalido = false;

  bool nomeInvalido = false;
  BehaviorSubject<bool> nomeInvalidoController;
  Observable<bool> get nomeInvalidoOut => nomeInvalidoController.stream;

  CategoriaBloc(this._hasuraBloc) {
    categoria = Categoria();
    categoriaDAO = CategoriaDAO(_hasuraBloc, categoria: categoria);
    categoriaController = BehaviorSubject.seeded(categoria);
    categoriaListController = BehaviorSubject.seeded(categoriaList);
    nomeInvalidoController = BehaviorSubject.seeded(nomeInvalido);
  }

  getAllCategoria() async {
    Categoria _categoria = Categoria();
    CategoriaDAO _categoriaDAO = CategoriaDAO(_hasuraBloc, categoria: _categoria);
    categoriaList = await _categoriaDAO.getAllFromServer(id: true, filtroNome: filtroNome);
    categoriaListController.add(categoriaList);
  } 

  getCategoriaById(int id) async {
    Categoria _categoria = Categoria();
    CategoriaDAO _categoriaDAO = CategoriaDAO(_hasuraBloc, categoria: _categoria);
    categoria = await _categoriaDAO.getByIdFromServer(id);
    categoriaController.add(categoria);
  }

  newCategoria() async {
    categoria = Categoria();
    categoria.nome = "";
    categoriaController.add(categoria);
  }

  saveCategoria() async  {
    categoria.dataCadastro = categoria.dataCadastro == null ? DateTime.now() : categoria.dataCadastro;
    categoria.dataAtualizacao = DateTime.now();
    CategoriaDAO _categoriaDAO = CategoriaDAO(_hasuraBloc, categoria: categoria);
    categoria = await _categoriaDAO.saveOnServer();
    await getAllCategoria();
    await resetBloc();
  }

  deleteCategoria() async {
    categoria.ehDeletado = 1; 
    categoria.dataAtualizacao = DateTime.now();
    CategoriaDAO _categoriaDAO = CategoriaDAO(_hasuraBloc, categoria: categoria);
    categoria = await _categoriaDAO.saveOnServer();
    await resetBloc();
  }

  validaNome() {
    nomeInvalido = categoria.nome == "" ? true : false;
    formInvalido = nomeInvalido;
    nomeInvalidoController.add(nomeInvalido);
  }

  limpaValidacoes(){
    nomeInvalido = false;
    nomeInvalidoController.add(nomeInvalido);
  }

  resetBloc() async  {
    categoria = Categoria();
    categoriaController.add(categoria);
  }

  @override
  void dispose() {
    categoriaController.close();
    categoriaListController.close();
    nomeInvalidoController.close();
    super.dispose();
  }
}
