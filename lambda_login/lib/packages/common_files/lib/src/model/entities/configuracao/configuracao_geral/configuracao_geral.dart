import '../../../../../common_files.dart';

class ConfiguracaoGeral implements IEntity{
  int _id;
  int _idPessoaGrupo;
  int _temServico;
  int _ehServicoDefault;
  int _ehMenuClassico;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;

  ConfiguracaoGeral({
    int id,
    int idPessoaGrupo,
    int temServico = 0,
    int ehServicoDefault = 0,
    int ehMenuClassico = 0,
    DateTime dataCadastro,
    DateTime dataAtualizacao,
  }) {
    this._id = id;
    this._idPessoaGrupo = idPessoaGrupo;
    this._temServico = temServico;
    this._ehServicoDefault = ehServicoDefault;
    this._ehMenuClassico = ehMenuClassico;
    this._dataCadastro = dataCadastro == null ? DateTime.now() : dataCadastro;
    this._dataAtualizacao = dataAtualizacao == null ? DateTime.now() : dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoaGrupo => _idPessoaGrupo;
  set idPessoaGrupo(int idPessoaGrupo) => _idPessoaGrupo = idPessoaGrupo;
  int get temServico => _temServico;
  set temServico(int temServico) => _temServico = temServico;
  int get ehServicoDefault => _ehServicoDefault;
  set ehServicoDefault(int ehServicoDefault) => _ehServicoDefault = ehServicoDefault;
  int get ehMenuClassico => _ehMenuClassico;
  set ehMenuClassico(int ehMenuClassico) => _ehMenuClassico = ehMenuClassico;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) => _dataAtualizacao = dataAtualizacao;

  ConfiguracaoGeral.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoaGrupo = json['id_pessoa_grupo'];
    _temServico = json['tem_servico'];
    _ehServicoDefault = json['ehservico_default'];
    _ehMenuClassico = json['ehmenu_classico'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
  }

}  