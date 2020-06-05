import 'dart:convert';
import 'dart:io';
import 'package:amazon_cognito_identity_dart/sig_v4.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

class ProdutoBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc appGlobalBloc;
  ConsultaEstoqueBloc _consultaEstoqueBloc;
  bool formInvalido = false;
  bool idInvalido = false;
  bool nomeInvalido = false;
  bool categoriaInvalida = false;
  bool gradeInvalida = false;
  bool varianteInvalida = false;
  bool precoCustoInvalido = false;
  bool precoVendaInvalido = false;
  bool codigoBarrasInvalido = false;
  bool ehServico = false;
  Color corAvatar;
  String filtroNome="";
  String filtroCodigoBarras="";
  Produto produto;
  bool novaImagem=false;
  String path;
  List<Produto> produtoList = [];
  List<PrecoTabelaItem> precoTabelaItemList = [];
  List<ProdutoVariante> produtoVarianteList = [];
  List<ProdutoImagem> produtoImagemList = [];
  List<ProdutoCodigoBarras> produtoCodigoBarrasList = [];
  List<Variante> varianteList = [];
  Color iconeCor = Colors.grey;
  PageController produtoEstoquePageController;
  double lastPageController;
  int offset = 0;
  String dateTimeProdutoImagem;

  ConfiguracaoCadastro configuracaoCadastro;
  ConfiguraoCadastroDAO _configuraoCadastroDAO;

  BehaviorSubject<bool> idAparenteInvalidoController;
  Stream<bool> get idAparenteInvalidoOut => idAparenteInvalidoController.stream;

  BehaviorSubject<bool> nomeInvalidoController;
  Stream<bool> get nomeInvalidoOut => nomeInvalidoController.stream;

  BehaviorSubject<bool> categoriaInvalidaController;
  Stream<bool> get categoriaInvalidaOut => categoriaInvalidaController.stream;

  BehaviorSubject<bool> gradeInvalidaController;
  Stream<bool> get gradeInvalidaOut => gradeInvalidaController.stream;

  BehaviorSubject<bool> varianteInvalidaController;
  Stream<bool> get varianteInvalidaOut => varianteInvalidaController.stream;

  BehaviorSubject<bool> precoVendaInvalidoController;
  Stream<bool> get precoVendaInvalidoOut => precoVendaInvalidoController.stream;

  BehaviorSubject<bool> precoCustoInvalidoController;
  Stream<bool> get precoCustoInvalidoOut => precoCustoInvalidoController.stream;

  BehaviorSubject<bool> codigoBarrasInvalidoController;
  Stream<bool> get codigoBarrasInvalidoOut => codigoBarrasInvalidoController.stream;

  BehaviorSubject<Produto> produtoController;
  Stream<Produto> get produtoOut => produtoController.stream;

  BehaviorSubject<List<Produto>> produtoListController;
  Stream<List<Produto>> get produtoListOut => produtoListController.stream;

  BehaviorSubject<List<PrecoTabelaItem>> precoTabelaItemController;
  Stream<List<PrecoTabelaItem>> get precoTabelaItemListOut => precoTabelaItemController.stream;

  BehaviorSubject<Color> corAvatarController;
  Stream<Color> get corAvatarOut => corAvatarController.stream;

  BehaviorSubject<List<ProdutoVariante>> produtoVarianteListController;
  Stream<List<ProdutoVariante>> get produtoVarianteListOut => produtoVarianteListController.stream;
  
  BehaviorSubject<List<ProdutoCodigoBarras>> produtoCodigoBarrasListController;
  Stream<List<ProdutoCodigoBarras>> get produtoCodigoBarrasListOut => produtoCodigoBarrasListController.stream;

  ProdutoBloc(this._hasuraBloc, this.appGlobalBloc, this._consultaEstoqueBloc){
    produtoController = BehaviorSubject.seeded(produto);
    produtoListController = BehaviorSubject.seeded(produtoList);
    nomeInvalidoController = BehaviorSubject.seeded(nomeInvalido);
    idAparenteInvalidoController = BehaviorSubject.seeded(idInvalido);
    precoTabelaItemController = BehaviorSubject.seeded(precoTabelaItemList);
    categoriaInvalidaController = BehaviorSubject.seeded(categoriaInvalida);
    gradeInvalidaController = BehaviorSubject.seeded(gradeInvalida);
    varianteInvalidaController = BehaviorSubject.seeded(varianteInvalida);
    precoVendaInvalidoController = BehaviorSubject.seeded(precoVendaInvalido);
    precoCustoInvalidoController = BehaviorSubject.seeded(precoCustoInvalido);
    codigoBarrasInvalidoController = BehaviorSubject.seeded(codigoBarrasInvalido);
    corAvatarController = BehaviorSubject.seeded(corAvatar);
    produtoVarianteListController = BehaviorSubject.seeded(produtoVarianteList);
    produtoCodigoBarrasListController = BehaviorSubject.seeded(produtoCodigoBarrasList);
    produtoImagemList = [];
    getConfiguracaoCadastro();
    initProdutoBloc();
  }

  initProdutoBloc() {
    ehServico = false;
  }

  getConfiguracaoCadastro() async {
    configuracaoCadastro = ConfiguracaoCadastro();
    _configuraoCadastroDAO = ConfiguraoCadastroDAO(_hasuraBloc, configuracaoCadastro, appGlobalBloc);
    List<ConfiguracaoCadastro> _configuracaoCadastroList = await _configuraoCadastroDAO.getAllFromServer(ehProdutoAutoInc: true);
    configuracaoCadastro = _configuracaoCadastroList.length > 0 ? _configuracaoCadastroList.first : ConfiguracaoCadastro();
  }

  getAllProduto() async {
    try {
      Produto _produto = Produto();
      ProdutoDAO _produtoDAO = ProdutoDAO(_hasuraBloc, appGlobalBloc, _produto);
      produtoList = offset == 0 ? [] : produtoList; 
      produtoList += await _produtoDAO.getAllFromServer(id: true, filtroNome: filtroNome, produtoImagem: true,
                                                      dataAtualizacao: true, dataCadastro: true, precoTabelaItem: true,
                                                      idAparente: true, idCategoria: true, categoria: true, iconeCor: true,
                                                      idGrade: true, idPessoaGrupo: true, precoCusto: true,
                                                      variante: true, produtoCodigoBarras: true, offset: offset,
                                                      filterProdutoServico: ehServico != null ? ehServico == true ? FilterTemServico.ehServico : FilterTemServico.naoServico : FilterTemServico.todos);
      produtoListController.add(produtoList);
      offset += queryLimit;
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<produto_bloc> getAllProduto');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "produto_bloc",
        nomeFuncao: "getAllProduto",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
      );
    }   
    return produtoList;
  } 

  getProdutoById(int id) async {
    try {
      Produto _produto = Produto();
      ProdutoDAO _produtoDAO = ProdutoDAO(_hasuraBloc, appGlobalBloc, _produto);
      produto = await _produtoDAO.getByIdFromServer(id);
      produto.produtoVariante.forEach((element) {
        if(element.ehDeletado == 0){
          varianteList.add(element.variante);
        }
      });
      produtoController.add(produto);
      produtoCodigoBarrasListController.add(produto.produtoCodigoBarras);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<produto_bloc> getProdutoById');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "produto_bloc",
        nomeFuncao: "getProdutoById",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  newProduto() async {
    try {
      produto = Produto();
      produto.nome = "";
      // precoTabelaItemList.add(PrecoTabelaItem());
      // produto.precoTabelaItem = precoTabelaItemList;
      // produto.precoTabelaItem[0].idPrecoTabela = appGlobalBloc.terminal.transacao.idPrecoTabela;
      produtoController.add(produto);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<produto_bloc> newProduto');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "produto_bloc",
        nomeFuncao: "newProduto",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  saveProduto() async  {
    try {
      ProdutoDAO _produtoDAO = ProdutoDAO(_hasuraBloc, appGlobalBloc, produto, configuracaoCadastro: configuracaoCadastro);
      produto.produtoVariante.forEach( (element) {
        compareVarianteList(variante: element.variante, array: varianteList);
      });
      varianteList.forEach((variante) {
        addVarianteToProdutoVarianteList(variante);
      });
      if (_consultaEstoqueBloc.movimentoEstoqueList.length > 0) {
        _produtoDAO.tipoAtualizacaoEstoque = _consultaEstoqueBloc.tipoAtualizacaoEstoque;
        //_produtoDAO.estoqueAtualList = _consultaEstoqueBloc.estoqueList;
        _produtoDAO.movimentoEstoqueList = _consultaEstoqueBloc.movimentoEstoqueList; 
      }  
      produto = await _produtoDAO.saveOnServer();
      // if(produto.id != null){
      //   await _produtoDAO.updateAutoInc(idPessoaGrupo: produto.idPessoaGrupo);
      // }
      if(novaImagem || ((produto.produtoImagem.length > 0) && (produto.produtoImagem.first.ehDeletado == 1))){
        await saveImagem();
      } 
      produtoList.add(produto);
      produtoListController.add(produtoList);
      offset = 0;
      await getAllProduto();
      await resetBloc();
    } catch(error, stacktrace) {
        appGlobalBloc.logger.e(error.toString(), '<produto_bloc> saveProduto');
        await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "produto_bloc",
        nomeFuncao: "saveProduto",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  saveImagem() async {
    try {
      if(produto.produtoImagem != null && produto.produtoImagem.length == 0){
        ProdutoImagem produtoImagem = ProdutoImagem(
          idProduto: produto.id,
          imagem: "/images/produto/${produto.idPessoaGrupo}/${produto.id}/${dateTimeProdutoImagem}.png",
          dataAtualizacao: DateTime.now()
        );
        ProdutoImagemDAO produtoImagemDAO = ProdutoImagemDAO(_hasuraBloc, appGlobalBloc, produtoImagem: produtoImagem);
        produtoImagemDAO.saveOnServer();
      } else {
        produto.produtoImagem[0].imagem = "/images/produto/${produto.idPessoaGrupo}/${produto.id}/${dateTimeProdutoImagem}.png";
        produto.produtoImagem[0].idProduto = produto.id;
        ProdutoImagemDAO produtoImagemDAO = ProdutoImagemDAO(_hasuraBloc, appGlobalBloc, produtoImagem: produto.produtoImagem[0]);
        produtoImagemDAO.saveOnServer();
      }
      if(produto.produtoImagem.first.ehDeletado == 0){
        await uploadImageToAmazonS3(File(path));
      } 
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<produto_bloc> saveImagem');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "produto_bloc",
        nomeFuncao: "saveImagem",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  uploadImageToAmazonS3(File imageFile) async {
    final stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    final length = await imageFile.length();
    final uri = Uri.parse(s3Endpoint);
    final req = http.MultipartRequest("POST", uri);
    final multipartFile = http.MultipartFile('file', stream, length, filename: basename(imageFile.path));
    final policy = Policy.fromS3PresignedPost('images/produto/${produto.idPessoaGrupo}/${produto.id}/${dateTimeProdutoImagem}.png','fluggy-images', accessKeyId, 15, length, region: region);
    final key = SigV4.calculateSigningKey(secretKeyId, policy.datetime, region, 's3');
    final signature = SigV4.calculateSignature(key, policy.encode()); 

    req.files.add(multipartFile);
    req.fields['key'] = policy.key;
    req.fields['acl'] = 'public-read';
    req.fields['X-Amz-Credential'] = policy.credential;
    req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
    req.fields['X-Amz-Date'] = policy.datetime;
    req.fields['Policy'] = policy.encode();
    req.fields['X-Amz-Signature'] = signature;

    try {
      final response = await req.send();
      print(response.statusCode);
      if(response.statusCode == 204){
        print("POST Efetuado com sucesso.");
        deleteImagem();
      } 
      await for (var value in response.stream.transform(utf8.decoder)) {
        print(value);
      }
    } catch (error, stacktrace) {
      print(error.toString());
      appGlobalBloc.logger.e(error.toString(), '<produto_bloc> uploadImageToAmazonS3');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "produto_bloc",
        nomeFuncao: "uploadImageToAmazonS3",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }
  }

  addImagem(String _path) async {
    try {
      novaImagem = true;
      path = _path;
      if(produto.produtoImagem.length > 0){ 
        if(produto.produtoImagem[0].idProduto != null || produto.produtoImagem[0].id != null){
          produto.produtoImagem[0].ehDeletado = 0;
          produto.produtoImagem[0].imagem = "/images/produto/${produto.idPessoaGrupo}/${produto.id}/${dateTimeProdutoImagem}.png";
        }
      } else {
        produto.produtoImagem.add(ProdutoImagem(ehDeletado: 0));
      }
      
      produtoController.add(produto);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<produto_bloc> addImagem');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "produto_bloc",
        nomeFuncao: "addImagem",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  deleteImagem() async {
    var appDir = (await getTemporaryDirectory()).path;
    Directory(appDir).delete(recursive: true);
  }

  newCodigoBarras() async {
    try {
      ProdutoCodigoBarras produtoCodigoBarras = ProdutoCodigoBarras();
      produto.produtoCodigoBarras.add(produtoCodigoBarras);
      produtoController.add(produto);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<produto_bloc> newCodigoBarras');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "produto_bloc",
        nomeFuncao: "newCodigoBarras",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  setCategoria(Categoria categoria) async{
    try {
    produto.categoria = categoria;
    produto.idCategoria = produto.categoria.id;
    validaCategoria();
    produtoController.add(produto);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<produto_bloc> setCategoria');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "produto_bloc",
        nomeFuncao: "setCategoria",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  saveVariante() async {
    try {
      ProdutoVarianteDAO _produtoVarianteDAO;
      produtoVarianteList = produto.produtoVariante;
      produtoVarianteList.forEach((elementoVarianteList) async {
        elementoVarianteList.idProduto = produto.id;
        _produtoVarianteDAO = ProdutoVarianteDAO(_hasuraBloc, appGlobalBloc, produtoVariante: elementoVarianteList);
        await _produtoVarianteDAO.saveOnServer();
      });
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<produto_bloc> saveVariante');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "produto_bloc",
        nomeFuncao: "saveVariante",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  addVarianteToProdutoVarianteList(Variante _variante) async {
    try {
      ProdutoVariante produtoVariante = ProdutoVariante();
      produtoVariante.idProduto = produto.id;
      produtoVariante.idVariante = _variante.id;
      produtoVariante.ehDeletado = 0;
      produtoVariante.dataAtualizacao = DateTime.now();
      produtoVariante.dataCadastro = _variante.dataCadastro;
      produtoVariante.variante = _variante;
      produto.produtoVariante.add(produtoVariante);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<produto_bloc> addVarianteProdutoVarianteList');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "produto_bloc",
        nomeFuncao: "addVarianteToProdutoVarianteList",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  addVarianteList(Variante _variante){
    addFromVarianteList(array: produto.produtoVariante, variante: _variante);
    varianteList.add(_variante);
  }

  removeVarianteList(Variante _variante){
    removeFromVarianteList(array: produto.produtoVariante, variante: _variante);
    varianteList.removeWhere((elemento) => elemento.nome == _variante.nome);
  }

  addFromVarianteList({Variante variante, List<ProdutoVariante> array}){
    for(var i=0; i < array.length; i++){
      if(array[i].variante.nome == variante.nome){
        array[i].ehDeletado = 0;
        return true;
      }
    }
    return false;
  }

  removeFromVarianteList({Variante variante, List<ProdutoVariante> array}){
    for(var i=0; i < array.length; i++){
      if(array[i].variante.nome == variante.nome){
        array[i].ehDeletado = 1;
        return true;
      }
    }
    return false;
  }

  compareVarianteList({Variante variante, List<Variante> array}){
    for(var i=0; i < array.length; i++){
      if(array[i].id == variante.id){
        array.removeAt(i);
      }
    }
  }

  updateProdutoStream(){
    produtoController.add(produto);
  }

  setGrade(Grade grade) {
    produto.grade = grade;
    produto.idGrade = produto.grade.id;
    validaGrade();
    produtoController.add(produto);
  }
  
  deleteGrade(){
    produto.grade = null;
    produto.idGrade = null;
    produtoController.add(produto);
  }

  deleteProduto() async {
    try {
      produto.ehdeletado = 1;
      produto.dataAtualizacao = DateTime.now();
      ProdutoDAO _produtoDAO = ProdutoDAO(_hasuraBloc, appGlobalBloc, produto);
      produto = await _produtoDAO.saveOnServer();
      await resetBloc();
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<produto_bloc> deleteProduto');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "produto_bloc",
        nomeFuncao: "deleteProduto",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  validaNome() {
    nomeInvalido = produto.nome == "" ? true : false;
    formInvalido = !formInvalido ? nomeInvalido : formInvalido;
    nomeInvalidoController.add(nomeInvalido);
  }

  validaCategoria() async {
    categoriaInvalida = produto.categoria.id == null || produto.categoria.id == 0 ? true : false;
    formInvalido = !formInvalido ? categoriaInvalida : formInvalido;
    categoriaInvalidaController.add(categoriaInvalida);
  }

  validaGrade() async {
    gradeInvalida = produto.grade.id == null || produto.grade.id == 0 ? true : false;
    formInvalido = !formInvalido ? gradeInvalida : formInvalido;
    gradeInvalidaController.add(gradeInvalida);
  }

  validaVariante() async {
    varianteInvalida = produto.produtoVariante == null || produto.produtoVariante.first.id == 0 ? true : false;
    formInvalido = !formInvalido ? varianteInvalida : formInvalido;
    varianteInvalidaController.add(varianteInvalida);
  }

  validaPrecoVenda() async {
    precoVendaInvalido = produto.precoTabelaItem.first.preco == 0 ? true : false;
    formInvalido = !formInvalido ? precoVendaInvalido : formInvalido;
    precoVendaInvalidoController.add(precoVendaInvalido);
  }

  validaPrecoCusto() async {
    precoCustoInvalido = produto.precoCusto == null || produto.precoCusto.isNaN ? true : false;
    formInvalido = !formInvalido ? precoCustoInvalido : formInvalido;
    precoCustoInvalidoController.add(precoCustoInvalido);
  }

  validaIdAparente() async {
    idInvalido = produto.idAparente == "" ? true : false;
    formInvalido = !formInvalido ? idInvalido : formInvalido;
    idAparenteInvalidoController.add(idInvalido);
  }

  validaCodigoBarras() async {
    if ((produto.produtoCodigoBarras.length > 0) && (produto.produtoCodigoBarras[0].codigoBarras != "")) {
      ProdutoCodigoBarras _produtoCodigoBarras = ProdutoCodigoBarras();
      ProdutoCodigoBarrasDAO _produtoCodigoBarrasDAO = ProdutoCodigoBarrasDAO(_hasuraBloc, appGlobalBloc, produtoCodigoBarras: _produtoCodigoBarras);
      List<ProdutoCodigoBarras> _produtoCodigoBarrasList = [];
      _produtoCodigoBarrasList = await _produtoCodigoBarrasDAO.getAllFromServer(
                                                                 id: true, 
                                                                 codigoBarras: true,
                                                                 filterCodigoBarras: produto.produtoCodigoBarras[0].codigoBarras,
                                                                 filterProdutoDiferente: produto.id != null ? produto.id : 0
                                                                );
      codigoBarrasInvalido = _produtoCodigoBarrasList != null && _produtoCodigoBarrasList.length > 0;
    } else {
      codigoBarrasInvalido = false;
    }
    formInvalido = !formInvalido ? codigoBarrasInvalido : formInvalido;
    codigoBarrasInvalidoController.add(codigoBarrasInvalido);
  }

  setTemServico() async {
    produto.ehservico = 1;
    produtoController.add(produto);
  }

  limpaValidacoes(){
    varianteList = [];
    nomeInvalido = false;
    categoriaInvalida = false;
    precoVendaInvalido = false;
    codigoBarrasInvalido = false;
    nomeInvalidoController.add(nomeInvalido);
    categoriaInvalidaController.add(categoriaInvalida);
    precoVendaInvalidoController.add(precoVendaInvalido);
    codigoBarrasInvalidoController.add(codigoBarrasInvalido);
  }

  validaCampos() async {
    await validaNome();
    await validaCategoria();
    await validaIdAparente();
    await validaPrecoCusto();
    await validaPrecoVenda();
    await validaCodigoBarras();
  }

  resetBloc() async  {
    try {
      produto = Produto();
      precoTabelaItemList.clear();
      novaImagem = false;
      produtoController.add(produto);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<produto_bloc> resetBloc');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "produto_bloc",
        nomeFuncao: "resetBloc",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  @override
  void dispose() {
    produtoController.close();
    nomeInvalidoController.close();
    idAparenteInvalidoController.close();
    categoriaInvalidaController.close();
    gradeInvalidaController.close();
    varianteInvalidaController.close();
    produtoListController.close();
    precoTabelaItemController.close();
    precoVendaInvalidoController.close();
    precoCustoInvalidoController.close();
    codigoBarrasInvalidoController.close();
    corAvatarController.close();
    produtoVarianteListController.close();
    produtoCodigoBarrasListController.close();
    super.dispose();
  }
}