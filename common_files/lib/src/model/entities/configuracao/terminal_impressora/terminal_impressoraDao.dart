import 'dart:convert';
import 'package:common_files/common_files.dart';
import 'package:common_files/src/model/entities/configuracao/terminal_impressora/terminal_impressora.dart';

class TerminalImpressoraDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "terminal_impressora";
  int filterId = 0;
  String filterText = "";
  int filterTerminal = 0;
  TerminalImpressora _terminalImpressora;
  List<TerminalImpressora> terminalImpressoraList;

  @override
  Dao dao;

  TerminalImpressoraDAO(this._hasuraBloc, this._terminalImpressora, this._appGlobalBloc) {
    dao = Dao();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    try {
      this._terminalImpressora.id = map['id'];
      this._terminalImpressora.idPessoa = map['id_pessoa'];
      this._terminalImpressora.idTerminal = map['id_terminal'];
      this._terminalImpressora.idCupomLayout = map['id_cupom_layout'];
      this._terminalImpressora.nome = map['nome'];
      this._terminalImpressora.tipoImpressora = map['tipo_impressora'];
      this._terminalImpressora.macAddress = map['mac_address'];
      this._terminalImpressora.ip = map['ip'];
      this._terminalImpressora.textoCabecalho = map['texto_cabecalho'];
      this._terminalImpressora.textoRodape = map['texto_rodape'];
      this._terminalImpressora.ehDeletado = map['ehdeletado'];
      this._terminalImpressora.dataCadastro = DateTime.parse(map['data_cadastro']);
      this._terminalImpressora.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<terminal_impressoraDao> fromMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "terminal_impressoraDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }
    return this._terminalImpressora;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where;
    try {
      where = "id_pessoa = ${_appGlobalBloc.loja.idPessoa} ";
      List<dynamic> args = [];

      if (filterText != "") {
        where = where + "and (nome like '%" + filterText + "%') ";
      }

      if(filterTerminal > 0){
        where += "and (id_terminal = ${filterTerminal.toString()}) "; 
      }

      List list = await dao.getList(this, where, args);
      terminalImpressoraList = List.generate(list.length, (i) {
        return TerminalImpressora(
          id: list[i]['id'],
          idPessoa: list[i]['id_pessoa'],
          idTerminal: list[i]['id_terminal'],
          idCupomLayout: list[i]['id_cupom_layout'],
          nome: list[i]['nome'],
          tipoImpressora: list[i]['tipo_impressora'],
          macAddress: list[i]['mac_address'],
          ip: list[i]['ip'],
          textoCabecalho: list[i]['texto_cabecalho'],
          textoRodape: list[i]['texto_rodape'],
          ehDeletado: list[i]['ehdeletado'],
          dataCadastro: list[i]['data_cadastro'] != null ? DateTime.parse(list[i]['data_cadastro']) : null,
          dataAtualizacao: list[i]['data_atualizacao'] != null ? DateTime.parse(list[i]['data_atualizacao']) : null,
        );
      });
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<terminal_impressoraDao> getAll');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "terminal_impressoraDao",
        nomeFuncao: "getAll",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: where
      );
    }
    return terminalImpressoraList;
  }

  Future<List> getAllFromServer({bool id=false, bool idPessoa=false,
    bool idTerminal=true, bool tipoImpressora=false, bool macAddress=false,
    bool ip=false, bool ehDeletado=false, bool idCupomLayout=false,
    bool textoCabecalho=false, bool textoRodape=false,
    bool dataCadastro=false, bool dataAtualizacao=false, 
    DateTime filtroDataAtualizacao}) async {
    String query;
    try {
      query = """ 
      {
        terminal_impressora(where: {
          data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
          order_by: {data_atualizacao: asc}) {
            ${id ? "id" : ""}
            ${idPessoa ? "id_pessoa" : ""}
            ${idTerminal ? "id_terminal" : ""}
            ${idCupomLayout ? "id_cupom_layout": ""}
            nome
            ${tipoImpressora ? "tipo_impressora" : ""}
            ${macAddress ? "mac_address" : ""}
            ${ip ? "ip" : ""}
            ${textoCabecalho ? "texto_cabecalho" : ""}
            ${textoRodape ? "texto_rodape" : ""}
            ${ehDeletado ? "ehdeletado" : ""}
            ${dataCadastro ? "data_cadastro" : ""}
            ${dataAtualizacao ? "data_atualizacao" : ""}
        } 
      }""";
      
      var data = await _hasuraBloc.hasuraConnect.query(query);
      terminalImpressoraList = [];

      for(var i = 0; i < data['data']['terminal_impressora'].length; i++){
        terminalImpressoraList.add(
          TerminalImpressora(
            id: data['data']['terminal_impressora'][i]['id'],
            idPessoa: data['data']['terminal_impressora'][i]['id_pessoa'],
            idTerminal: data['data']['terminal_impressora'][i]['id_terminal'],
            idCupomLayout: data['data']['terminal_impressora'][i]['id_cupom_layout'],
            nome: data['data']['terminal_impressora'][i]['nome'],
            tipoImpressora: data['data']['terminal_impressora'][i]['tipo_impressora'],
            macAddress: data['data']['terminal_impressora'][i]['mac_address'],
            ip: data['data']['terminal_impressora'][i]['ip'],
            textoCabecalho: data['data']['terminal_impressora'][i]['texto_cabecalho'],
            textoRodape: data['data']['terminal_impressora'][i]['texto_rodape'],
            ehDeletado: data['data']['terminal_impressora'][i]['ehdeletado'],
            dataCadastro: data['data']['terminal_impressora'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['terminal_impressora'][i]['data_cadastro']) : null,
            dataAtualizacao: data['data']['terminal_impressora'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['terminal_impressora'][i]['data_atualizacao']) : null
          )       
        );
      }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<terminal_impressoraDao> getAllFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "terminal_impressoraDao",
        nomeFuncao: "getAllFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
    }
    return terminalImpressoraList;
  }
  
  @override
  Future<IEntity> getById(int id) async {
    try {
      return await dao.getById(this, id);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<terminal_impressoraDao> getById');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "terminal_impressoraDao",
        nomeFuncao: "getById",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: "id: $id"
      );
      return null;
    }
  }

  Future<IEntity> getByIdFromServer(int id) async {
    String query;
    try {
      query = """ query terminal_impressora {
        terminal_impressora(where: {id: {_eq: $id}}) {
          id
          id_pessoa
          id_terminal
          id_cupom_layout
          nome
          tipo_impressora
          mac_address
          ip
          texto_cabecalho
          texto_rodape
          ehdeletado
          data_cadastro
          data_atualizacao
          cupom_layout {
            id
            layout
            nome
            tamanho_papel
            data_cadastro
            data_atualizacao
          }
        }
      }""";
      
      var data = await _hasuraBloc.hasuraConnect.query(query);
      TerminalImpressora _terminalImpressora = TerminalImpressora(
        id: data['data']['terminal_impressora'][0]['id'],
        idPessoa: data['data']['terminal_impressora'][0]['id_pessoa'],
        idTerminal: data['data']['terminal_impressora'][0]['id_terminal'],
        idCupomLayout: data['data']['terminal_impressora'][0]['id_cupom_layout'],
        nome: data['data']['terminal_impressora'][0]['nome'],
        tipoImpressora: data['data']['terminal_impressora'][0]['tipo_impressora'],
        macAddress: data['data']['terminal_impressora'][0]['mac_address'],
        ip: data['data']['terminal_impressora'][0]['ip'],
        textoCabecalho: data['data']['terminal_impressora'][0]['texto_cabecalho'],
        textoRodape: data['data']['terminal_impressora'][0]['texto_rodape'],
        ehDeletado: data['data']['terminal_impressora'][0]['ehdeletado'],
        dataCadastro: data['data']['terminal_impressora'][0]['data_cadastro'] != null ? DateTime.parse(data['data']['terminal_impressora'][0]['data_cadastro']) : null,
        dataAtualizacao: data['data']['terminal_impressora'][0]['data_atualizacao'] != null ? DateTime.parse(data['data']['terminal_impressora'][0]['data_atualizacao']) : null,
        cupomLayout: CupomLayout.fromJson(data['data']['terminal_impressora'][0]['cupom_layout'])
      );
      return _terminalImpressora;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<terminal_impressoraDao> getByIdFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "terminal_impressoraDao",
        nomeFuncao: "getByIdFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
    }
  }

  Future<DateTime> getUltimaSincronizacao() async {
    try {
      List<Map> data = await dao.getRawQuery("select max(data_atualizacao) as data_atualizacao from terminal_impressora where id_pessoa = ${_appGlobalBloc.terminal.idPessoa} ");
      return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<terminal_impressoraDao> getUltimaSincronizacao');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "terminal_impressoraDao",
        nomeFuncao: "getUltimaSincronizacao",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      return DateTime.now();
    }
  }

  @override
  Future<IEntity> insert() async {
    try {
      this._terminalImpressora.id = await dao.insert(this);
      return this._terminalImpressora;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<terminal_impressoraDao> insert');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "terminal_impressoraDao",
        nomeFuncao: "insert",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: _terminalImpressora.toString()
      );
      return null;
    }
  }

  Future<IEntity> saveOnServer() async {
    String _query;
    try {
      _query = """  mutation saveConfiguracaoImpressora {
        update_sincronizacao(where: {}, _set: {data_atualizacao: "now()"}) {
          returning {
            data_atualizacao
          }
        }

        insert_terminal_impressora(objects: {
      """;      

      if ((_terminalImpressora.id != null) && (_terminalImpressora.id > 0)) {
        _query = _query + "id: ${_terminalImpressora.id},";
      }    

      _query = _query + """ 
          id_terminal: ${_terminalImpressora.idTerminal},
          id_cupom_layout: "${_terminalImpressora.idCupomLayout},
          nome: "${_terminalImpressora.nome}",
          tipo_impressora: "${_terminalImpressora.tipoImpressora}",
          mac_address: "${_terminalImpressora.macAddress}",
          ip: "${_terminalImpressora.ip}",
          texto_cabecalho: "${_terminalImpressora.textoCabecalho}",
          texto_rodape: "${_terminalImpressora.textoRodape}",
          ehdeletado: ${_terminalImpressora.ehDeletado},
          data_atualizacao: "now()"},
          on_conflict: {
            constraint: terminal_impressora_pkey, 
            update_columns: [
              id_terminal,
              id_cupom_layout
              nome,
              tipo_impressora,
              mac_address,
              ip,
              texto_cabecalho,
              texto_rodape,
              ehdeletado,
              data_atualizacao
            ]
          }) {
          returning {
            id
          }
        }
      }  
      """; 

      print(_query);

      var data = await _hasuraBloc.hasuraConnect.mutation(_query);
      _terminalImpressora.id = data["data"]["terminal_impressora"]["returning"][0]["id"];
      return _terminalImpressora;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<terminal_impressoraDao> saveOnServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "terminal_impressoraDao",
        nomeFuncao: "saveOnServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: _query,
        object: _terminalImpressora.toString()
      );
      return null;
    }
  }

  @override
  Future<IEntity> delete(int id) async {
    return _terminalImpressora;
  }  

  @override
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': this._terminalImpressora.id,
        'id_pessoa': this._terminalImpressora.idPessoa,
        'id_terminal': this._terminalImpressora.idTerminal,
        'id_cupom_layout': this._terminalImpressora.idCupomLayout,
        'nome': this._terminalImpressora.nome,
        'tipo_impressora': this._terminalImpressora.tipoImpressora,
        'mac_address': this._terminalImpressora.macAddress,
        'ip': this._terminalImpressora.ip,
        'texto_cabecalho': this._terminalImpressora.textoCabecalho,
        'texto_rodape': this._terminalImpressora.textoRodape,
        'ehdeletado': this._terminalImpressora.ehDeletado,
        'data_cadastro': this._terminalImpressora.dataCadastro.toString(),
        'data_atualizacao': this._terminalImpressora.dataAtualizacao.toString(),
      };
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<terminal_impressoraDao> toMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "terminal_impressoraDao",
        nomeFuncao: "toMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      return null;
    }
  }

  String entityToJson() {
    final dyn = toMap();
    return json.encode(dyn);
  }

  IEntity entityFromJson(String str) {
    final jsonData = json.decode(str);
    return fromMap(jsonData);
  }
}
