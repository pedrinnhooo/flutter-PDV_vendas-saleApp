
import '../../../../../common_files.dart';

class Login {
  PessoaGrupo _pessoaGrupo;
  List<Pessoa> _lojaList;  
  Pessoa _usuario;
  Terminal _terminal;
  String _token;
  String _idDevice;
  StatusLogin _statusLogin;
  String _msgErro;

  Login(
    {PessoaGrupo pessoaGrupo,
     List<Pessoa> lojaList,
     Pessoa usuario,
     Terminal terminal,
     String token,
     String idDevice,
     StatusLogin statusLogin = StatusLogin.loginOk,
     String msgErro=""}) {
    this._pessoaGrupo = pessoaGrupo;
    this._lojaList = lojaList != null ? lojaList : [];
    this._terminal = terminal;
    this._usuario = usuario != null ? usuario : Pessoa();
    this._token = token;
    this._statusLogin = statusLogin;
    this._msgErro = msgErro;
  }

  PessoaGrupo get pessoaGrupo => _pessoaGrupo;
  set pessoaGrupo(PessoaGrupo pessoaGrupo) => _pessoaGrupo = pessoaGrupo;
  List<Pessoa> get lojaList => _lojaList;
  set lojaList(List<Pessoa> lojaList) =>
      _lojaList = lojaList;
  Pessoa get usuario => _usuario;
  set usuario(Pessoa usuario) => _usuario = usuario;
  Terminal get terminal => _terminal;
  set terminal(Terminal terminal) => _terminal = terminal;
  String get token => _token;
  set token(String token) => _token = token;
  String get idDevice => _idDevice;
  set idDevice(String idDevice) => _idDevice = idDevice;
  StatusLogin get statusLogin => _statusLogin;
  set statusLogin(StatusLogin statusLogin) => _statusLogin = statusLogin;
  String get msgErro => _msgErro;
  set msgErro(String msgErro) => _msgErro = msgErro;

  Login.fromJson(Map<String, dynamic> json) {
    _pessoaGrupo = json['pessoa_grupo'] != null ? new PessoaGrupo.fromJson(json['pessoa_grupo']) : null;
    if (json['lojaList'] != null) {
      _lojaList = new List<Pessoa>();
      json['lojaList'].forEach((v) {
        _lojaList.add(new Pessoa.fromJson(v));
      });
    }
    _usuario = json['usuario'] != null ? new Pessoa.fromJson(json['usuario']) : null;
    _terminal = json['terminal'] != null ? new Terminal.fromJson(json['terminal']) : null;
    _token = json['token'];
    _idDevice = json['id_device'];
    _statusLogin = json['status_login'];
    _msgErro = json['msgErro'];
  }  

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._pessoaGrupo != null) {
      data['pessoa_grupo'] = this._pessoaGrupo.toJson();
    }
    if (this._lojaList != null) {
      data['lojaList'] =
          this._lojaList.map((v) => v.toJson()).toList();
    }
    if (this._usuario != null) {
      data['usuario'] = this._usuario.toJson();
    }
    if (this._terminal != null) {
      data['terminal'] = this._terminal.toJson();
    }
    data['token'] = this._token;
    data['id_device'] = this._idDevice;
    data['status_login'] = getStatusLoginIndex(this._statusLogin);
    data['msgErro'] = this._msgErro;
    return data;
  }


}