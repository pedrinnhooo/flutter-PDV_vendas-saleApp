import '../../../../../common_files.dart';

class ConfiguracaoPessoa extends IEntity{
  int _id;
  int _idPessoa;
  String _textoCabecalho;
  String _textoRodape;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;

  ConfiguracaoPessoa(
      {int id,
      int idPessoa,
      String textoCabecalho,
      String textoRodape,
      DateTime dataCadastro,
      DateTime dataAtualizacao}) {
    this._id = id;
    this._idPessoa = idPessoa;
    this._textoCabecalho = textoCabecalho;
    this._textoRodape = textoRodape;
    this._dataCadastro = dataCadastro == null ? DateTime.now() : dataCadastro;
    this._dataAtualizacao = dataAtualizacao == null ? DateTime.now() : dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoa => _idPessoa;
  set idPessoa(int idPessoa) => _idPessoa = idPessoa;
  String get textoCabecalho => _textoCabecalho;
  set textoCabecalho(String textoCabecalho) => _textoCabecalho = textoCabecalho;
  String get textoRodape => _textoRodape;
  set textoRodape(String textoRodape) => _textoRodape = textoRodape;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) => _dataAtualizacao = dataAtualizacao;

  ConfiguracaoPessoa.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoa = json['idPessoa'];
    _textoCabecalho = json['textoCabecalho'];
    _textoRodape = json['textoRodape'];
    _dataCadastro = json['data_cadastro'] != null ? DateTime.parse(json['data_cadastro']) : null;
    _dataAtualizacao = json['data_atualizacao'] != null ? DateTime.parse(json['data_atualizacao']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['idPessoa'] = this._idPessoa;
    data['textoCabecalho'] = this._textoCabecalho;
    data['textoRodape'] = this._textoRodape;
    data['dataCadastro'] = this._dataCadastro;
    data['dataAtualizacao'] = this._dataAtualizacao;
    return data;
  }
}