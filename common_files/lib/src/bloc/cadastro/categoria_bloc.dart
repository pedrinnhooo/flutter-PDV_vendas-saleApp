import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:common_files/common_files.dart';

class CategoriaBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc appGlobalBloc;
  String filtroNome="";
  bool ehServico;
  Categoria categoria;
  CategoriaDAO categoriaDAO;
  List<Categoria> categoriaList = [];
  BehaviorSubject<Categoria> categoriaController;
  Stream<Categoria> get categoriaOut => categoriaController.stream;
  BehaviorSubject<List<Categoria>> categoriaListController;
  Stream<List<Categoria>> get categoriaListOut => categoriaListController.stream;
  int offset = 0;
  bool formInvalido = false;
  bool nomeInvalido = false;
  BehaviorSubject<bool> nomeInvalidoController;
  Stream<bool> get nomeInvalidoOut => nomeInvalidoController.stream;

  CategoriaBloc(this._hasuraBloc, this.appGlobalBloc) {
    categoria = Categoria();
    categoriaDAO = CategoriaDAO(_hasuraBloc, appGlobalBloc, categoria: categoria);
    categoriaController = BehaviorSubject.seeded(categoria);
    categoriaListController = BehaviorSubject.seeded(categoriaList);
    nomeInvalidoController = BehaviorSubject.seeded(nomeInvalido);
  }

  initCategoriaBloc() {
    ehServico = false;
  }

  getAllCategoria() async {
    Categoria _categoria = Categoria();
    CategoriaDAO _categoriaDAO = CategoriaDAO(_hasuraBloc, appGlobalBloc, categoria: _categoria);
    categoriaList = offset == 0 ? [] : categoriaList; 
    categoriaList += await _categoriaDAO.getAllFromServer(id: true, filtroNome: filtroNome, offset: offset,
      filterCategoriaServico: ehServico != null ? ehServico == true ? FilterTemServico.ehServico : FilterTemServico.naoServico : FilterTemServico.todos);
    categoriaListController.add(categoriaList);
    offset += queryLimit;
    return categoriaList;
  }
  
  getCategoriaById(int id) async {
    Categoria _categoria = Categoria();
    CategoriaDAO _categoriaDAO = CategoriaDAO(_hasuraBloc, appGlobalBloc, categoria: _categoria);
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
    CategoriaDAO _categoriaDAO = CategoriaDAO(_hasuraBloc, appGlobalBloc, categoria: categoria);
    categoria = await _categoriaDAO.saveOnServer();
    offset = 0;
    await getAllCategoria();
    await resetBloc();
  }

  deleteCategoria() async {
    categoria.ehDeletado = 1; 
    categoria.dataAtualizacao = DateTime.now();
    CategoriaDAO _categoriaDAO = CategoriaDAO(_hasuraBloc, appGlobalBloc, categoria: categoria);
    categoria = await _categoriaDAO.saveOnServer();
    await resetBloc();
  }

  setTemServico(bool value) async {
    categoria.ehServico = value ? 1 : 0;
    categoriaController.add(categoria);
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
