import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LocaleBase {
  Map<String, dynamic> _data;
  String _path;
  Future<void> load(String path) async {
    _path = path;
    final strJson = await rootBundle.loadString(path);
    _data = jsonDecode(strJson);
    initAll();
  }
  
  Map<String, String> getData(String group) {
    return Map<String, String>.from(_data[group]);
  }

  String getPath() => _path;

  Localecadastro _cadastro;
  Localecadastro get cadastro => _cadastro;
  LocalecadastroCategoria _cadastroCategoria;
  LocalecadastroCategoria get cadastroCategoria => _cadastroCategoria;
  LocalecadastroCliente _cadastroCliente;
  LocalecadastroCliente get cadastroCliente => _cadastroCliente;
  LocalecadastroContato _cadastroContato;
  LocalecadastroContato get cadastroContato => _cadastroContato;
  LocalecadastroGrade _cadastroGrade;
  LocalecadastroGrade get cadastroGrade => _cadastroGrade;
  LocalecadastroLoja _cadastroLoja;
  LocalecadastroLoja get cadastroLoja => _cadastroLoja;
  LocalecadastroPrecoTabela _cadastroPrecoTabela;
  LocalecadastroPrecoTabela get cadastroPrecoTabela => _cadastroPrecoTabela;
  LocalecadastroProduto _cadastroProduto;
  LocalecadastroProduto get cadastroProduto => _cadastroProduto;
  LocalecadastroTerminal _cadastroTerminal;
  LocalecadastroTerminal get cadastroTerminal => _cadastroTerminal;
  LocalecadastroTipoPagamento _cadastroTipoPagamento;
  LocalecadastroTipoPagamento get cadastroTipoPagamento => _cadastroTipoPagamento;
  LocalecadastroTransacao _cadastroTransacao;
  LocalecadastroTransacao get cadastroTransacao => _cadastroTransacao;
  LocalecadastroVariante _cadastroVariante;
  LocalecadastroVariante get cadastroVariante => _cadastroVariante;
  LocalecadastroVendedor _cadastroVendedor;
  LocalecadastroVendedor get cadastroVendedor => _cadastroVendedor;
  Localemensagem _mensagem;
  Localemensagem get mensagem => _mensagem;
  Localepalavra _palavra;
  Localepalavra get palavra => _palavra;
  LocaletelaCadastroUsuario _telaCadastroUsuario;
  LocaletelaCadastroUsuario get telaCadastroUsuario => _telaCadastroUsuario;
  LocaletelaLogin _telaLogin;
  LocaletelaLogin get telaLogin => _telaLogin;
  LocaletelaMovimentoCaixa _telaMovimentoCaixa;
  LocaletelaMovimentoCaixa get telaMovimentoCaixa => _telaMovimentoCaixa;

  void initAll() {
    _cadastro = Localecadastro(Map<String, String>.from(_data['cadastro']));
    _cadastroCategoria = LocalecadastroCategoria(Map<String, String>.from(_data['cadastroCategoria']));
    _cadastroCliente = LocalecadastroCliente(Map<String, String>.from(_data['cadastroCliente']));
    _cadastroContato = LocalecadastroContato(Map<String, String>.from(_data['cadastroContato']));
    _cadastroGrade = LocalecadastroGrade(Map<String, String>.from(_data['cadastroGrade']));
    _cadastroLoja = LocalecadastroLoja(Map<String, String>.from(_data['cadastroLoja']));
    _cadastroPrecoTabela = LocalecadastroPrecoTabela(Map<String, String>.from(_data['cadastroPrecoTabela']));
    _cadastroProduto = LocalecadastroProduto(Map<String, String>.from(_data['cadastroProduto']));
    _cadastroTerminal = LocalecadastroTerminal(Map<String, String>.from(_data['cadastroTerminal']));
    _cadastroTipoPagamento = LocalecadastroTipoPagamento(Map<String, String>.from(_data['cadastroTipoPagamento']));
    _cadastroTransacao = LocalecadastroTransacao(Map<String, String>.from(_data['cadastroTransacao']));
    _cadastroVariante = LocalecadastroVariante(Map<String, String>.from(_data['cadastroVariante']));
    _cadastroVendedor = LocalecadastroVendedor(Map<String, String>.from(_data['cadastroVendedor']));
    _mensagem = Localemensagem(Map<String, String>.from(_data['mensagem']));
    _palavra = Localepalavra(Map<String, String>.from(_data['palavra']));
    _telaCadastroUsuario = LocaletelaCadastroUsuario(Map<String, String>.from(_data['telaCadastroUsuario']));
    _telaLogin = LocaletelaLogin(Map<String, String>.from(_data['telaLogin']));
    _telaMovimentoCaixa = LocaletelaMovimentoCaixa(Map<String, String>.from(_data['telaMovimentoCaixa']));
  }
}

class Localecadastro {
  final Map<String, String> _data;
  Localecadastro(this._data);

  String get incluirNovo => _data["incluirNovo"];
}
class LocalecadastroCategoria {
  final Map<String, String> _data;
  LocalecadastroCategoria(this._data);

  String get titulo => _data["titulo"];
}
class LocalecadastroCliente {
  final Map<String, String> _data;
  LocalecadastroCliente(this._data);

  String get titulo => _data["titulo"];
}
class LocalecadastroContato {
  final Map<String, String> _data;
  LocalecadastroContato(this._data);

  String get titulo => _data["titulo"];
}
class LocalecadastroGrade {
  final Map<String, String> _data;
  LocalecadastroGrade(this._data);

  String get titulo => _data["titulo"];
}
class LocalecadastroLoja {
  final Map<String, String> _data;
  LocalecadastroLoja(this._data);

  String get titulo => _data["titulo"];
}
class LocalecadastroPrecoTabela {
  final Map<String, String> _data;
  LocalecadastroPrecoTabela(this._data);

  String get titulo => _data["titulo"];
}
class LocalecadastroProduto {
  final Map<String, String> _data;
  LocalecadastroProduto(this._data);

  String get titulo => _data["titulo"];
}
class LocalecadastroTerminal {
  final Map<String, String> _data;
  LocalecadastroTerminal(this._data);

  String get titulo => _data["titulo"];
}
class LocalecadastroTipoPagamento {
  final Map<String, String> _data;
  LocalecadastroTipoPagamento(this._data);

  String get titulo => _data["titulo"];
}
class LocalecadastroTransacao {
  final Map<String, String> _data;
  LocalecadastroTransacao(this._data);

  String get titulo => _data["titulo"];
}
class LocalecadastroVariante {
  final Map<String, String> _data;
  LocalecadastroVariante(this._data);

  String get titulo => _data["titulo"];
}
class LocalecadastroVendedor {
  final Map<String, String> _data;
  LocalecadastroVendedor(this._data);

  String get titulo => _data["titulo"];
}
class Localemensagem {
  final Map<String, String> _data;
  Localemensagem(this._data);

  String get nomeNaoNulo => _data["nomeNaoNulo"];
  String get confirmarExcluirRegistro => _data["confirmarExcluirRegistro"];
  String get codigoInvalido => _data["codigoInvalido"];
  String get precoCustoInvalido => _data["precoCustoInvalido"];
  String get precoVendaInvalido => _data["precoVendaInvalido"];
  String get usernameIncorreto => _data["usernameIncorreto"];
  String get senhaIncorreta => _data["senhaIncorreta"];
  String get senhasDiferentes => _data["senhasDiferentes"];
  String get emailIncorreto => _data["emailIncorreto"];
}
class Localepalavra {
  final Map<String, String> _data;
  Localepalavra(this._data);

  String get excluir => _data["excluir"];
  String get pesquisar => _data["pesquisar"];
  String get alterar => _data["alterar"];
  String get limpar => _data["limpar"];
  String get nome => _data["nome"];
  String get cancelar => _data["cancelar"];
  String get gravar => _data["gravar"];
  String get confirmacao => _data["confirmacao"];
  String get artigo_a => _data["artigo_a"];
  String get artigo_o => _data["artigo_o"];
  String get erro => _data["erro"];
  String get posicao => _data["posicao"];
  String get selecione => _data["selecione"];
  String get nomeFantasia => _data["nomeFantasia"];
  String get razaoSocial => _data["razaoSocial"];
  String get cnpj => _data["cnpj"];
  String get cpf => _data["cpf"];
  String get ie => _data["ie"];
  String get im => _data["im"];
  String get endereco => _data["endereco"];
  String get numero => _data["numero"];
  String get cidade => _data["cidade"];
  String get bairro => _data["bairro"];
  String get estado => _data["estado"];
  String get pais => _data["pais"];
  String get pessoaFisica => _data["pessoaFisica"];
  String get pessoaJuridica => _data["pessoaJuridica"];
  String get telefone => _data["telefone"];
  String get email => _data["email"];
  String get cep => _data["cep"];
  String get senha => _data["senha"];
  String get ddd => _data["ddd"];
  String get apelido => _data["apelido"];
  String get rg => _data["rg"];
  String get precoVenda => _data["precoVenda"];
  String get precoCusto => _data["precoCusto"];
  String get codigo => _data["codigo"];
  String get entrada => _data["entrada"];
  String get saida => _data["saida"];
  String get saldo => _data["saldo"];
  String get ticketMedio => _data["ticketMedio"];
  String get qtdVendas => _data["qtdVendas"];
  String get itensVendidos => _data["itensVendidos"];
  String get totalLiquido => _data["totalLiquido"];
  String get abertura => _data["abertura"];
  String get reforco => _data["reforco"];
  String get sangria => _data["sangria"];
  String get vendas => _data["vendas"];
  String get recebimento => _data["recebimento"];
  String get usuario => _data["usuario"];
  String get login => _data["login"];
}
class LocaletelaCadastroUsuario {
  final Map<String, String> _data;
  LocaletelaCadastroUsuario(this._data);

  String get redigiteASenha => _data["redigiteASenha"];
}
class LocaletelaLogin {
  final Map<String, String> _data;
  LocaletelaLogin(this._data);

  String get ouEntreCom => _data["ouEntreCom"];
  String get criarConta => _data["criarConta"];
}
class LocaletelaMovimentoCaixa {
  final Map<String, String> _data;
  LocaletelaMovimentoCaixa(this._data);

  String get titulo => _data["titulo"];
  String get resumoDeVendas => _data["resumoDeVendas"];
}
