import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:common_files/common_files.dart';

class PessoaBloc extends BlocBase {
  SharedVendaBloc _sharedVendaBloc;
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  bool ehLoja;
  bool ehCliente;
  bool ehFornecedor;
  bool ehVendedor;
  bool ehRevenda;
  bool filterOnServer;
  int offset = 0;
  String filtroNome="";

  Pessoa pessoa;
  PessoaDAO pessoaDAO;
  List<Pessoa> pessoaList = [];
  BehaviorSubject<Pessoa> pessoaController;
  Stream<Pessoa> get pessoaOut => pessoaController.stream;

  BehaviorSubject<List<Pessoa>> pessoaListController;
  Stream<List<Pessoa>> get pessoaListOut => pessoaListController.stream;

  Endereco endereco;
  BehaviorSubject<Endereco> enderecoController;
  Stream<Endereco> get enderecoOut => enderecoController.stream;
  
  Contato contato;
  BehaviorSubject<Contato> contatoController;
  Stream<Contato> get contatoOut => contatoController.stream;

  Cep cep;
  BehaviorSubject<Cep> cepController;
  Stream<Cep> get cepOut => cepController.stream;

  TextEditingController apelidoController;
  TextEditingController logradouroController;
  TextEditingController numeroController;
  TextEditingController complementoController;
  TextEditingController bairroController;
  TextEditingController municipioController;
  TextEditingController estadoController;
  MaskedTextController cepTextController;

  bool formInvalido = false;

  List<Movimento> movimentoList;
  BehaviorSubject<List<Movimento>> movimentoListController;
  Stream<List<Movimento>> get movimentoListControllerOut => movimentoListController.stream;

  bool razaoNomeInvalido = false;
  BehaviorSubject<bool> razaoNomeInvalidoController;
  Stream<bool> get razaoNomeInvalidoOut => razaoNomeInvalidoController.stream;

  bool fantasiaApelidoInvalido = false;
  BehaviorSubject<bool> fantasiaApelidoInvalidoController;
  Stream<bool> get fantasiaApelidoInvalidoOut => fantasiaApelidoInvalidoController.stream;

  bool cnpjCpfInvalido = false;
  BehaviorSubject<bool> cnpjCpfInvalidoController;
  Stream<bool> get cnpjCpfInvalidoOut => cnpjCpfInvalidoController.stream;

  bool contatoNomeInvalido = false;
  BehaviorSubject<bool> contatoNomeInvalidoController;
  Stream<bool> get contatoNomeInvalidoOut => contatoNomeInvalidoController.stream;

  bool contatoEmailInvalido = false;
  BehaviorSubject<bool> contatoEmailInvalidoController;
  Stream<bool> get contatoEmailInvalidoOut => contatoEmailInvalidoController.stream;

  bool enderecoApelidoInvalido = false;
  BehaviorSubject<bool> enderecoApelidoInvalidoController;
  Stream<bool> get enderecoApelidoInvalidoOut => enderecoApelidoInvalidoController.stream;

  bool enderecoCepInvalido = false;
  BehaviorSubject<bool> enderecoCepInvalidoController;
  Stream<bool> get enderecoCepInvalidoOut => enderecoCepInvalidoController.stream;

  int indexContato = 0;
  int indexEndereco = 0;

  int contatoCount = 0;
  BehaviorSubject<int> contatoCountController;
  Stream<int> get contatoCountOut => contatoCountController.stream;

  int enderecoCount = 0;
  BehaviorSubject<int> enderecoCountController;
  Stream<int> get enderecoCountOut => enderecoCountController.stream;

  bool campoNomeExpandido = true;
  BehaviorSubject<bool> campoNomeExpandidoController;
  Stream<bool> get campoNomeExpandidoOut => campoNomeExpandidoController.stream;

  bool campoEnderecoExpandido = false;
  BehaviorSubject<bool> campoEnderecoExpandidoController;
  Stream<bool> get campoEnderecoExpandidoOut => campoEnderecoExpandidoController.stream;

  bool campoContatoExpandido = false;
  BehaviorSubject<bool> campoContatoExpandidoController;
  Stream<bool> get campoContatoExpandidoOut => campoContatoExpandidoController.stream;

  PessoaBloc(this._hasuraBloc, this._sharedVendaBloc, this._appGlobalBloc) {
    pessoa = Pessoa();
    cep = Cep();
    pessoaDAO = PessoaDAO(_hasuraBloc, _appGlobalBloc, pessoa);
    pessoaDAO.filterEhLoja = true;
    pessoaController = BehaviorSubject.seeded(pessoa);
    pessoaListController = BehaviorSubject.seeded(pessoaList);
    movimentoListController = BehaviorSubject.seeded(movimentoList);

    enderecoController = BehaviorSubject.seeded(endereco);
    contatoController = BehaviorSubject.seeded(contato);
    cepController = BehaviorSubject.seeded(cep);
    razaoNomeInvalidoController = BehaviorSubject.seeded(razaoNomeInvalido);
    fantasiaApelidoInvalidoController = BehaviorSubject.seeded(fantasiaApelidoInvalido);
    cnpjCpfInvalidoController = BehaviorSubject.seeded(cnpjCpfInvalido);
    contatoNomeInvalidoController = BehaviorSubject.seeded(contatoNomeInvalido);
    contatoEmailInvalidoController = BehaviorSubject.seeded(contatoEmailInvalido);
    enderecoApelidoInvalidoController = BehaviorSubject.seeded(enderecoApelidoInvalido);
    enderecoCepInvalidoController = BehaviorSubject.seeded(enderecoCepInvalido);
    contatoCountController = BehaviorSubject.seeded(contatoCount);
    enderecoCountController = BehaviorSubject.seeded(enderecoCount);
    campoNomeExpandidoController = BehaviorSubject.seeded(campoNomeExpandido);
    campoEnderecoExpandidoController = BehaviorSubject.seeded(campoEnderecoExpandido);
    campoContatoExpandidoController = BehaviorSubject.seeded(campoContatoExpandido);

    cepTextController = MaskedTextController(mask: "00000-000");
    apelidoController = TextEditingController();
    logradouroController = TextEditingController();
    numeroController = TextEditingController();
    complementoController = TextEditingController();
    bairroController = TextEditingController();
    municipioController = TextEditingController();
    estadoController = TextEditingController();
    initPessoaBloc();
  }

  initPessoaBloc() {
    ehLoja = false;
    ehCliente = false;
    ehFornecedor = false;
    ehVendedor = false;
    ehRevenda = false;
  }

  getAllPessoa() async {
    Pessoa pessoa = Pessoa();
    PessoaDAO pessoaDAO = PessoaDAO(_hasuraBloc, _appGlobalBloc, pessoa);
    pessoaDAO.filterEhLoja = ehLoja;
    pessoaDAO.filterEhCliente = ehCliente;
    pessoaDAO.filterEhFornecedor = ehFornecedor;
    pessoaDAO.filterEhVendedor = ehVendedor;
    pessoaDAO.filterEhRevenda = ehRevenda;
    pessoaDAO.filterId = 0;
    pessoaDAO.filterText = "";
    pessoaList = offset == 0 ? [] : pessoaList; 
    pessoaList += _sharedVendaBloc.filterOnServer ? await pessoaDAO.getAllFromServer(id: true, filtroNome: filtroNome, offset: offset) : await pessoaDAO.getAll(preLoad: true);
    pessoaListController.add(pessoaList);
    _sharedVendaBloc.filterOnServer = true;
    offset += queryLimit;
    return pessoaList;
  }  

  getPessoaById(int id) async {
    Pessoa _pessoa = Pessoa();
    PessoaDAO _pessoaDAO = PessoaDAO(_hasuraBloc, _appGlobalBloc, _pessoa);
    pessoaDAO.filterEhLoja = ehLoja;
    pessoaDAO.filterEhCliente = ehCliente;
    pessoaDAO.filterEhFornecedor = ehFornecedor;
    pessoaDAO.filterEhVendedor = ehVendedor;
    pessoaDAO.filterEhRevenda = ehRevenda;
    pessoa = await _pessoaDAO.getByIdFromServer(id);
    await getContatoCount();
    await getEnderecoCount();
    pessoaController.add(pessoa);
  }

  getContatoByPessoa(int index) async {
    indexContato = index;
    contatoController.add(pessoa.contato[index]);
  }

  getEnderecoByPessoa(int index) async {
    indexEndereco = index;
    enderecoController.add(pessoa.endereco[index]);
    cepTextController.value =  cepTextController.value.copyWith(text: pessoa.endereco[index].cep); 
    apelidoController.value =  apelidoController.value.copyWith(text: pessoa.endereco[index].apelido); 
    logradouroController.value =  logradouroController.value.copyWith(text: pessoa.endereco[index].logradouro); 
    numeroController.value =  numeroController.value.copyWith(text: pessoa.endereco[index].numero); 
    complementoController.value =  complementoController.value.copyWith(text: pessoa.endereco[index].complemento); 
    bairroController.value =  bairroController.value.copyWith(text: pessoa.endereco[index].bairro); 
    municipioController.value =  municipioController.value.copyWith(text: pessoa.endereco[index].municipio); 
    estadoController.value =  estadoController.value.copyWith(text: pessoa.endereco[index].estado); 
  }

  getMovimentoByIdCliente(int id) async {
    MovimentoCliente _movimento = MovimentoCliente();
    MovimentoClienteDAO _movimentoDAO = MovimentoClienteDAO(_hasuraBloc, _appGlobalBloc, _movimento);
    movimentoList = await _movimentoDAO.getAllFromServer(id: id, offset: 15);
    movimentoListController.add(movimentoList);
    offset += queryLimit;
  }

  newPessoa() async {
    pessoa = Pessoa();
    pessoa.razaoNome = "";
    pessoa.fantasiaApelido = "";
    pessoaController.add(pessoa);
  }

  newContato() async {
    pessoa.contato.add(Contato());
    indexContato = pessoa.contato.length - 1;
    contatoController.add(pessoa.contato[indexContato]);
    await getContatoCount();
  }
  
  newEndereco() async {
    pessoa.endereco.add(Endereco());
    indexEndereco = pessoa.endereco.length - 1;
    enderecoController.add(pessoa.endereco[indexEndereco]);
    clearEnderecoControllers();
    await getEnderecoCount();
  }

  searchCep() async {
    if (pessoa.endereco[indexEndereco].cep != "") {
      Cep cep = Cep();
      cep = await consultaCep(pessoa.endereco[indexEndereco].cep);
      if (cep != null) {
        pessoa.endereco[indexEndereco].logradouro = cep.logradouro;
        logradouroController.value = estadoController.value.copyWith(text: cep.logradouro);
        pessoa.endereco[indexEndereco].numero = "";
        numeroController.value = estadoController.value.copyWith(text: "");
        pessoa.endereco[indexEndereco].complemento = "";
        complementoController.value = estadoController.value.copyWith(text: "");
        pessoa.endereco[indexEndereco].bairro = cep.bairro;
        bairroController.value = estadoController.value.copyWith(text: cep.bairro);
        pessoa.endereco[indexEndereco].municipio = cep.localidade;
        municipioController.value = estadoController.value.copyWith(text: cep.localidade);
        pessoa.endereco[indexEndereco].estado = cep.uf;
        estadoController.value = estadoController.value.copyWith(text: cep.uf);
        pessoa.endereco[indexEndereco].ibgeMunicipio = cep.ibge;
        cepController.add(cep);
      }
      cepController.add(cep);
    }
  }

  clearEnderecoControllers() {
    cepTextController.clear();
    apelidoController.clear();
    logradouroController.clear();
    numeroController.clear();
    complementoController.clear();
    bairroController.clear();
    municipioController.clear();
    estadoController.clear();
  }
  
  savePessoa() async  {
    pessoa.fantasiaApelido = pessoa.fantasiaApelido == null 
      || pessoa.fantasiaApelido == "" ? pessoa.razaoNome : pessoa.fantasiaApelido;
    pessoa.dataCadastro = pessoa.dataCadastro == null ? DateTime.now() : pessoa.dataCadastro;
    pessoa.dataAtualizacao = DateTime.now();
    PessoaDAO _pessoaDAO = PessoaDAO(_hasuraBloc, _appGlobalBloc, pessoa);
    pessoa = await _pessoaDAO.saveOnServer();
    offset = 0;
    await getAllPessoa();
    await resetBloc();
  }

  saveContato() async {
    pessoa.contato[indexContato].dataAtualizacao = DateTime.now();
    pessoaController.add(pessoa);
  }

  saveEndereco() async {
    pessoa.endereco[indexEndereco].dataAtualizacao = DateTime.now();
    pessoaController.add(pessoa);
  }

  deletePessoa() async {
    pessoa.ehDeletado = 1; 
    pessoa.dataAtualizacao = DateTime.now(); 
    PessoaDAO _pessoaDAO = PessoaDAO(_hasuraBloc, _appGlobalBloc, pessoa);
    pessoa = await _pessoaDAO.saveOnServer();
    await resetBloc();
  }

  deleteContato() async {
    pessoa.contato[indexContato].ehDeletado = 1;
    pessoa.contato[indexContato].dataAtualizacao = DateTime.now();
    pessoaController.add(pessoa);
    await getContatoCount();
  }

  deleteEndereco() async {
    pessoa.endereco[indexEndereco].ehDeletado = 1;
    pessoa.endereco[indexEndereco].dataAtualizacao = DateTime.now();
    pessoaController.add(pessoa);
    await getEnderecoCount();
  }

  getContatoCount() async {
    contatoCount = 0;
    for (var i = 0; i < pessoa.contato.length; i++) {
      contatoCount = pessoa.contato[i].ehDeletado == 0 ? contatoCount + 1 : contatoCount;
    }
    contatoCountController.add(contatoCount);
  }

  getEnderecoCount() async {
    enderecoCount = 0;
    for (var i = 0; i < pessoa.endereco.length; i++) {
      enderecoCount = pessoa.endereco[i].ehDeletado == 0 ? enderecoCount + 1 : enderecoCount;
    }
    enderecoCountController.add(enderecoCount);
  }

  setTipoPessoa(int value) async {
    pessoa.ehFisica = value;
    pessoa.cnpjCpf = "";
    pessoaController.add(pessoa);
  }

  validaRazaoNome() async {
    razaoNomeInvalido = pessoa.razaoNome == "" ? true : false;
    formInvalido = !formInvalido ? razaoNomeInvalido : formInvalido;
    razaoNomeInvalidoController.add(razaoNomeInvalido);
  }

  validaFantasiaApelido() async {
    fantasiaApelidoInvalido = pessoa.fantasiaApelido == "" ? true : false;
    formInvalido = !formInvalido ? fantasiaApelidoInvalido : formInvalido;
    fantasiaApelidoInvalidoController.add(fantasiaApelidoInvalido);
  }

  validaCnpjCpf() async {
    cnpjCpfInvalido = false;
    if (pessoa.cnpjCpf != "") {
    cnpjCpfInvalido = pessoa.ehFisica == 0 
      ? !CNPJValidator.isValid(pessoa.cnpjCpf)
      : !CPFValidator.isValid(pessoa.cnpjCpf);
    }  
    formInvalido = cnpjCpfInvalido;  
    cnpjCpfInvalidoController.add(cnpjCpfInvalido);
  }

  validaContatoEmail() async {
    contatoEmailInvalido = false;
    if (pessoa.contato[indexContato].email != "") { 
      contatoEmailInvalido = !validateEmail(pessoa.contato[indexContato].email); 
    }
    contatoEmailInvalidoController.add(contatoEmailInvalido);
  }

  validaContatoVazio() async {
    if (pessoa.contato[indexContato].nome == null ||
        pessoa.contato[indexContato].nome == "") {
      pessoa.contato.removeAt(indexContato);
    }  
  }

  validaEnderecoVazio() async {
    if (pessoa.endereco[indexEndereco].apelido == null ||
        pessoa.endereco[indexEndereco].apelido == "") {
      pessoa.endereco.removeAt(indexEndereco);
    }  
  }

  validaEnderecoApelido() async {
    enderecoApelidoInvalido = false;
    if (pessoa.endereco[indexEndereco].apelido == "" ||
        pessoa.endereco[indexEndereco].logradouro != "") {
      enderecoApelidoInvalido = true;
    }
    enderecoApelidoInvalidoController.add(enderecoApelidoInvalido);
  }

  validaEnderecoCep() async {
    enderecoCepInvalido = false;
    if (pessoa.endereco[indexEndereco].cep != "") { 
      enderecoCepInvalido = !validateCep(pessoa.endereco[indexEndereco].cep); 
    }
    enderecoCepInvalidoController.add(enderecoCepInvalido);
  }

  validaForm() async {
    await validaRazaoNome();
    await validaFantasiaApelido();
    await validaCnpjCpf();
  }

  limpaValidacoes(){
    razaoNomeInvalido = false;
    razaoNomeInvalidoController.add(razaoNomeInvalido);
    fantasiaApelidoInvalido = false;
    fantasiaApelidoInvalidoController.add(fantasiaApelidoInvalido);
    cnpjCpfInvalido = false;
    cnpjCpfInvalidoController.add(cnpjCpfInvalido);
    contatoEmailInvalido = false;
    contatoEmailInvalidoController.add(contatoEmailInvalido);
    campoNomeExpandido = false;
    campoNomeExpandidoController.add(campoNomeExpandido);
    campoEnderecoExpandido = false;
    campoEnderecoExpandidoController.add(campoEnderecoExpandido);
    campoContatoExpandido = false;
    campoContatoExpandidoController.add(campoContatoExpandido);
  }

  setCampoNomeExpandido(bool value){
    campoNomeExpandido = value;
    campoNomeExpandidoController.add(campoNomeExpandido);
  }

  setCampoEnderecoExpandido(bool value){
    campoEnderecoExpandido = value;
    campoEnderecoExpandidoController.add(campoEnderecoExpandido);
  }

  setCampoContatoExpandido(bool value){
    campoContatoExpandido = value;
    campoContatoExpandidoController.add(campoContatoExpandido);
  }

  resetBloc() async  {
    pessoa = Pessoa();
    pessoa.ehLoja = ehLoja ? 1 : 0;
    pessoa.ehCliente = ehCliente ? 1 : 0;
    pessoa.ehFornecedor = ehFornecedor ? 1 : 0;
    pessoa.ehVendedor = ehVendedor ? 1 : 0;
    pessoa.ehRevenda = ehRevenda ? 1 : 0;
    pessoaController.add(pessoa);
  }

  @override
  void dispose() {
    pessoaController.close();
    pessoaListController.close();
    movimentoListController.close();
    contatoController.close();
    cepController.close();
    enderecoController.close();
    razaoNomeInvalidoController.close();
    fantasiaApelidoInvalidoController.close();
    cnpjCpfInvalidoController.close();
    contatoNomeInvalidoController.close();
    contatoEmailInvalidoController.close();
    enderecoApelidoInvalidoController.close();
    enderecoCepInvalidoController.close();
    contatoCountController.close();
    enderecoCountController.close();
    campoNomeExpandidoController.close();
    campoEnderecoExpandidoController.close();
    campoContatoExpandidoController.close();
    super.dispose();
  }
}
