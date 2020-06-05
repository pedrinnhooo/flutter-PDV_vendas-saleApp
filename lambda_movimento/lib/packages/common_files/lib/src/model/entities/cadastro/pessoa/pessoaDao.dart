import 'package:common_files/src/bloc/hasura_bloc.dart';
import 'package:common_files/src/model/dao/dao.dart';
import 'package:common_files/src/model/entities/cadastro/contato/contato.dart';
import 'package:common_files/src/model/entities/cadastro/contato/contatoDao.dart';
import 'package:common_files/src/model/entities/cadastro/endereco/endereco.dart';
import 'package:common_files/src/model/entities/cadastro/endereco/enderecoDao.dart';
import 'package:common_files/src/model/entities/cadastro/pessoa/pessoa.dart';
import 'package:common_files/src/model/entities/interfaces.dart';

class PessoaDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  final String tableName = "pessoa";
  int filterId;
  String filterText;
  bool filterEhLoja = false;
  bool filterEhCliente = false;
  bool filterEhFornecedor = false;
  bool filterEhVendedor = false;
  bool filterEhRevenda = false;
  bool loadEndereco = false;
  bool loadContato = false;

  Pessoa pessoa;
  List<Pessoa> pessoaList;
  Endereco _endereco;
  Contato _contato;

  @override
  Dao dao;

  PessoaDAO(this._hasuraBloc, this.pessoa) {
    dao = Dao();
    _endereco = Endereco();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    this.pessoa.id = map['id'];
    this.pessoa.idPessoaGrupo = map['id_pessoa_grupo'];
    this.pessoa.razaoNome = map['razao_social'];
    this.pessoa.fantasiaApelido = map['fantasia_apelido'];
    this.pessoa.cnpjCpf = map['cnpj_cpf'];
    this.pessoa.ieRg = map['ir_rg'];
    this.pessoa.im = map['im'];
    this.pessoa.ehFisica = map['ehfisica'];
    this.pessoa.ehLoja = map['ehloja'];
    this.pessoa.ehCliente = map['ehcliente'];
    this.pessoa.ehFornecedor = map['ehfornecedor'];
    this.pessoa.ehVendedor = map['ehvendedor'];
    this.pessoa.ehRevenda = map['ehrevenda'];
    this.pessoa.ehDeletado = map['ehdeletado'];
    this.pessoa.dataCadastro = map['data_cadastro'];
    this.pessoa.dataAtualizacao = map['data_atualizacao'];
    return this.pessoa;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where = " 1 = 1 and ehdeletado = 0 ";
    List<dynamic> args = [];
    if ((filterId > 0) || (filterText != "")) {
      if (filterId > 0) {
        where = where + "and (id = " + filterText + ")";
      }
      if (filterText != "") {
        where = where + "and (nome like '%" + filterText + "%')";
      }
    }

    where = filterEhLoja ? where + " and ehloja = 1 " : where;
    where = filterEhCliente ? where + " and ehcliente = 1 " : where;
    where = filterEhFornecedor ? where + " and ehfornecedor = 1 " : where;
    where = filterEhVendedor ? where + " and ehvendedor = 1 " : where;
    where = filterEhRevenda ? where + " and ehrevenda = 1 " : where;

    List list = await dao.getList(this, where, args);
    pessoaList = List.generate(list.length, (i) {
      return Pessoa(
        id: list[i]['id'],
        idPessoaGrupo: list[i]['id_pessoa_grupo'],
        razaoNome: list[i]['razao_social'],
        fantasiaApelido: list[i]['fantasia_apelido'],
        cnpjCpf: list[i]['cnpj_cpf'],
        ieRg: list[i]['ir_rg'],
        im: list[i]['im'],
        ehFisica: list[i]['ehfisica'],
        ehLoja: list[i]['ehloja'],
        ehCliente: list[i]['ehcliente'],
        ehFornecedor: list[i]['ehfornecedor'],
        ehVendedor: list[i]['ehvendedor'],
        ehRevenda: list[i]['ehrevenda'],
        ehDeletado: list[i]['ehdeletado'],
        dataCadastro: list[i]['data_cadastro'],
        dataAtualizacao: list[i]['data_atualizacao'],
      );
    });
   
    if (preLoad) {
      for (var pessoa in pessoaList) {
        EnderecoDAO enderecoDAO = EnderecoDAO(_hasuraBloc, _endereco);
        ContatoDAO contatoDAO = ContatoDAO(_hasuraBloc, _contato);
        if (loadEndereco) {
          enderecoDAO.filterIdPessoa = pessoa.id;
          List<Endereco> enderecoList =
              await enderecoDAO.getAll();
          pessoa.endereco = enderecoList;
        }
       
        if (loadContato) {
          enderecoDAO.filterIdPessoa = pessoa.id;
          List<Contato> contatoList =
              await contatoDAO.getAll();
          pessoa.contato = contatoList;
        }
        enderecoDAO = null;
      }
    }

    return pessoaList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool id=false, bool idPessoaGrupo=false,
    bool razaoNome=false, bool cnpjCpf=false, bool ieRg=false,
    bool im=false, bool ehFisica=false, bool ehDeletado=false, bool dataCadastro=false, 
    bool dataAtualizacao=false, bool contato=false, bool contatoApenasNome=true, 
    bool endereco=false, bool enderecoApenasApelido=true,
    String filtroNome=""}) async {
    
    String queryContato = """
      contatos(where: {ehdeletado: {_eq: 0}}) {
        nome
        ${!contatoApenasNome ? "telefone1" : ""}
        ${!contatoApenasNome ? "telefone2" : ""}
        ${!contatoApenasNome ? "email" : ""}
        ehprincipal
      }
    """;
    
    String queryEndereco = """
      enderecos(where: {ehdeletado: {_eq: 0}}) {
        apelido
        ${!enderecoApenasApelido ? "cep" : ""}
        ${!enderecoApenasApelido ? "logradouro" : ""}
        ${!enderecoApenasApelido ? "numero" : ""}
        ${!enderecoApenasApelido ? "complemento" : ""}
        ${!enderecoApenasApelido ? "bairro" : ""}
        ${!enderecoApenasApelido ? "municipio" : ""}
        ${!enderecoApenasApelido ? "estado" : ""}
        ${!enderecoApenasApelido ? "ibge_municipio" : ""}
        ${!enderecoApenasApelido ? "pais" : ""}
      }
    """;
    
    String query = """ 
      {
        pessoa(where: {
          ehcliente: {${filterEhCliente ?'_eq: "1"': ''}},
          ehfornecedor: {${filterEhFornecedor ?'_eq: "1"': ''}},
          ehloja: {${filterEhLoja ?'_eq: "1"': ''}},
          ehvendedor: {${filterEhVendedor ?'_eq: "1"': ''}}, 
          ehrevenda: {${filterEhRevenda ?'_eq: "1"': ''}},
          _or: [
            {fantasia_apelido: {${filtroNome != "" ? '_ilike:  '+'"$filtroNome%"' : ''}}}, 
            {razao_nome: {${filtroNome != "" ? '_ilike:  '+'"$filtroNome%"' : ''}}}
          ]}, 
          order_by: {fantasia_apelido: asc}
        ) {
          ${id ? "id" : ""}
          ${idPessoaGrupo ? "id_pessoa_grupo" : ""}
          razao_nome
          fantasia_apelido
          ${cnpjCpf ? "cnpj_cpf" : ""}
          ${ieRg ? "ir_rg" : ""}
          ${im ? "im" : ""}
          ${ehFisica ? "ehfisica" : ""}
          ${ehDeletado ? "ehdeletado" : ""}
          ${dataCadastro ? "data_cadastro" : ""}
          ${contato ? queryContato : ""}
          ${endereco ? queryEndereco : ""}
        }
      }        
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    pessoaList = [];

    var contatoList = new List<Contato>();
    var enderecoList = new List<Endereco>();
    
    for(var i = 0; i < data['data']['pessoa'].length; i++){
      if (data['data']['pessoa'][i]['contatos'] != null) {
        data['data']['pessoa'][i]['contatos'].forEach((v) {
          contatoList.add(new Contato.fromJson(v));
        });
      }
      
      if (data['data']['pessoa'][i]['enderecos'] != null) {
        data['data']['pessoa'][i]['enderecos'].forEach((v) {
          enderecoList.add(new Endereco.fromJson(v));
        });
      }

      pessoaList.add(
        Pessoa(
          id: data['data']['pessoa'][i]['id'],
          idPessoaGrupo: data['data']['pessoa'][i]['id_pessoa'],
          razaoNome: data['data']['pessoa'][i]['razao_nome'],
          fantasiaApelido: data['data']['pessoa'][i]['fantasia_apelido'],
          cnpjCpf: data['data']['pessoa'][i]['cnpj_cpf'],
          ieRg: data['data']['pessoa'][i]['ie_rg'],
          im: data['data']['pessoa'][i]['im'],
          ehFisica: data['data']['pessoa'][i]['ehfisica'],
          ehCliente: data['data']['pessoa'][i]['ehcliente'],
          ehFornecedor: data['data']['pessoa'][i]['ehfornecedor'],
          ehVendedor: data['data']['pessoa'][i]['ehvendedor'],
          ehLoja: data['data']['pessoa'][i]['ehloja'],
          ehRevenda: data['data']['pessoa'][i]['ehrevenda'],
          ehDeletado: data['data']['pessoa'][i]['ehdeletado'],
          dataCadastro: data['data']['pessoa'][i]['data_cadastro'],
          dataAtualizacao: data['data']['pessoa'][i]['data_atualizacao'],
          contato: contatoList,
          endereco: enderecoList
        )       
      );
    }
    return pessoaList;
  }

  @override
  Future<IEntity> getById(int id) async {
    pessoa = await dao.getById(this, id);
    return pessoa;
  }

  Future<IEntity> getByIdFromServer(int id) async {
    String query = """ 
      {
        pessoa(where: {id: {_eq: $id}}) {
          id
          id_pessoa_grupo
          razao_nome
          fantasia_apelido
          cnpj_cpf
          ie_rg
          im
          ehfisica
          ehcliente
          ehfornecedor
          ehvendedor
          ehloja
          ehrevenda
          ehdeletado
          data_cadastro
          data_atualizacao
          contatos(where: {ehdeletado: {_eq: 0}}) {
            id
            id_pessoa
            nome
            telefone1
            telefone2
            email
            ehprincipal
            ehdeletado
            data_cadastro
            data_atualizacao
          }
          enderecos(where: {ehdeletado: {_eq: 0}}) {
            id
            id_pessoa
            apelido
            cep
            logradouro
            numero
            complemento
            bairro
            municipio
            estado
            ibge_municipio
            pais
            ehdeletado
            data_cadastro
            data_atualizacao
          }
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    
    var contatoList = new List<Contato>();
    var enderecoList = new List<Endereco>();
    
    if (data['data']['pessoa'][0]['contatos'] != null) {
      data['data']['pessoa'][0]['contatos'].forEach((v) {
        contatoList.add(new Contato.fromJson(v));
      });
    }
    
    if (data['data']['pessoa'][0]['enderecos'] != null) {
      data['data']['pessoa'][0]['enderecos'].forEach((v) {
        enderecoList.add(new Endereco.fromJson(v));
      });
    }
    
    Pessoa _pessoa = Pessoa(
      id: data['data']['pessoa'][0]['id'],
      idPessoaGrupo: data['data']['pessoa'][0]['id_pessoa'],
      razaoNome: data['data']['pessoa'][0]['razao_nome'],
      fantasiaApelido: data['data']['pessoa'][0]['fantasia_apelido'],
      cnpjCpf: data['data']['pessoa'][0]['cnpj_cpf'],
      ieRg: data['data']['pessoa'][0]['ie_rg'],
      im: data['data']['pessoa'][0]['im'],
      ehFisica: data['data']['pessoa'][0]['ehfisica'],
      ehCliente: data['data']['pessoa'][0]['ehcliente'],
      ehFornecedor: data['data']['pessoa'][0]['ehfornecedor'],
      ehVendedor: data['data']['pessoa'][0]['ehvendedor'],
      ehLoja: data['data']['pessoa'][0]['ehloja'],
      ehRevenda: data['data']['pessoa'][0]['ehrevenda'],
      ehDeletado: data['data']['pessoa'][0]['ehdeletado'],
      dataCadastro: DateTime.parse(data['data']['pessoa'][0]['data_cadastro']),
      dataAtualizacao: DateTime.parse(data['data']['pessoa'][0]['data_atualizacao']),
      contato: contatoList,
      endereco: enderecoList
    );
    return _pessoa;
  }

  @override
  Future<IEntity> insert() async {
    this.pessoa.id = await dao.insert(this);
    return this.pessoa;
  }

  Future<IEntity> saveOnServer() async {
    String _query;
    String _queryContato="";
    String _queryEndereco="";

    for (var i = 0; i < pessoa.contato.length; i++) {
      if (i == 0) {
        _queryContato = '{data: [';
      }    

      if ((pessoa.contato[i].id != null) && (pessoa.contato[i].id > 0)) {
        _queryContato = _queryContato + "{id: ${pessoa.contato[i].id},";
      } else {
        _queryContato = _queryContato + "{";
      }   
      
      _queryContato = _queryContato + 
        """
          nome: "${pessoa.contato[i].nome}",
          telefone1: "${pessoa.contato[i].telefone1}",
          telefone2: "${pessoa.contato[i].telefone2}",
          email: "${pessoa.contato[i].email}",
          ehprincipal: ${pessoa.contato[i].ehPrincipal},
          ehdeletado: ${pessoa.contato[i].ehDeletado},
          data_cadastro: "${pessoa.contato[i].dataCadastro}",
          data_atualizacao: "${pessoa.contato[i].dataAtualizacao}" 
        },  
        """; 

      if (i == pessoa.contato.length-1){
        _queryContato = _queryContato + 
          """],
              on_conflict: {
                constraint: contato_pkey, 
                update_columns: [
                  nome,
                  telefone1,
                  telefone2,
                  email,
                  ehprincipal,
                  ehdeletado,
                  data_atualizacao
                ]
              }  
            },
          """;
      }                  
    }

    for (var i = 0; i < pessoa.endereco.length; i++) {
      if (i == 0) {
        _queryEndereco = '{data: [';
      }    

      if ((pessoa.endereco[i].id != null) && (pessoa.endereco[i].id > 0)) {
        _queryEndereco = _queryEndereco + "{id: ${pessoa.endereco[i].id},";
      } else {
        _queryEndereco = _queryEndereco + "{";
      }   
      
      _queryEndereco = _queryEndereco + 
        """
          apelido: "${pessoa.endereco[i].apelido}",
          cep: "${pessoa.endereco[i].cep}",
          logradouro: "${pessoa.endereco[i].logradouro}",
          numero: "${pessoa.endereco[i].numero}",
          complemento: "${pessoa.endereco[i].complemento}",
          bairro: "${pessoa.endereco[i].bairro}",
          municipio: "${pessoa.endereco[i].municipio}",
          estado: "${pessoa.endereco[i].estado}",
          ibge_municipio: "${pessoa.endereco[i].ibgeMunicipio}",
          pais: "${pessoa.endereco[i].pais}",
          ehdeletado: ${pessoa.endereco[i].ehDeletado},
          data_cadastro: "${pessoa.endereco[i].dataCadastro}",
          data_atualizacao: "${pessoa.endereco[i].dataAtualizacao}" 
        },  
        """; 

      if (i == pessoa.endereco.length-1){
        _queryEndereco = _queryEndereco + 
          """],
              on_conflict: {
                constraint: endereco_pkey, 
                update_columns: [
                  apelido,
                  cep,
                  logradouro,
                  numero,
                  complemento,
                  bairro,
                  municipio,
                  estado,
                  ibge_municipio,
                  pais,
                  ehdeletado,
                  data_atualizacao
                ]
              }  
            },
          """;
      }                  
    } 

    _query = """ mutation savePessoa {
        insert_pessoa(objects: {""";

    if ((pessoa.id != null) && (pessoa.id > 0)) {
      _query = _query + "id: ${pessoa.id},";
    }    

    _query = _query + """
        razao_nome: "${pessoa.razaoNome}", 
        fantasia_apelido: "${pessoa.fantasiaApelido}", 
        cnpj_cpf: "${pessoa.cnpjCpf}", 
        ie_rg: "${pessoa.ieRg}", 
        im: "${pessoa.im}", 
        ehfisica: ${pessoa.ehFisica}, 
        ehcliente: ${pessoa.ehCliente}, 
        ehfornecedor: ${pessoa.ehFornecedor}, 
        ehvendedor: ${pessoa.ehVendedor}, 
        ehloja: ${pessoa.ehLoja}, 
        ehrevenda: ${pessoa.ehRevenda}, 
        ehdeletado: ${pessoa.ehDeletado}, 
        data_cadastro: "${pessoa.dataCadastro}",
        data_atualizacao: "${pessoa.dataAtualizacao}",""";
        _query = _queryContato!= "" ? _query + "contatos: $_queryContato" : _query; 
        _query = _queryEndereco!= "" ? _query + "enderecos: $_queryEndereco" : _query; 
        _query = _query + """
        }
        on_conflict: {
          constraint: pessoa_pkey, 
          update_columns: [
            razao_nome, 
            fantasia_apelido,
            cnpj_cpf,
            ie_rg,
            im,
            ehfisica,
            ehcliente,
            ehfornecedor,
            ehvendedor,
            ehloja
            ehrevenda,
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

    try {
      var data = await _hasuraBloc.hasuraConnect.mutation(_query);
      pessoa.id = data["data"]["insert_pessoa"]["returning"][0]["id"];
      return pessoa;
    } catch (error) {
      return null;
    }  
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': pessoa.id,
      'id_pessoa_grupo': pessoa.idPessoaGrupo,
      'razao_social': pessoa.razaoNome,
      'fantasia_apelido': pessoa.fantasiaApelido,
      'cnpj_cpf': pessoa.cnpjCpf,
      'ir_rg': pessoa.ieRg,
      'im': pessoa.im,
      'ehfisica': pessoa.ehFisica,
      'ehloja': pessoa.ehLoja,
      'ehcliente': pessoa.ehCliente,
      'ehfornecedor': pessoa.ehFornecedor,
      'ehvendedor': pessoa.ehVendedor,
      'ehrevenda': pessoa.ehRevenda,
      'ehdeletado': pessoa.ehDeletado,
      'data_cadastro': pessoa.dataCadastro,
      'data_atualizacao': pessoa.dataAtualizacao,
    };
  }
}
