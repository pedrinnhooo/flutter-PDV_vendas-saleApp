import 'dart:convert';
import 'dart:io';

import 'package:amazon_cognito_identity_dart/sig_v4.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:common_files/src/model/entities/cadastro/preco_tabela/preco_tabela_item.dart';
import 'package:common_files/src/model/entities/cadastro/produto/produto.dart';
import 'package:common_files/src/model/entities/cadastro/produto/produtoDao.dart';
import 'package:common_files/src/model/entities/cadastro/produto/produto_variante.dart';
import 'package:common_files/src/model/entities/cadastro/produto/produto_varianteDao.dart';
import 'package:common_files/src/model/entities/cadastro/produto_imagem/produto_imagem.dart';
import 'package:common_files/src/model/entities/cadastro/produto_imagem/produto_imagemDao.dart';
import 'package:common_files/src/model/entities/cadastro/variante/variante.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

class ProdutoBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  bool formInvalido = false;
  bool idInvalido = false;
  bool nomeInvalido = false;
  bool categoriaInvalida = false;
  bool gradeInvalida = false;
  bool varianteInvalida = false;
  bool precoCustoInvalido = false;
  bool precoVendaInvalido = false;
  Color corAvatar;
  String filtroNome="";
  Produto produto;
  bool novaImagem=false;
  String path;
  List<Produto> produtoList;
  List<PrecoTabelaItem> precoTabelaItemList = [];
  List<ProdutoVariante> produtoVarianteList = [];
  List<ProdutoImagem> produtoImagemList = [];
  List<Variante> varianteList = [];
  Color iconeCor = Colors.grey;

  BehaviorSubject<bool> idAparenteInvalidoController;
  Observable<bool> get idAparenteInvalidoOut => idAparenteInvalidoController.stream;

  BehaviorSubject<bool> nomeInvalidoController;
  Observable<bool> get nomeInvalidoOut => nomeInvalidoController.stream;

  BehaviorSubject<bool> categoriaInvalidaController;
  Observable<bool> get categoriaInvalidaOut => categoriaInvalidaController.stream;

  BehaviorSubject<bool> gradeInvalidaController;
  Observable<bool> get gradeInvalidaOut => gradeInvalidaController.stream;

  BehaviorSubject<bool> varianteInvalidaController;
  Observable<bool> get varianteInvalidaOut => varianteInvalidaController.stream;

  BehaviorSubject<bool> precoVendaInvalidoController;
  Observable<bool> get precoVendaInvalidoOut => precoVendaInvalidoController.stream;

  BehaviorSubject<bool> precoCustoInvalidoController;
  Observable<bool> get precoCustoInvalidoOut => precoCustoInvalidoController.stream;

  BehaviorSubject<Produto> produtoController;
  Observable<Produto> get produtoOut => produtoController.stream;

  BehaviorSubject<List<Produto>> produtoListController;
  Observable<List<Produto>> get produtoListOut => produtoListController.stream;

  BehaviorSubject<List<PrecoTabelaItem>> precoTabelaItemController;
  Observable<List<PrecoTabelaItem>> get precoTabelaItemListOut => precoTabelaItemController.stream;

  BehaviorSubject<Color> corAvatarController;
  Observable<Color> get corAvatarOut => corAvatarController.stream;

  BehaviorSubject<List<ProdutoVariante>> produtoVarianteListController;
  Observable<List<ProdutoVariante>> get produtoVarianteListOut => produtoVarianteListController.stream;
  
  ProdutoBloc(this._hasuraBloc){
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
    corAvatarController = BehaviorSubject.seeded(corAvatar);
    produtoVarianteListController = BehaviorSubject.seeded(produtoVarianteList);
  }

  getAllProduto() async {
    Produto _produto = Produto();
    ProdutoDAO _produtoDAO = ProdutoDAO(_hasuraBloc, _produto);
    produtoList = await _produtoDAO.getAllFromServer(id: true, filtroNome: filtroNome, 
                                                    dataAtualizacao: true, dataCadastro: true, 
                                                    idAparente: true, idCategoria: true,
                                                    idGrade: true, idPessoaGrupo: true,
                                                    variante: true);
    produtoListController.add(produtoList);
  } 

  getProdutoById(int id) async {
    Produto _produto = Produto();
    ProdutoDAO _produtoDAO = ProdutoDAO(_hasuraBloc, _produto);
    produto = await _produtoDAO.getByIdFromServer(id);
    produto.produtoVariante.forEach( (element) {
      if(element.ehDeletado == 0){
        varianteList.add(element.variante);
      }
    });
    produtoController.add(produto);
  }

  newProduto() async {
    produto = Produto();
    ProdutoDAO _produtoDAO = ProdutoDAO(_hasuraBloc, produto);
    produto.nome = "";
//    produto.idAparente = await _produtoDAO.getAutoIncFromServer(idPessoaGrupo: produto.idPessoaGrupo);
    produtoController.add(produto);
  }

  saveProduto() async  {
    produto.dataCadastro = produto.dataCadastro == null ? DateTime.now() : produto.dataCadastro;
    produto.dataAtualizacao = DateTime.now();
    ProdutoDAO _produtoDAO = ProdutoDAO(_hasuraBloc, produto);
    produto.produtoVariante.forEach( (element) {
      compareVarianteList(variante: element.variante, array: varianteList);
    });
    varianteList.forEach((variante) {
      addVarianteToProdutoVarianteList(variante);
    });   
    produto = await _produtoDAO.saveOnServer();
    // if(produto.id != null){
    //   await _produtoDAO.updateAutoInc(idPessoaGrupo: produto.idPessoaGrupo);
    // }
    await saveVariante();
    if(novaImagem){
      await saveImagem();
    } 
    produtoList.add(produto);
    produtoListController.add(produtoList);
    await getAllProduto();
    await resetBloc();
  }

  saveImagem() async {
    produtoImagemList[0].idProduto = produto.id;
    produtoImagemList[0].dataAtualizacao = DateTime.now();
    produtoImagemList[0].dataCadastro = DateTime.now();
    produto.produtoImagem = produtoImagemList;
    ProdutoImagemDAO produtoImagemDAO;
    produto.produtoImagem.forEach((produtoImagemElement) {
      produtoImagemDAO = ProdutoImagemDAO(_hasuraBloc, produtoImagem: produtoImagemElement);
      produtoImagemDAO.saveOnServer();
    });
    produtoImagemDAO.saveOnServer();
    await uploadImageToAmazonS3(File(produtoImagemList[0].imagem));
  }

  uploadImageToAmazonS3(File imageFile) async {
    final stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    final length = await imageFile.length();
    final uri = Uri.parse(s3Endpoint);
    final req = http.MultipartRequest("POST", uri);
    final multipartFile = http.MultipartFile('file', stream, length, filename: basename(imageFile.path));
    final policy = Policy.fromS3PresignedPost('images/produto/${produto.idPessoaGrupo}/${produto.id}.png','fluggy-images', accessKeyId, 15, length, region: region);
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
    } catch (e) {
      print(e.toString());
    }
  }

  setImagem(String _path) async {
    novaImagem = true;
    path = _path;
    produtoImagemList.add(
      ProdutoImagem(
        imagem: _path
      )
    );
    produto.produtoImagem = produtoImagemList;
  }

  deleteImagem() async {
    var appDir = (await getTemporaryDirectory()).path;
    Directory(appDir).delete(recursive: true);
  }

  setCategoria(Categoria categoria) async{
    produto.categoria = categoria;
    produto.idCategoria = produto.categoria.id;
    validaCategoria();
    produtoController.add(produto);
  }

  saveVariante() async {
    ProdutoVarianteDAO _produtoVarianteDAO;
    produtoVarianteList = produto.produtoVariante;
    produtoVarianteList.forEach((elementoVarianteList) async {
      elementoVarianteList.idProduto = produto.id;
      _produtoVarianteDAO = ProdutoVarianteDAO(_hasuraBloc, produtoVariante: elementoVarianteList);
      await _produtoVarianteDAO.saveOnServer();
    });
  }

  addVarianteToProdutoVarianteList(Variante _variante) async {
    ProdutoVariante produtoVariante = ProdutoVariante();
    produtoVariante.idProduto = produto.id;
    produtoVariante.idVariante = _variante.id;
    produtoVariante.ehDeletado = 0;
    produtoVariante.dataAtualizacao = DateTime.now();
    produtoVariante.dataCadastro = _variante.dataCadastro;
    produtoVariante.variante = _variante;
    produto.produtoVariante.add(produtoVariante);
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

  deleteProduto() async {
    produto.ehativo = 0;
    produto.dataAtualizacao = DateTime.now();
    ProdutoDAO _produtoDAO = ProdutoDAO(_hasuraBloc, produto);
    produto = await _produtoDAO.saveOnServer();
    await resetBloc();
  }

  validaNome() {
    nomeInvalido = produto.nome == "" ? true : false;
    formInvalido = nomeInvalido;
    nomeInvalidoController.add(nomeInvalido);
  }

  validaCategoria() async {
    categoriaInvalida = produto.categoria.id == null || produto.categoria.id == 0 ? true : false;
    formInvalido = categoriaInvalida;
    categoriaInvalidaController.add(categoriaInvalida);
  }

  validaGrade() async {
    gradeInvalida = produto.grade.id == null || produto.grade.id == 0 ? true : false;
    formInvalido = gradeInvalida;
    varianteInvalidaController.add(gradeInvalida);
  }

  validaVariante() async {
    varianteInvalida = produto.produtoVariante == null || produto.produtoVariante.first.id == 0 ? true : false;
    formInvalido = varianteInvalida;
    varianteInvalidaController.add(varianteInvalida);
  }

  validaPrecoVenda() async {
    precoVendaInvalido = produto.precoTabelaItem == null || produto.precoTabelaItem.id == 0 ? true : false;
    formInvalido = precoVendaInvalido;
    varianteInvalidaController.add(precoVendaInvalido);
  }

  validaPrecoCusto() async {
    precoCustoInvalido = produto.precoCusto == null || produto.precoCusto.isNaN ? true : false;
    formInvalido = precoCustoInvalido;
    varianteInvalidaController.add(precoCustoInvalido);
  }

  validaIdAparente() async {
    idInvalido = produto.idAparente == "" ? true : false;
    formInvalido = idInvalido;
    varianteInvalidaController.add(idInvalido);
  }

  limpaValidacoes(){
    varianteList = [];
    nomeInvalido = false;
    categoriaInvalida = false;
    precoVendaInvalido = false;
    nomeInvalidoController.add(nomeInvalido);
    categoriaInvalidaController.add(categoriaInvalida);
    precoVendaInvalidoController.add(precoVendaInvalido);
  }

  validaCampos(){
    validaNome();
    validaCategoria();
    validaIdAparente();
    validaPrecoCusto();
    validaPrecoVenda();
  }

  resetBloc() async  {
    produto = Produto();
    produtoController.add(produto);
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
    corAvatarController.close();
    produtoVarianteListController.close();
    super.dispose();
  }
}