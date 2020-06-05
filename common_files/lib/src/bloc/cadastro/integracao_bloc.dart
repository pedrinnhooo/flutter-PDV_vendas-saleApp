import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../../../common_files.dart';

class IntegracaoBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  PageController pageController = PageController();
  String filtroAcessToken="";
  Integracao integracao;
  MercadopagoLoja mercadopagoLoja;
  MercadopagoTerminal mercadopagoTerminal;
  MercadopagoOrdemPagamento mercadopagoOrdemPagamento;
  Terminal terminal;
  IntegracaoDAO integracaoDAO;
  List<Integracao> integracaoList = [];
  BehaviorSubject<Integracao> integracaoController;
  Stream<Integracao> get integracaoOut => integracaoController.stream;
  BehaviorSubject<List<Integracao>> integracaoListController;
  Stream<List<Integracao>> get integracaoListOut => integracaoListController.stream;
  int offset = 0;
  bool formInvalido = false; 
  bool acessTokenInvalido = false;
  BehaviorSubject<bool> acessTokenInvalidoController;
  Stream<bool> get acessTokenInvalidoOut => acessTokenInvalidoController.stream;

  bool userIdInvalido = false;
  BehaviorSubject<bool> userIdInvalidoController;
  Stream<bool> get userIdInvalidoOut => userIdInvalidoController.stream;

  IntegracaoBloc(this._hasuraBloc, this._appGlobalBloc) {
    integracao = Integracao();
    integracaoDAO = IntegracaoDAO(_hasuraBloc, _appGlobalBloc, integracao: integracao);
    mercadopagoLoja = MercadopagoLoja();
    mercadopagoOrdemPagamento = MercadopagoOrdemPagamento(
      items : [Items()]
    );
    mercadopagoTerminal = MercadopagoTerminal();
    terminal = Terminal();
    integracaoController = BehaviorSubject.seeded(integracao);
    integracaoListController = BehaviorSubject.seeded(integracaoList);
    acessTokenInvalidoController = BehaviorSubject.seeded(acessTokenInvalido);
    userIdInvalidoController = BehaviorSubject.seeded(userIdInvalido);
  }

  getAllIntegracao() async {
    Integracao _integracao = Integracao();
    IntegracaoDAO _integracaoDAO = IntegracaoDAO(_hasuraBloc, _appGlobalBloc, integracao: _integracao);
    integracaoList = offset == 0 ? [] : integracaoList; 
    integracaoList += await _integracaoDAO.getAllFromServer(id: true, filtroAcessToken :filtroAcessToken , offset: offset,);
    integracaoListController.add(integracaoList);
    offset += queryLimit;
    return integracaoList;
  }
  
  getintegracaoById(int id) async {
    Integracao _integracao = Integracao();
    IntegracaoDAO _integracaoDAO = IntegracaoDAO(_hasuraBloc, _appGlobalBloc, integracao: _integracao);
    integracao = await _integracaoDAO.getByIdFromServer(id);
    integracaoController.add(integracao);
  }

  getintegracaoByIdMercadopago(int idPessoa) async {
    Integracao _integracao = Integracao();
    IntegracaoDAO _integracaoDAO = IntegracaoDAO(_hasuraBloc, _appGlobalBloc, integracao: _integracao);
    integracao = await _integracaoDAO.getByIdFromServerMercadopado(_appGlobalBloc.loja.idPessoa);
    integracaoController.add(integracao);
  }

  getIntegracaoByIdPessoa(int idPessoa) async {
    Integracao _integracao = Integracao();
    IntegracaoDAO _integracaoDAO = IntegracaoDAO(_hasuraBloc, _appGlobalBloc, integracao: _integracao);
    integracao = await _integracaoDAO.getByIdFromServer(_appGlobalBloc.loja.idPessoa);
    integracaoController.add(integracao);
  }

  newIntegracao() async {
    integracao = Integracao();
    integracao.mercadopagoAcessToken = "";
    integracao.picpayAcessToken = "";
    integracaoController.add(integracao);
  }

  saveIntegracao() async  {
    integracao.dataCadastro = integracao.dataCadastro == null ? DateTime.now() : integracao.dataCadastro;
    integracao.dataAtualizacao = DateTime.now();
    IntegracaoDAO _integracaoDAO = IntegracaoDAO(_hasuraBloc, _appGlobalBloc, integracao: integracao);
    integracao = await _integracaoDAO.saveOnServer();
    offset = 0;
    await getAllIntegracao();
    await resetBloc();
  }

  deleteIntegracao() async {
    integracao.ehDeletado = 1; 
    integracao.dataAtualizacao = DateTime.now();
    IntegracaoDAO _integracaoDAO = IntegracaoDAO(_hasuraBloc, _appGlobalBloc, integracao: integracao);
    integracao = await _integracaoDAO.saveOnServer();
    await resetBloc();
  }

  validaMercadopagoAcessToken() {
    acessTokenInvalido = integracao.mercadopagoAcessToken == "" || integracao.mercadopagoAcessToken == null ? true : false;
    formInvalido = acessTokenInvalido;
    acessTokenInvalidoController.add(acessTokenInvalido);
  }

  validaPicpayAcessToken() {
    acessTokenInvalido = integracao.picpayAcessToken == "" || integracao.picpayAcessToken == null ? true : false;
    formInvalido = acessTokenInvalido;
    acessTokenInvalidoController.add(acessTokenInvalido);
  }

  validaUserID() {
    userIdInvalido = integracao.mercadopagoUserId == ""  || integracao.mercadopagoUserId == null? true : false;
    formInvalido = !formInvalido ? userIdInvalido : formInvalido;
    userIdInvalidoController.add(userIdInvalido);
  }

  limpaValidacoes(){
    acessTokenInvalido = false;
    acessTokenInvalidoController.add(acessTokenInvalido);

    userIdInvalido = false;
    userIdInvalidoController.add(userIdInvalido);
  }

  resetBloc() async  {
    integracao = Integracao();
    integracaoController.add(integracao);
  }

  postMercadopagoLoja(int index) async { 
   integracao.endereco[index].estado == 'SP' ? integracao.endereco[index].estado = 'São Paulo' : integracao.endereco[index].estado;
   mercadopagoLoja.name = integracao.pessoa.razaoNome;
   mercadopagoLoja.location.streetNumber = integracao.endereco[index].numero;
   mercadopagoLoja.location.streetName = integracao.endereco[index].logradouro;
   mercadopagoLoja.location.cityName= integracao.endereco[index].municipio;
   mercadopagoLoja.location.stateName = integracao.endereco[index].estado;
   mercadopagoLoja.location.reference = integracao.endereco[index].complemento;
   mercadopagoLoja.location.latitude = -32.8897322;
   mercadopagoLoja.location.longitude = -68.8443275;
   mercadopagoLoja.externalId = _appGlobalBloc.loja.id.toString(); 
   return await mercadopagoLoja.postmercadopago(integracao.mercadopagoAcessToken, integracao.mercadopagoUserId);
 }

 getMercadopagoLoja() async {
  return await mercadopagoLoja.getMercadopago(integracao.mercadopagoAcessToken, integracao.mercadopagoUserId);
 }

  getMercadopagoTerminal() async {
   mercadopagoTerminal.getMercadopagoTerminalGet();
 }
}