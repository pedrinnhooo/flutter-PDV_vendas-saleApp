import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/src/bloc/hasura_bloc.dart';
import 'package:common_files/src/model/entities/cadastro/contato/contato.dart';
import 'package:common_files/src/model/entities/cadastro/endereco/endereco.dart';
import 'package:common_files/src/model/entities/cadastro/pessoa/pessoa.dart';
import 'package:common_files/src/model/entities/cadastro/pessoa/pessoaDao.dart';
import 'package:common_files/src/model/entities/util/cep.dart';
import 'package:common_files/src/utils/functions.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:rxdart/rxdart.dart';

class PessoaBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  bool ehLoja;
  bool ehCliente;
  bool ehFornecedor;
  bool ehVendedor;
  bool ehRevenda;

  String filtroNome="";

  Pessoa pessoa;
  PessoaDAO pessoaDAO;
  List<Pessoa> pessoaList = [];
  BehaviorSubject<Pessoa> pessoaController;
  Observable<Pessoa> get pessoaOut => pessoaController.stream;

  BehaviorSubject<List<Pessoa>> pessoaListController;
  Observable<List<Pessoa>> get pessoaListOut => pessoaListController.stream;

  Endereco endereco;
  BehaviorSubject<Endereco> enderecoController;
  Observable<Endereco> get enderecoOut => enderecoController.stream;
  
  Contato contato;
  BehaviorSubject<Contato> contatoController;
  Observable<Contato> get contatoOut => contatoController.stream;

  TextEditingController apelidoController;
  TextEditingController logradouroController;
  TextEditingController numeroController;
  TextEditingController complementoController;
  TextEditingController bairroController;
  TextEditingController municipioController;
  TextEditingController estadoController;
  MaskedTextController cepTextController;

  bool formInvalido = false;

  bool razaoNomeInvalido = false;
  BehaviorSubject<bool> razaoNomeInvalidoController;
  Observable<bool> get razaoNomeInvalidoOut => razaoNomeInvalidoController.stream;

  bool fantasiaApelidoInvalido = false;
  BehaviorSubject<bool> fantasiaApelidoInvalidoController;
  Observable<bool> get fantasiaApelidoInvalidoOut => fantasiaApelidoInvalidoController.stream;

  bool cnpjCpfInvalido = false;
  BehaviorSubject<bool> cnpjCpfInvalidoController;
  Observable<bool> get cnpjCpfInvalidoOut => cnpjCpfInvalidoController.stream;

  bool contatoNomeInvalido = false;
  BehaviorSubject<bool> contatoNomeInvalidoController;
  Observable<bool> get contatoNomeInvalidoOut => contatoNomeInvalidoController.stream;

  bool contatoEmailInvalido = false;
  BehaviorSubject<bool> contatoEmailInvalidoController;
  Observable<bool> get contatoEmailInvalidoOut => contatoEmailInvalidoController.stream;

  bool enderecoApelidoInvalido = false;
  BehaviorSubject<bool> enderecoApelidoInvalidoController;
  Observable<bool> get enderecoApelidoInvalidoOut => enderecoApelidoInvalidoController.stream;

  bool enderecoCepInvalido = false;
  BehaviorSubject<bool> enderecoCepInvalidoController;
  Observable<bool> get enderecoCepInvalidoOut => enderecoCepInvalidoController.stream;

  int indexContato = 0;
  int indexEndereco = 0;

  int contatoCount = 0;
  BehaviorSubject<int> contatoCountController;
  Observable<int> get contatoCountOut => contatoCountController.stream;

  int enderecoCount = 0;
  BehaviorSubject<int> enderecoCountController;
  Observable<int> get enderecoCountOut => enderecoCountController.stream;

  PessoaBloc(this._hasuraBloc) {
    pessoa = Pessoa();
    pessoaDAO = PessoaDAO(_hasuraBloc, pessoa);
    pessoaDAO.filterEhLoja = true;
    pessoaController = BehaviorSubject.seeded(pessoa);
    pessoaListController = BehaviorSubject.seeded(pessoaList);
    enderecoController = BehaviorSubject.seeded(endereco);
    contatoController = BehaviorSubject.seeded(contato);
    razaoNomeInvalidoController = BehaviorSubject.seeded(razaoNomeInvalido);
    fantasiaApelidoInvalidoController = BehaviorSubject.seeded(fantasiaApelidoInvalido);
    cnpjCpfInvalidoController = BehaviorSubject.seeded(cnpjCpfInvalido);
    contatoNomeInvalidoController = BehaviorSubject.seeded(contatoNomeInvalido);
    contatoEmailInvalidoController = BehaviorSubject.seeded(contatoEmailInvalido);
    enderecoApelidoInvalidoController = BehaviorSubject.seeded(enderecoApelidoInvalido);
    enderecoCepInvalidoController = BehaviorSubject.seeded(enderecoCepInvalido);
    contatoCountController = BehaviorSubject.seeded(contatoCount);
    enderecoCountController = BehaviorSubject.seeded(enderecoCount);

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
    PessoaDAO pessoaDAO = PessoaDAO(_hasuraBloc, pessoa);
    pessoaDAO.filterEhLoja = ehLoja;
    pessoaDAO.filterEhCliente = ehCliente;
    pessoaDAO.filterEhFornecedor = ehFornecedor;
    pessoaDAO.filterEhVendedor = ehVendedor;
    pessoaDAO.filterEhRevenda = ehRevenda;
    pessoaList = await pessoaDAO.getAllFromServer(id: true, filtroNome: filtroNome);
    pessoaListController.add(pessoaList);
  } 

  getPessoaById(int id) async {
    Pessoa _pessoa = Pessoa();
    PessoaDAO _pessoaDAO = PessoaDAO(_hasuraBloc, _pessoa);
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

      }
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
    PessoaDAO _pessoaDAO = PessoaDAO(_hasuraBloc, pessoa);
    pessoa = await _pessoaDAO.saveOnServer();
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
    PessoaDAO _pessoaDAO = PessoaDAO(_hasuraBloc, pessoa);
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
    formInvalido = razaoNomeInvalido;
    razaoNomeInvalidoController.add(razaoNomeInvalido);
  }

  validaFantasiaApelido() async {
    fantasiaApelidoInvalido = pessoa.fantasiaApelido == "" ? true : false;
    formInvalido = fantasiaApelidoInvalido;
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
    contatoController.close();
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
    super.dispose();
  }
}
