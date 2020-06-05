import 'dart:convert';

import 'package:common_files/common_files.dart';
import 'package:common_files/src/model/entities/configuracao/terminal_impressora/terminal_impressora.dart';
import 'package:common_files/src/model/entities/configuracao/terminal_impressora/terminal_impressoraDao.dart';
import 'package:sqflite/sqflite.dart';

class TerminalDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "terminal";
  int filterId = 0;
  String filterText = "";
  FilterEhDeletado filterEhDeletado = FilterEhDeletado.naoDeletados;
  bool loadImpressora = false;
  Terminal terminal;
  List<Terminal> terminalList;
  TerminalImpressora terminalImpressora;
  List<TerminalImpressora> terminalImpressoraList;

  @override
  Dao dao;

  TerminalDAO(this._hasuraBloc, this._appGlobalBloc, {this.terminal}) {
    dao = Dao();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    try {
      this.terminal.id = map['id'];
      this.terminal.idPessoa = map['id_pessoa'];
      this.terminal.idTransacao = map['id_transacao'];
      this.terminal.idDevice = map['id_device'];
      this.terminal.nome = map['nome'];
      this.terminal.ehDeletado = map['ehdeletado'];
      this.terminal.dataCadastro = DateTime.parse(map['data_cadastro']);
      this.terminal.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
      this.terminal.mercadopagoIdTerminal = map['mercadopago_id_terminal'];
      this.terminal.mercadopagoQrCode = map['mercadopago_qr_code'];
      this.terminal.temPicpay = map['tem_picpay'];
      this.terminal.temControleCaixa = map['tem_controle_caixa'];
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<terminalDao> fromMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "terminalDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
    return this.terminal;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where;
    try {
      where = "id_pessoa = ${_appGlobalBloc.loja.id} ";
      List<dynamic> args = [];

      if (filterText != "") {
        where = where + "and (nome like '%" + filterText + "%')";
      }

      List list = await dao.getList(this, where, args);
      terminalList = List.generate(list.length, (i) {
        return Terminal(
          id: list[i]['id'],
          idPessoa: list[i]['id_pessoa'],
          idTransacao: list[i]['id_transacao'],
          idDevice: list[i]['id_device'],
          nome: list[i]['nome'],
          ehDeletado: list[i]['ehdeletado'],
          dataCadastro: DateTime.parse(list[i]['data_cadastro']),
          dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
          mercadopagoIdTerminal: list[i]['mercadopago_id_terminal'],
          mercadopagoQrCode: list[i]['mercadopago_qr_code'],
          temPicpay: list[i]['tem_picpay'],
          temControleCaixa: list[i]['tem_controle_caixa'],
        );
      });

      for(Terminal terminal in terminalList){
        if(loadImpressora){
          TerminalImpressora terminalImpressora = TerminalImpressora();
          TerminalImpressoraDAO terminalImpressoraDao = TerminalImpressoraDAO(_hasuraBloc, terminalImpressora, _appGlobalBloc);
          List<TerminalImpressora> terminalImpressoraList = await terminalImpressoraDao.getAll();
          terminal.terminalImpressora = terminalImpressoraList;
        }
      }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<terminalDao> getAll');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "terminalDao",
        nomeFuncao: "getAll",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: where
      );
    }   
    return terminalList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool completo=false,  bool id=false, bool idPessoa=false, bool idTransacao=false,
    bool idDevice=false, bool ehDeletado=false, bool dataCadastro=false, bool dataAtualizacao=false, 
    bool mercadopagoIdTerminal=false, bool mercadopagoQrCode=false, bool temPicpay=false, bool temControleCaixa=false,
    DateTime filtroDataAtualizacao, bool terminalImpressora = false, bool cupomLayout= false, int offset = 0, 
    String filtroNome="", FilterEhDeletado filterEhDeletado=FilterEhDeletado.naoDeletados}) async {
    String query;
    try {
      query = """ 
        {
          terminal(limit: $queryLimit, offset: $offset, where: {
            ehdeletado: {${filterEhDeletado != FilterEhDeletado.todos ? filterEhDeletado == FilterEhDeletado.naoDeletados ? "_eq: 0" : "_eq: 1" : ""}},
            nome: {${filtroNome != "" ? '_ilike:  '+'"filtroNome%"' : ''}},
            data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
            order_by: {${filtroDataAtualizacao == null ? 'nome: asc' : 'data_atualizacao: asc'}}) {
              ${completo || id ? "id" : ""}
              ${completo || idPessoa ? "id_pessoa" : ""}
              ${completo || idTransacao ? "id_transacao" : ""}
              ${completo || idDevice ? "id_device" : ""}
              nome
              ${completo || ehDeletado ? "ehdeletado" : ""}
              ${completo || dataCadastro ? "data_cadastro" : ""}
              ${completo || dataAtualizacao ? "data_atualizacao" : ""}
              ${completo || mercadopagoIdTerminal ? "mercadopago_id_terminal" : ""}
              ${completo || mercadopagoQrCode ? "mercadopago_qr_code" : ""}
              ${completo || temPicpay ? "tem_picpay" : ""}
              ${completo || temControleCaixa ? "tem_controle_caixa" : ""}
          }
        }
      """;

      query += terminalImpressora ? """
        terminal_impressoras {
          id
          id_terminal
          id_cupom_layout
          ip
          mac_address
          nome
          texto_cabecalho
          texto_rodape
          tipo_impressora
          ehdeletado
          data_cadastro
          data_atualizacao
          $cupomLayout ? "
            cupom_layout {
              id
              layout
              nome
              tamanho_papel
              data_cadastro
              data_atualizacao
            }" : ""
        } """ : "";

      var data = await _hasuraBloc.hasuraConnect.query(query);
      terminalList = [];
      List<TerminalImpressora> terminalImpressoraList;

      for(var i = 0; i < data['data']['terminal'].length; i++){
        terminalImpressoraList = [];
        if(data['data']['terminal'][i]['terminal_impressoras'] != null && data['data']['terminal'][i]['terminal_impressoras'].length > 0){
          data['data']['terminal'][i]['terminal_impressoras'].forEach((v) {
            terminalImpressoraList.add(TerminalImpressora.fromJson(v));
          });
        }

        terminalList.add(
          Terminal(
            id: data['data']['terminal'][i]['id'],
            idPessoa: data['data']['terminal'][i]['id_pessoa'],
            idTransacao: data['data']['terminal'][i]['id_transacao'],
            idDevice: data['data']['terminal'][i]['id_device'],
            nome: data['data']['terminal'][i]['nome'],
            ehDeletado: data['data']['terminal'][i]['ehdeletado'],
            dataCadastro: data['data']['terminal'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['terminal'][i]['data_cadastro']) : null,
            dataAtualizacao: data['data']['terminal'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['terminal'][i]['data_atualizacao']) : null,
            mercadopagoIdTerminal: data['data']['terminal'][i]['mercadopago_id_terminal'],
            mercadopagoQrCode: data['data']['terminal'][i]['mercadoapgo_qr_code'],
            temPicpay: data['data']['terminal'][i]['tem_picpay'],
            temControleCaixa: data['data']['terminal'][i]['tem_controle_caixa'],
            terminalImpressoraList: terminalImpressoraList
          )       
        );
      }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<terminalDao> getAllFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "terminalDao",
        nomeFuncao: "getAllFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
    }   
    return terminalList;
  }
  
  @override
  Future<IEntity> getById(int id) async {
    try {
      terminal = await dao.getById(this, id);
      TerminalImpressoraDAO terminalImpressoraDAO = TerminalImpressoraDAO(_hasuraBloc, terminalImpressora, _appGlobalBloc);
      terminalImpressoraDAO.filterTerminal = terminal.id;
      terminal.terminalImpressora = await terminalImpressoraDAO.getAll();
      return terminal;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<terminalDao> getById');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "terminalDao",
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
      query = """ 
        {
          terminal(where: {id: {_eq: $id}}) {
            id
            id_pessoa
            id_transacao
            id_device
            nome
            ehdeletado
            data_cadastro
            data_atualizacao
            mercadopago_id_terminal
            mercadopago_qr_code
            tem_picpay
            tem_controle_caixa
            transacao {
              id
              nome
            }
            terminal_impressoras {
              id
              id_terminal
              id_cupom_layout
              ip
              mac_address
              nome
              texto_cabecalho
              texto_rodape
              tipo_impressora
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
          }
        }
      """;

      print(query);

      var data = await _hasuraBloc.hasuraConnect.query(query);
      terminalImpressoraList = [];
      if(data['data']['terminal'][0]['terminal_impressoras'] != null && data['data']['terminal'][0]['terminal_impressoras'].length > 0){
        data['data']['terminal'][0]['terminal_impressoras'].forEach((v){
          terminalImpressoraList.add(TerminalImpressora.fromJson(v));
        });
      }

      Terminal _terminal = Terminal(
        id: data['data']['terminal'][0]['id'],
        idPessoa: data['data']['terminal'][0]['id_pessoa'],
        idTransacao: data['data']['terminal'][0]['id_transacao'],
        idDevice: data['data']['terminal'][0]['id_device'],
        nome: data['data']['terminal'][0]['nome'],
        ehDeletado: data['data']['terminal'][0]['ehdeletado'],
        dataCadastro: DateTime.parse(data['data']['terminal'][0]['data_cadastro']),
        dataAtualizacao: DateTime.parse(data['data']['terminal'][0]['data_atualizacao']),
        mercadopagoIdTerminal: data['data']['terminal'][0]['mercadopago_id_terminal'],
        mercadopagoQrCode: data['data']['terminal'][0]['mercadopago_qr_code'],
        temPicpay: data['data']['terminal'][0]['tem_picpay'],
        temControleCaixa: data['data']['terminal'][0]['tem_controle_caixa'],
        transacao: Transacao(
          id: data['data']['terminal'][0]['transacao']['id'],
          nome: data['data']['terminal'][0]['transacao']['nome'],
        ),
        terminalImpressoraList: terminalImpressoraList
      );
      return _terminal;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<terminalDao> getByIdFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "terminalDao",
        nomeFuncao: "getByIdFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
      return null;
    }   
  }

  Future<DateTime> getUltimaSincronizacao() async {
    try {
      List<Map> data = await dao.getRawQuery("select max(data_atualizacao) as data_atualizacao from terminal where id_pessoa = ${_appGlobalBloc.loja.id} ");
      return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<terminalDao> getUltimaSincronizacao');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "terminalDao",
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
      Database db = await dao.getDatabase();
        await db.transaction((txn) async {
          var batch = txn.batch();
          terminal.id = await txn.insert(tableName, this.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
          for (TerminalImpressora terminalImpressora in terminal.terminalImpressora) {
            terminalImpressora.idTerminal = terminal.id;
            batch.insert('terminal_impressora', terminalImpressora.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
          }
          var result = await batch.commit();
          print(result.toString());
        }
      );
      //this.terminal.id = await dao.insert(this);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<terminalDao> insert');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "terminalDao",
        nomeFuncao: "insert",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: terminal.toString()
      );
    }
    return this.terminal;   
  }

  Future<IEntity> saveOnServer() async {
    String _query;
    try {
      _query = """ mutation saveTerminal {
        update_sincronizacao(where: {}, _set: {data_atualizacao: "now()"}) {
          returning {
            data_atualizacao
          }
        }

        insert_terminal(objects: {
      """;

      String _queryterminalImpressora = "";
      if (terminal.terminalImpressora.length != 0) {
        for (var i=0; i < terminal.terminalImpressora.length; i++){
          print("for terminalImpressora");
          if (i == 0) {
            _queryterminalImpressora = '{data: [';
          }  

          if ((terminal.terminalImpressora[i].id != null) && (terminal.terminalImpressora[i].id > 0)) {
            _queryterminalImpressora += "{id: ${terminal.terminalImpressora[i].id},";
          } else {
            _queryterminalImpressora += "{";
          }    

          _queryterminalImpressora +=  
            """ 
              ip: "${terminal.terminalImpressora[i].ip}", 
              id_cupom_layout: ${terminal.terminalImpressora[i].idCupomLayout}
              mac_address: "${terminal.terminalImpressora[i].macAddress}", 
              nome: "${terminal.terminalImpressora[i].nome}", 
              texto_cabecalho: "${terminal.terminalImpressora[i].textoCabecalho}",
              texto_rodape: "${terminal.terminalImpressora[i].textoRodape}",
              tipo_impressora: "${terminal.terminalImpressora[i].tipoImpressora}", 
              ehdeletado: ${terminal.terminalImpressora[i].ehDeletado},
              data_atualizacao: "now()" 
            }  
            """;
          if (i == terminal.terminalImpressora.length-1){
            _queryterminalImpressora += 
              """],
                  on_conflict: {
                    constraint: terminal_impressora_pkey, 
                    update_columns: [
                      ip,
                      id_cupom_layout,
                      mac_address,
                      nome,
                      texto_cabecalho,
                      texto_rodape,
                      tipo_impressora,
                      ehdeletado,
                      data_atualizacao
                    ]
                  }  
                },
              """;
          }
        }
      }  
      print("_queryTerminalImpressora: "+_queryterminalImpressora);

      if ((terminal.id != null) && (terminal.id > 0)) {
        _query = _query + "id: ${terminal.id},";
      }    

      _query = _query + """
          id_transacao: ${terminal.idTransacao}, 
          id_device: "${terminal.idDevice}", 
          nome: "${terminal.nome}", 
          ehdeletado: ${terminal.ehDeletado}, 
          mercadopago_id_terminal: "${terminal.mercadopagoIdTerminal}",
          mercadopago_qr_code: "${terminal.mercadopagoQrCode}",
          tem_picpay: ${terminal.temPicpay},
          tem_controle_caixa: ${terminal.temControleCaixa},
          data_atualizacao: "now()"},
        """;
      _query = _queryterminalImpressora != "" ? _query + ", terminal_impressoras: $_queryterminalImpressora" : _query;
      _query += """
          on_conflict: {
            constraint: terminal_pkey, 
            update_columns: [
              id_transacao,
              id_device,
              nome, 
              ehdeletado,
              data_atualizacao,
              mercadopago_id_terminal,
              mercadopago_qr_code,
              tem_picpay
              tem_controle_caixa
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
        terminal.id = data["data"]["insert_terminal"]["returning"][0]["id"];
        return terminal;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<terminalDao> saveOnServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "terminalDao",
        nomeFuncao: "saveOnServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: _query,
        object: terminal.toString()
      );
      return null;
    }
  }

  @override
  Future<IEntity> delete(int id) async {
    return terminal;
  }  

  @override
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': this.terminal.id,
        'id_pessoa': this.terminal.idPessoa,
        'id_transacao': this.terminal.idTransacao,
        'id_device': this.terminal.idDevice,
        'nome': this.terminal.nome,
        'ehdeletado': this.terminal.ehDeletado,
        'data_cadastro': this.terminal.dataCadastro.toString(),
        'data_atualizacao': this.terminal.dataAtualizacao.toString(),
        'mercadopago_id_terminal' : this.terminal.mercadopagoIdTerminal,
        'mercadopago_qr_code' : this.terminal.mercadopagoQrCode,
        'tem_picpay' : this.terminal.temPicpay,
        'tem_controle_caixa' : this.terminal.temControleCaixa
      };
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<terminalDao> toMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "terminalDao",
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
