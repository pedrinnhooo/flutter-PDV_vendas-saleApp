import 'package:common_files/src/model/entities/cadastro/contato/contato.dart';
import 'package:common_files/src/model/entities/cadastro/endereco/endereco.dart';
import 'package:common_files/src/model/entities/interfaces.dart';

class Pessoa implements IEntity {
  int _id;
  int _idPessoaGrupo;
  String _razaoNome;
  String _fantasiaApelido;
  String _cnpjCpf;
  String _ieRg;
  String _im;
  int _ehFisica;
  int _ehLoja;
  int _ehCliente;
  int _ehFornecedor;
  int _ehVendedor;
  int _ehRevenda;
  int _ehDeletado;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;
  List<Endereco> _endereco;  
  List<Contato> _contato;  

  Pessoa(
      {int id,
      int idPessoaGrupo,
      String razaoNome="",
      String fantasiaApelido="",
      String cnpjCpf="",
      String ieRg="",
      String im="",
      int ehFisica = 0,
      int ehLoja = 0,
      int ehCliente = 0,
      int ehFornecedor = 0,
      int ehVendedor = 0,
      int ehRevenda = 0,
      int ehDeletado = 0,
      DateTime dataCadastro,
      DateTime dataAtualizacao,
      List<Endereco> endereco,
      List<Contato> contato}) {
    this._id = id;
    this._idPessoaGrupo = idPessoaGrupo;
    this._razaoNome = razaoNome;
    this._fantasiaApelido = fantasiaApelido;
    this._cnpjCpf = cnpjCpf;
    this._ieRg = ieRg;
    this._im = im;
    this._ehFisica = ehFisica;
    this._ehLoja = ehLoja;
    this._ehCliente = ehCliente;
    this._ehFornecedor = ehFornecedor;
    this._ehVendedor = ehVendedor;
    this._ehRevenda = ehRevenda;
    this._ehDeletado = ehDeletado;
    this._dataCadastro = dataCadastro == null ? DateTime.now() : dataCadastro;
    this._dataAtualizacao = dataAtualizacao == null ? DateTime.now() : dataAtualizacao;
    this._endereco = endereco == null ? [] : endereco;
    this._contato = contato == null ? [] : contato;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoaGrupo => _idPessoaGrupo;
  set idPessoaGrupo(int idPessoaGrupo) => _idPessoaGrupo = idPessoaGrupo;
  String get razaoNome => _razaoNome;
  set razaoNome(String razaoNome) => _razaoNome = razaoNome;
  String get fantasiaApelido => _fantasiaApelido;
  set fantasiaApelido(String fantasiaApelido) =>
      _fantasiaApelido = fantasiaApelido;
  String get cnpjCpf => _cnpjCpf;
  set cnpjCpf(String cnpjCpf) => _cnpjCpf = cnpjCpf;
  String get ieRg => _ieRg;
  set ieRg(String ieRg) => _ieRg = ieRg;
  String get im => _im;
  set im(String im) => _im = im;
  int get ehFisica => _ehFisica;
  set ehFisica(int ehFisica) => _ehFisica = ehFisica;
  int get ehLoja => _ehLoja;
  set ehLoja(int ehLoja) => _ehLoja = ehLoja;
  int get ehCliente => _ehCliente;
  set ehCliente(int ehCliente) => _ehCliente = ehCliente;
  int get ehFornecedor => _ehFornecedor;
  set ehFornecedor(int ehFornecedor) => _ehFornecedor = ehFornecedor;
  int get ehVendedor => _ehVendedor;
  set ehVendedor(int ehVendedor) => _ehVendedor = ehVendedor;
  int get ehRevenda => _ehRevenda;
  set ehRevenda(int ehRevenda) => _ehRevenda = ehRevenda;
  int get ehDeletado => _ehDeletado;
  set ehDeletado(int ehDeletado) => _ehDeletado = ehDeletado;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;
  List<Endereco> get endereco => _endereco;
  set endereco(List<Endereco> endereco) => _endereco = endereco;
  List<Contato> get contato => _contato;
  set contato(List<Contato> contato) => _contato = contato;

  Pessoa.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoaGrupo = json['id_pessoa_grupo'];
    _razaoNome = json['razao_nome'];
    _fantasiaApelido = json['fantasia_apelido'];
    _cnpjCpf = json['cnpj_cpf'];
    _ieRg = json['ie_rg'];
    _im = json['im'];
    _ehFisica = json['ehfisica'];
    _ehLoja = json['ehloja'];
    _ehCliente = json['ehcliente'];
    _ehFornecedor = json['ehfornecedor'];
    _ehVendedor = json['ehvendedor'];
    _ehRevenda = json['ehrevenda'];
    _ehDeletado = json['ehdeletado'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
    if (json['endereco'] != null) {
      _endereco = new List<Endereco>();
      json['endereco'].forEach((v) {
        _endereco.add(new Endereco.fromJson(v));
      });
    }
    if (json['contato'] != null) {
      _contato = new List<Contato>();
      json['contato'].forEach((v) {
        _contato.add(new Contato.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_pessoa_grupo'] = this._idPessoaGrupo;
    data['razao_nome'] = this._razaoNome;
    data['fantasia_apelido'] = this._fantasiaApelido;
    data['cnpj_cpf'] = this._cnpjCpf;
    data['ie_rg'] = this._ieRg;
    data['im'] = this._im;
    data['ehfisica'] = this._ehFisica;
    data['ehloja'] = this._ehLoja;
    data['ehcliente'] = this._ehCliente;
    data['ehfornecedor'] = this._ehFornecedor;
    data['ehvendedor'] = this._ehVendedor;
    data['ehrevenda'] = this._ehRevenda;
    data['ehdeletado'] = this._ehDeletado;
    data['data_cadastro'] = this._dataCadastro.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    if (this._endereco != null) {
      data['endereco'] =
          this._endereco.map((v) => v.toJson()).toList();
    }
    if (this._contato != null) {
      data['contato'] =
          this._contato.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
