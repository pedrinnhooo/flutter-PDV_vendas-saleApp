import 'package:common_files/common_files.dart';

class PessoaModulo extends IEntity {
  int _id;
  int _idPessoa;
  int _idModuloGrupo;
  double _valor;
  int _ehAtivo;
  int _ehDemonstracao;
  DateTime _dataFinalDemonstracao;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;
  Modulo _modulo;

  PessoaModulo(
      {int id,
      int idPessoa,
      int idModuloGrupo,
      double valor,
      int ehAtivo,
      int ehDemonstracao,
      DateTime dataFinalDemonstracao,
      DateTime dataCadastro,
      DateTime dataAtualizacao,
      Modulo modulo}) {
    this._id = id;
    this._idPessoa = idPessoa;
    this._idModuloGrupo = idModuloGrupo;
    this._valor = valor;
    this._ehAtivo = ehAtivo;
    this._ehDemonstracao = ehDemonstracao;
    this._dataFinalDemonstracao = dataFinalDemonstracao;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
    this._modulo = modulo == null ? Modulo() : modulo;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoa => _idPessoa;
  set idPessoa(int idPessoa) => _idPessoa = idPessoa;
  int get idModuloGrupo => _idModuloGrupo;
  set idModuloGrupo(int idModuloGrupo) => _idModuloGrupo = idModuloGrupo;
  double get valor => _valor;
  set valor(double valor) => _valor = valor;
  int get ehAtivo => _ehAtivo;
  set ehAtivo(int ehAtivo) => _ehAtivo = ehAtivo;
  int get ehDemonstracao => _ehDemonstracao;
  set ehDemonstracao(int ehDemonstracao) => _ehDemonstracao = ehDemonstracao;
  DateTime get dataFinalDemonstracao => _dataFinalDemonstracao;
  set dataFinalDemonstracao(DateTime dataFinalDemonstracao) => _dataFinalDemonstracao = dataFinalDemonstracao;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;
  Modulo get modulo => _modulo;
  set modulo(Modulo modulo) => 
      _modulo = modulo; 

  String toString() {
    return '''
      id: ${_id.toString()},    
      idPessoa: ${_idPessoa.toString()},  
      idModuloGrupo: ${_idModuloGrupo.toString()},  
      valor: ${_valor.toString()},  
      ehAtivo: ${_ehAtivo.toString()},  
      ehDemonstracao: ${_ehDemonstracao.toString()}, 
      dataFinalDemonstracao: ${_dataFinalDemonstracao.toString()}, 
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }           

  PessoaModulo.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoa = json['id_pessoa'];
    _idModuloGrupo = json['id_modulo_grupo'];
    _valor = json['valor'];
    _ehAtivo = json['ehativo'];
    _ehDemonstracao = json['ehdemonstracao'];
    _dataFinalDemonstracao = json['data_final_demonstracao'];
    _dataCadastro = json['data_cadastro'];
    _dataAtualizacao = json['data_atualizacao'];
    if (json['modulo'] != null) {
      _modulo = Modulo.fromJson(json);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_pessoa'] = this._idPessoa;
    data['id_modulo_grupo'] = this._idModuloGrupo;
    data['valor'] = this._valor;
    data['ehativo'] = this._ehAtivo;
    data['ehdemonstracao'] = this._ehDemonstracao;
    data['data_final_demonstracao'] = this._dataFinalDemonstracao;
    data['data_cadastro'] = this._dataCadastro;
    data['data_atualizacao'] = this._dataAtualizacao;
    return data;
  }
}