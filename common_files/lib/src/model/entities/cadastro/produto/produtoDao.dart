import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:common_files/common_files.dart';

class ProdutoDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "produto";
  int filterCategoria;
  String filterText;
  bool filterEhativo = true;
  int filterPrecoTabela = 1;
  String filterCodigoBarras="";
  bool loadCategoria = false;
  bool loadGrade = false;
  bool loadProdutoImagem = false;
  bool loadProdutoVariante = false;
  bool loadPrecoTabela = false;
  bool loadProdutoEstoque = false;
  bool loadProdutoCodigoBarras = false;
  FilterEhDeletado filterEhDeletado = FilterEhDeletado.naoDeletados;
  FilterTemServico filterTemServico = FilterTemServico.naoServico;

  ConfiguracaoCadastro _configuracaoCadastro;

  Produto produto;
  List<Produto> produtoList;
  ProdutoImagem produtoImagem;
  ProdutoVariante produtoVariante;
  PrecoTabelaItem precoTabelaItem;
  ProdutoCodigoBarras produtoCodigoBarras;
  //List<PrecoTabelaItem> precoTabelaItemList;
  List<Estoque> movimentoEstoqueList;
  TipoAtualizacaoEstoque tipoAtualizacaoEstoque;
  MovimentoEstoque movimentoEstoque;

  @override
  Dao dao;

  ProdutoDAO(this._hasuraBloc, this._appGlobalBloc, this.produto, {ConfiguracaoCadastro configuracaoCadastro}) {
    dao = Dao();
    produtoImagem = ProdutoImagem();
    precoTabelaItem = PrecoTabelaItem();
    _configuracaoCadastro = configuracaoCadastro;
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    try {
      this.produto.id = map['id'];
      this.produto.idPessoaGrupo = map['id_pessoa_grupo'];
      this.produto.idAparente = map['id_aparente'];
      this.produto.idCategoria = map['id_categoria'];
      this.produto.idGrade = map['id_grade'];
      this.produto.nome = map['nome'];
      this.produto.iconeCor = map['iconecor'];
      this.produto.precoCusto = map['preco_custo'];
      this.produto.ehativo = map['ehativo'];
      this.produto.ehdeletado = map['ehdeletado'];
      this.produto.ehservico = map['ehservico'];
      this.produto.dataCadastro = DateTime.parse(map['data_cadastro']);
      this.produto.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
      this.produto.categoria = map['categoria'];
      this.produto.estoque = map['estoque'];
      return this.produto;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<produto_bloc> fromMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "produtoDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  @override
  Future<List> getAll({bool preLoad = false, int offset = 0}) async {
    String where;
    try {
      where = "id_pessoa_grupo = ${_appGlobalBloc.loja.idPessoaGrupo} ";
      where = filterEhativo ? where + "and ehativo = 1 " : where;
      where = filterEhDeletado != FilterEhDeletado.todos ? 
        where + "and ehdeletado = ${filterEhDeletado == FilterEhDeletado.naoDeletados ? 0 : 1} ": " ";
      where += filterTemServico != FilterTemServico.ehServico ?  "and ehservico = 0 ": "and ehservico = 1 ";  
      List<dynamic> args = [];
      if ((filterText != "") || (filterCategoria > 0)){
        if (filterText != ""){
          where = where + "and (nome like '%"+filterText+"%') " ;
        }
        if (filterCategoria > 0) {
          where = where + "and id_categoria = $filterCategoria ";
        }
      }
      where += " LIMIT $queryLimit OFFSET $offset";
      print("<produtoDao(getAll)> where: $where");

      List list = await dao.getList(this, where, args);
      produtoList = List.generate(list.length, (i) {
        return Produto(
                id: list[i]['id'],
                idPessoaGrupo: list[i]['id_pessoa_grupo'],
                idAparente: list[i]['id_aparente'],
                idCategoria: list[i]['id_categoria'],
                idGrade: list[i]['id_grade'],
                nome: list[i]['nome'],
                iconeCor: list[i]['iconecor'],
                precoCusto: list[i]['preco_custo'],
                ehativo: list[i]['ehativo'],
                ehdeletado: list[i]['ehdeletado'],
                ehservico: list[i]['ehservico'],
                dataCadastro: list[i]['data_cadastro'],//DateTime.parse(list[i]['data_cadastro']),
                dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
        );
      });

      if (preLoad) {
        for (var produto in produtoList) {
          CategoriaDAO categoriaDAO = CategoriaDAO(_hasuraBloc, _appGlobalBloc, categoria: produto.categoria);
          EstoqueDAO estoqueDAO = EstoqueDAO(_hasuraBloc, _appGlobalBloc, estoque: produto.estoque);
          GradeDAO gradeDAO = GradeDAO(_hasuraBloc, _appGlobalBloc, grade: produto.grade);
          ProdutoImagemDAO produtoImagemDAO =
              ProdutoImagemDAO(_hasuraBloc, _appGlobalBloc, produtoImagem: produtoImagem);
          ProdutoVarianteDAO produtoVarianteDAO =
              ProdutoVarianteDAO(_hasuraBloc, _appGlobalBloc, produtoVariante: produtoVariante);
          PrecoTabelaItemDAO precoTabelaItemDAO = PrecoTabelaItemDAO(_hasuraBloc, _appGlobalBloc, precoTabelaItem);
          ProdutoCodigoBarrasDAO produtoCodigoBarrasDAO = ProdutoCodigoBarrasDAO(_hasuraBloc, _appGlobalBloc, produtoCodigoBarras: produtoCodigoBarras) ;

          produto.categoria = loadCategoria
              ? await categoriaDAO.getById(produto.idCategoria)
              : produto.categoria;

          produto.grade = ((produto.idGrade != null && produto.idGrade > 0) && (loadGrade))
              ? await gradeDAO.getById(produto.idGrade)
              : produto.grade;

          if(loadProdutoEstoque){
            produto.estoque = await estoqueDAO.getById(produto.id);
          }

          if (loadProdutoVariante) {
            produtoVarianteDAO.filterProduto = produto.id;
            List<ProdutoVariante> produtoVarianteList =
                await produtoVarianteDAO.getAll(preLoad: true);
            produto.produtoVariante = produtoVarianteList;
          }

          if (loadProdutoImagem) {
            produtoImagemDAO.filterProduto = produto.id;
            List<ProdutoImagem> produtoImagemList =
                await produtoImagemDAO.getAll();
            produto.produtoImagem = produtoImagemList;
          }

          if (loadPrecoTabela) {
            precoTabelaItemDAO.filterProduto = produto.id;
            precoTabelaItemDAO.filterPrecoTabela = this.filterPrecoTabela;
            List<PrecoTabelaItem> precoTabelaItemList = await precoTabelaItemDAO.getAll();
            produto.precoTabelaItem = precoTabelaItemList;
          }

          if (loadProdutoCodigoBarras) {
            produtoCodigoBarrasDAO.filterProduto = produto.id;
            produtoCodigoBarrasDAO.loadVariante = true;
            List<ProdutoCodigoBarras> produtoCodigoBarrasList = await produtoCodigoBarrasDAO.getAll(preLoad: true);
            produto.produtoCodigoBarras = produtoCodigoBarrasList;
          }

          categoriaDAO = null;
          estoqueDAO = null;
          gradeDAO = null;
          produtoImagemDAO = null;
          produtoVarianteDAO = null;
          produtoCodigoBarrasDAO = null;
        }
      }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<produto_bloc> getAll');
      await log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "produtoDao",
        nomeFuncao: "getAll",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: where
      );
    }   
    return produtoList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool id=false, bool idPessoaGrupo=false,
      bool idAparente=false, bool idCategoria=false, bool idGrade=false, bool precoCusto=false, bool ehAtivo=false,  
      bool ehDeletado=false,bool ehServico=false, bool dataCadastro=false, bool dataAtualizacao=false, bool produtoVariante=false,
      bool precoTabelaItem=false, bool varianteDeletada=false, int offset = 0,
      bool categoria=false, bool variante=false, bool produtoImagem=false, bool grade=false, bool produtoCodigoBarras=false,
      bool iconeCor=false, String filtroNome="", DateTime filtroDataAtualizacao, FilterEhDeletado filterEhDeletado=FilterEhDeletado.naoDeletados, 
      FilterTemServico filterProdutoServico=FilterTemServico.todos}) async {
    
    String query;
    try {
      String queryVariante = """
        variante {
          id
          iconecor
          nome
          nome_avatar
          tem_imagem
          data_cadastro
          data_atualizacao
        }                
      """;
      
      query = """ {
        produto( 
          limit: $queryLimit, 
          offset: $offset,
          where: {
          ehdeletado: {${filterEhDeletado != FilterEhDeletado.todos ? filterEhDeletado == FilterEhDeletado.naoDeletados ? "_eq: 0" : "_eq: 1" : ""}},
          nome: {${filtroNome != "" ? '_ilike:  '+'"$filtroNome%"' : ''}},
          ehservico : {${filterProdutoServico != FilterTemServico.todos ? filterProdutoServico == FilterTemServico.naoServico ? '_eq:  0' : '_eq:  1' : ''}},
          data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
          order_by: {${filtroDataAtualizacao == null ? 'nome: asc' : 'data_atualizacao: asc'}}) {
          ${id ? "id" : ""}
          ${idPessoaGrupo ? "id_pessoa_grupo" : ""}
          ${idAparente ? "id_aparente" : ""}
          ${idCategoria ? "id_categoria" : ""}
          ${idGrade ? "id_grade" : ""}
          nome
          ${iconeCor ? "iconecor" : ""} 
          ${precoCusto ? "preco_custo" : ""}
          ${ehAtivo ? "ehativo" : ""}
          ${ehDeletado ? "ehdeletado" : ""}
          ${ehServico ? "ehservico" : ""}
          ${dataCadastro ? "data_cadastro" : ""}
          ${dataAtualizacao ? "data_atualizacao" : ""}
        """;
          
      query += 
        produtoVariante ? """
          produto_variante(where: {ehdeletado: {_eq: ${varianteDeletada ? 1 : 0}}}) {
            id
            id_produto
            id_variante
            ehdeletado
            data_cadastro
            data_atualizacao
            ${variante ? queryVariante : ''}
          }
        """ : "";

      query += 
        precoTabelaItem ? """
          preco_tabela_items {
            id
            id_preco_tabela
            id_produto
            preco
            data_cadastro
            data_atualizacao
          }
        """ : "";

      query += 
        produtoImagem ? """
          produto_imagem {
            id
            id_produto
            imagem
            ehdeletado
            data_cadastro
            data_atualizacao
          }
        """ : "";

      query += 
        categoria ? """
          categoria {
            id
            id_pessoa_grupo
            nome
            ehdeletado
            data_cadastro
            data_atualizacao
          }
        """ : "";

      query += 
        grade ? """
          grade {
            id
            id_pessoa_grupo
            nome
            t1
            t2
            t3
            t4
            t5
            t6
            t7
            t8
            t9
            t10
            t11
            t12
            t13
            t14
            t15
            ehdeletado
            data_cadastro
            data_atualizacao
          }
        """ : "";

      query += 
        produtoCodigoBarras ? """
          produto_codigo_barras {
            id
            id_produto
            id_variante
            grade_posicao
            codigo_barras
            ehdeletado
            data_cadastro
            data_atualizacao
          }
        """ : "";

      query += """
          }
        }
      """;
      
      var data = await _hasuraBloc.hasuraConnect.query(query);
      produtoList = [];
      List<ProdutoVariante> produtoVarianteList;
      List<ProdutoImagem> produtoImagemList;
      List<PrecoTabelaItem> precoTabelaItemList;
      List<ProdutoCodigoBarras> produtoCodigoBarrasList;

      for(var i = 0; i < data['data']['produto'].length; i++){
        produtoVarianteList = [];
        produtoImagemList = [];
        precoTabelaItemList = [];
        produtoCodigoBarrasList = [];
        
        if(data['data']['produto'][i]['produto_variante'] != null && data['data']['produto'][i]['produto_variante'].length > 0){
          data['data']['produto'][i]['produto_variante'].forEach((v) {
            produtoVarianteList.add(ProdutoVariante.fromJson(v));
          });
        }

        if(data['data']['produto'][i]['produto_imagem'] != null){
          data['data']['produto'][i]['produto_imagem'].forEach((v) {
            produtoImagemList.add(ProdutoImagem.fromJson(v));
          });
        }

        if(data['data']['produto'][i]['preco_tabela_items'] != null){
          data['data']['produto'][i]['preco_tabela_items'].forEach((v) {
            precoTabelaItemList.add(PrecoTabelaItem.fromJson(v));
          });
        }

        if(data['data']['produto'][i]['produto_codigo_barras'] != null){
          data['data']['produto'][i]['produto_codigo_barras'].forEach((v) {
            produtoCodigoBarrasList.add(ProdutoCodigoBarras.fromJson(v));
          });
        }

        produtoList.add(
          Produto(
            id: data['data']['produto'][i]['id'],
            idPessoaGrupo: data['data']['produto'][i]['id_pessoa_grupo'],
            idAparente: data['data']['produto'][i]['id_aparente'],
            idCategoria: data['data']['produto'][i]['id_categoria'],
            idGrade: data['data']['produto'][i]['id_grade'],
            nome: data['data']['produto'][i]['nome'],
            iconeCor: data['data']['produto'][i]['iconecor'],
            precoCusto: data['data']['produto'][i]['preco_custo'].toDouble(),
            ehativo: data['data']['produto'][i]['ehativo'],
            ehdeletado: data['data']['produto'][i]['ehdeletado'],
            ehservico: data['data']['produto'][i]['ehservico'],
            categoria: data['data']['produto'][i]['categoria'] != null ? Categoria.fromJson(data['data']['produto'][i]['categoria']) : data['data']['produto'][i]['categoria'],
            grade: data['data']['produto'][i]['produto_grade'],
            precoTabelaItem: precoTabelaItemList,
            produtoImagem: produtoImagemList,
            produtoVariante: produtoVarianteList,
            produtoCodigoBarras: produtoCodigoBarrasList,
            dataCadastro: DateTime.parse(data['data']['produto'][i]['data_cadastro']),
            dataAtualizacao: DateTime.parse(data['data']['produto'][i]['data_atualizacao'])
          )      
        );
      }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<produto_bloc> getAllFromServer');
      await log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "produtoDao",
        nomeFuncao: "getAllFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
    }   
    return produtoList;
  }  

  @override
  Future<IEntity> getById(int id) async {
    try {
      produto = await dao.getById(this, id);
      Categoria categoria = Categoria();
      CategoriaDAO categoriaDao = CategoriaDAO(_hasuraBloc, _appGlobalBloc, categoria: categoria);
      produto.categoria = await categoriaDao.getById(produto.idCategoria);

      if (produto.idGrade != null) {
        Grade grade = Grade();
        GradeDAO gradeDao = GradeDAO(_hasuraBloc, _appGlobalBloc, grade: grade);
        produto.grade = await gradeDao.getById(produto.idGrade);
      }
      ProdutoImagemDAO produtoImagemDao =
          ProdutoImagemDAO(_hasuraBloc, _appGlobalBloc, produtoImagem: this.produtoImagem);
      produtoImagemDao.filterProduto = produto.id;
      produto.produtoImagem = await produtoImagemDao.getAll();

      ProdutoVarianteDAO produtoVarianteDao =
          ProdutoVarianteDAO(_hasuraBloc, _appGlobalBloc, produtoVariante: this.produtoVariante);
      produtoVarianteDao.filterProduto = produto.id;
      produto.produtoVariante = await produtoVarianteDao.getAll(preLoad: true);

      PrecoTabelaItemDAO precoTabelaItemDAO = PrecoTabelaItemDAO(_hasuraBloc, _appGlobalBloc, precoTabelaItem);
      precoTabelaItemDAO.filterProduto = produto.id;
      precoTabelaItemDAO.filterPrecoTabela = this.filterPrecoTabela;
      produto.precoTabelaItem = await precoTabelaItemDAO.getAll();

      ProdutoCodigoBarrasDAO produtoCodigoBarrasDAO = ProdutoCodigoBarrasDAO(_hasuraBloc, _appGlobalBloc, produtoCodigoBarras: produtoCodigoBarras);
      produtoCodigoBarrasDAO.filterProduto = produto.id;
      produto.produtoCodigoBarras = await produtoCodigoBarrasDAO.getAll();
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<produto_bloc> getById');
      await log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "produtoDao",
        nomeFuncao: "getById",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: "id: ${id.toString()}"
      );
    }   
    return produto;
  }

  Future<Produto> getByIdFromServer(int id) async {
    String query;
    try {
      query = """ 
        {
          produto(where: {id: {_eq: $id}}) {
            id
            id_pessoa_grupo
            id_aparente
            id_categoria
            id_grade
            nome
            iconecor
            preco_custo
            ehativo
            ehdeletado
            ehservico
            data_atualizacao
            data_cadastro
            categoria {
              id
              nome
            }
            produto_variante{
              id
              id_produto
              id_variante
              ehdeletado
              data_cadastro
              data_atualizacao
              variante {
                id
                iconecor
                nome
                nome_avatar
                tem_imagem
                data_cadastro
                data_atualizacao
              }
            }
            produto_imagem {
              id
              id_produto
              imagem
              ehdeletado
              data_cadastro
              data_atualizacao
            }
            preco_tabela_items {
              id
              id_preco_tabela
              id_produto
              preco
              data_cadastro
              data_atualizacao
            }
            produto_codigo_barras {
              id
              id_produto
              id_variante
              grade_posicao
              codigo_barras
              ehdeletado
              data_cadastro
              data_atualizacao
              variante {
                id
                nome
              }
            }
            grade {
              id
              id_pessoa_grupo
              nome
              t1
              t2
              t3
              t4
              t5
              t6
              t7
              t8
              t9
              t10
              t11
              t12
              t13
              t14
              t15
              ehdeletado
              data_cadastro
              data_atualizacao
            }
          }
        }
      """;

      var data = await _hasuraBloc.hasuraConnect.query(query);
      Grade grade;
      List<ProdutoImagem> produtoImagemList = [];
      List<ProdutoVariante> produtoVarianteList = [];
      List<PrecoTabelaItem> precoTabelaItemList = [];
      List<ProdutoCodigoBarras> produtoCodigoBarrasList = [];

      Categoria categoria = Categoria();
      categoria.id = data['data']['produto'][0]['categoria']['id'];
      categoria.nome = data['data']['produto'][0]['categoria']['nome'];

      if(data['data']['produto'][0]['grade'] != null){
        grade = Grade.fromJson(data['data']['produto'][0]['grade']);
      }

      if(data['data']['produto'][0]['produto_imagem'] != null){
        data['data']['produto'][0]['produto_imagem'].forEach((v){
          produtoImagemList.add(ProdutoImagem.fromJson(v));
        });
      }

      if(data['data']['produto'][0]['produto_variante'] != null){
        data['data']['produto'][0]['produto_variante'].forEach((v) {
          produtoVarianteList.add(ProdutoVariante.fromJson(v));
        });
      }

      if(data['data']['produto'][0]['preco_tabela_items'] != null){
        data['data']['produto'][0]['preco_tabela_items'].forEach((v) {
          precoTabelaItemList.add(PrecoTabelaItem.fromJson(v));
        });
      }

      if(data['data']['produto'][0]['produto_codigo_barras'] != null){
        data['data']['produto'][0]['produto_codigo_barras'].forEach((v) {
          produtoCodigoBarrasList.add(ProdutoCodigoBarras.fromJson(v));
        });
      }

      produto = Produto(
        id: data['data']['produto'][0]['id'],
        idPessoaGrupo: data['data']['produto'][0]['id_pessoa_grupo'],
        idAparente: data['data']['produto'][0]['id_aparente'],
        idCategoria: data['data']['produto'][0]['id_categoria'],
        idGrade: data['data']['produto'][0]['id_grade'],
        nome: data['data']['produto'][0]['nome'],
        iconeCor: data['data']['produto'][0]['iconecor'],
        precoCusto: double.parse(data['data']['produto'][0]['preco_custo'].toString()),
        ehativo: data['data']['produto'][0]['ehativo'],
        ehdeletado: data['data']['produto'][0]['ehdeletado'],
        ehservico: data['data']['produto'][0]['ehservico'],
        categoria: categoria,
        grade: grade,
        precoTabelaItem: precoTabelaItemList,
        produtoImagem: produtoImagemList,
        produtoVariante: produtoVarianteList,
        produtoCodigoBarras: produtoCodigoBarrasList,
        dataCadastro: DateTime.parse(data['data']['produto'][0]['data_cadastro']),
        dataAtualizacao: DateTime.parse(data['data']['produto'][0]['data_atualizacao'])
      );
      categoria = null;
      grade = null;
      produtoImagemList = null;
      produtoVarianteList = null;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<produto_bloc> getByIdFromServer');
      await log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "produtoDao",
        nomeFuncao: "getByIdFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
    }   
    return produto;
  }  

  Future<DateTime> getUltimaSincronizacao() async {
    try {
      List<Map> data = await dao.getRawQuery("select max(data_atualizacao) as data_atualizacao from produto");
      return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<produto_bloc> getUltimaSincronizacao');
      await log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "produtoDao",
        nomeFuncao: "getUltimaSincronizacao",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
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
          produto.id = await txn.insert(tableName, this.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
          for (ProdutoImagem produtoImagem in produto.produtoImagem) {
            produtoImagem.idProduto = produto.id;
            batch.insert('produto_imagem', produtoImagem.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
          }
          for (ProdutoVariante produtoVariante in produto.produtoVariante) {
            produtoVariante.idProduto = produto.id;
            batch.insert('produto_variante', produtoVariante.toJson(isSave: true), conflictAlgorithm: ConflictAlgorithm.replace);
          }
          for (PrecoTabelaItem precoTabelaItem in produto.precoTabelaItem) {
            precoTabelaItem.idProduto = produto.id;
            batch.insert('preco_tabela_item', precoTabelaItem.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
          }
          for (ProdutoCodigoBarras produtoCodigoBarras in produto.produtoCodigoBarras) {
            produtoCodigoBarras.idProduto = produto.id;
            batch.insert('produto_codigo_barras', produtoCodigoBarras.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
          }
          var result = await batch.commit();
        });  
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<produto_bloc> insert');
      await log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "produtoDao",
        nomeFuncao: "insert",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: produto.toString()
      );
    }   
    return this.produto;
  }

  Future<IEntity> saveOnServer() async {
    String _query;
    try {
      _query = """ mutation saveProduto {
        update_sincronizacao(where: {}, _set: {data_atualizacao: "now()"}) {
          returning {
            data_atualizacao
          }
        }

        insert_produto(objects: {
      """;

      String _queryVariante = "";
      String _queryPrecoTabelaItem = "";
      String _queryProdutoCodigoBarras = "";
      print("Gravar variante");
      for (var i=0; i < produto.produtoVariante.length; i++){
        print("for produtoVariante");
        if (i == 0) {
          _queryVariante = '{data: [';
        }  

        if ((produto.produtoVariante[i].id != null) && (produto.produtoVariante[i].id > 0)) {
          _queryVariante = _queryVariante + "{id: ${produto.produtoVariante[i].id},";
        } else {
          _queryVariante = _queryVariante + "{";
        }    

        _queryVariante = _queryVariante + 
          """
            id_variante: ${produto.produtoVariante[i].idVariante},
            ehdeletado: ${produto.produtoVariante[i].ehDeletado},
            data_atualizacao: "now()"
          }  
          """;
        if (i == produto.produtoVariante.length-1){
          _queryVariante = _queryVariante + 
            """],
                on_conflict: {
                  constraint: produto_variante_pkey, 
                  update_columns: [
                    id_variante,
                    ehdeletado,
                    data_atualizacao
                  ]
                }  
              },
            """;
        }
      }
      print("_queryVariante: "+_queryVariante);
    
      print("produto.precoTabelaItem.length: "+ produto.precoTabelaItem.length.toString());
      if (produto.precoTabelaItem.length != 0) {
        for (var i=0; i < produto.precoTabelaItem.length; i++){
          print("for precoTabelaItem");
          if (i == 0) {
            _queryPrecoTabelaItem = '{data: [';
          }  

          if ((produto.precoTabelaItem[i].id != null) && (produto.precoTabelaItem[i].id > 0)) {
            _queryPrecoTabelaItem = _queryPrecoTabelaItem + "{id: ${produto.precoTabelaItem[i].id},";
          } else {
            _queryPrecoTabelaItem = _queryPrecoTabelaItem + "{";
          }    

          _queryPrecoTabelaItem = _queryPrecoTabelaItem + 
            """
              id_preco_tabela: ${produto.precoTabelaItem[i].idPrecoTabela},
              preco: ${produto.precoTabelaItem[i].preco},
              data_atualizacao: "now()" 
            }  
            """;
          if (i == produto.precoTabelaItem.length-1){
            _queryPrecoTabelaItem = _queryPrecoTabelaItem + 
              """],
                  on_conflict: {
                    constraint: preco_tabela_item_pkey, 
                    update_columns: [
                      id_preco_tabela,
                      preco,
                      data_atualizacao
                    ]
                  }  
                },
              """;
          }
        }
      }  
      print("_queryPrecoTabelaItem: "+_queryPrecoTabelaItem);

      print("produto.produtoCodigoBarras.length: "+ produto.produtoCodigoBarras.length.toString());
      if (produto.produtoCodigoBarras.length != 0) {
        for (var i=0; i < produto.produtoCodigoBarras.length; i++){
          print("for produtoCodigoBarras");
          if (i == 0) {
            _queryProdutoCodigoBarras = '{data: [';
          }  

          if ((produto.produtoCodigoBarras[i].id != null) && (produto.produtoCodigoBarras[i].id > 0)) {
            _queryProdutoCodigoBarras = _queryProdutoCodigoBarras + "{id: ${produto.produtoCodigoBarras[i].id},";
          } else {
            _queryProdutoCodigoBarras = _queryProdutoCodigoBarras + "{";
          }    

          _queryProdutoCodigoBarras = _queryProdutoCodigoBarras + 
            """
              id_variante: ${produto.produtoCodigoBarras[i].idVariante},
              grade_posicao: ${produto.produtoCodigoBarras[i].gradePosicao != null ? produto.produtoCodigoBarras[i].gradePosicao : 0},
              codigo_barras: "${produto.produtoCodigoBarras[i].codigoBarras}",
              ehdeletado: ${produto.produtoCodigoBarras[i].ehDeletado},
              data_atualizacao: "now()" 
            }  
            """;
          if (i == produto.produtoCodigoBarras.length-1){
            _queryProdutoCodigoBarras = _queryProdutoCodigoBarras + 
              """],
                  on_conflict: {
                    constraint: produto_codigo_barras_pkey, 
                    update_columns: [
                      id_variante,
                      grade_posicao,
                      codigo_barras,
                      ehdeletado,
                      data_atualizacao
                    ]
                  }  
                },
              """;
          }
        }
      }  
      print("_queryProdutoCodigoBarras: "+_queryProdutoCodigoBarras);

      if ((produto.id != null) && (produto.id > 0)) {
        _query = _query + "id: ${produto.id},";
      } else {
        if ((_configuracaoCadastro != null) && (_configuracaoCadastro.ehProdutoAutoInc == 1)) {
          produto.idAparente = await getProdutoAutoInc();
        }
      }  
      
      print("1");
      _query = _query + """
        nome: "${produto.nome}",
        iconecor: "${produto.iconeCor}",
        id_grade: ${produto.idGrade},
        id_categoria: ${produto.idCategoria}, 
        id_aparente: "${produto.idAparente}", 
        ehativo: ${produto.ehativo}, 
        ehdeletado: ${produto.ehdeletado}, 
        ehservico: ${produto.ehservico}, 
        preco_custo: ${produto.precoCusto},
        data_atualizacao: "now()",
        preco_tabela_items: $_queryPrecoTabelaItem""";
      _query = _queryVariante != "" ? _query + ", produto_variante: $_queryVariante" : _query; 
      _query = _queryProdutoCodigoBarras != "" ? _query + ", produto_codigo_barras: $_queryProdutoCodigoBarras" : _query; 

      print("2");
      _query += """
        }, on_conflict: {
            constraint: produto_pkey, 
            update_columns: [
              nome, 
              iconecor,
              id_grade,
              id_categoria,
              id_aparente,
              ehativo, 
              ehdeletado, 
              ehservico
              preco_custo, 
              data_atualizacao
            ]
          }
        ) {
        returning {
            id
            id_pessoa_grupo
          }
        }
      """;

      String _queryMovimentoEstoque = "";
      String _queryMovimentoEstoqueItem = "";        
      if (movimentoEstoqueList != null && movimentoEstoqueList.length > 0) {
        movimentoEstoque = MovimentoEstoque();
        for (var i = 0; i < movimentoEstoqueList.length; i++) {
          if (produto.grade != null) {
            for (var y=1; y <= 15; y++) {
              switch (y) {
                case 1: 
                  if (movimentoEstoqueList[i].et1 != null) {
                    movimentoEstoque.movimentoEstoqueItem.add(MovimentoEstoqueItem(
                      idProduto: movimentoEstoqueList[i].idProduto, 
                      idVariante: movimentoEstoqueList[i].idVariante, 
                      gradePosicao: 1, 
                      tipoAtualizacaoEstoque: tipoAtualizacaoEstoque,
                      quantidade: movimentoEstoqueList[i].et1
                    ));
                  }
                  break;
                case 2: 
                  if (movimentoEstoqueList[i].et2 != null) {
                    movimentoEstoque.movimentoEstoqueItem.add(MovimentoEstoqueItem(
                      idProduto: movimentoEstoqueList[i].idProduto, 
                      idVariante: movimentoEstoqueList[i].idVariante, 
                      gradePosicao: 2, 
                      tipoAtualizacaoEstoque: tipoAtualizacaoEstoque,
                      quantidade: movimentoEstoqueList[i].et2
                    ));
                  }
                  break;
                case 3: 
                  if (movimentoEstoqueList[i].et3 != null) {
                    movimentoEstoque.movimentoEstoqueItem.add(MovimentoEstoqueItem(
                      idProduto: movimentoEstoqueList[i].idProduto, 
                      idVariante: movimentoEstoqueList[i].idVariante, 
                      gradePosicao: 3, 
                      tipoAtualizacaoEstoque: tipoAtualizacaoEstoque,
                      quantidade: movimentoEstoqueList[i].et3
                    ));
                  }
                  break;
                case 4: 
                  if (movimentoEstoqueList[i].et4 != null) {
                    movimentoEstoque.movimentoEstoqueItem.add(MovimentoEstoqueItem(
                      idProduto: movimentoEstoqueList[i].idProduto, 
                      idVariante: movimentoEstoqueList[i].idVariante, 
                      gradePosicao: 4, 
                      tipoAtualizacaoEstoque: tipoAtualizacaoEstoque,
                      quantidade: movimentoEstoqueList[i].et4
                    ));
                  }
                  break;
                case 5: 
                  if (movimentoEstoqueList[i].et5 != null) {
                    movimentoEstoque.movimentoEstoqueItem.add(MovimentoEstoqueItem(
                      idProduto: movimentoEstoqueList[i].idProduto, 
                      idVariante: movimentoEstoqueList[i].idVariante, 
                      gradePosicao: 5, 
                      tipoAtualizacaoEstoque: tipoAtualizacaoEstoque,
                      quantidade: movimentoEstoqueList[i].et5
                    ));
                  }
                  break;
                case 6: 
                  if (movimentoEstoqueList[i].et6 != null) {
                    movimentoEstoque.movimentoEstoqueItem.add(MovimentoEstoqueItem(
                      idProduto: movimentoEstoqueList[i].idProduto, 
                      idVariante: movimentoEstoqueList[i].idVariante, 
                      gradePosicao: 6, 
                      tipoAtualizacaoEstoque: tipoAtualizacaoEstoque,
                      quantidade: movimentoEstoqueList[i].et6
                    ));
                  }
                  break;
                case 7: 
                  if (movimentoEstoqueList[i].et7 != null) {
                    movimentoEstoque.movimentoEstoqueItem.add(MovimentoEstoqueItem(
                      idProduto: movimentoEstoqueList[i].idProduto, 
                      idVariante: movimentoEstoqueList[i].idVariante, 
                      gradePosicao: 7, 
                      tipoAtualizacaoEstoque: tipoAtualizacaoEstoque,
                      quantidade: movimentoEstoqueList[i].et7
                    ));
                  }
                  break;
                case 8: 
                  if (movimentoEstoqueList[i].et8 != null) {
                    movimentoEstoque.movimentoEstoqueItem.add(MovimentoEstoqueItem(
                      idProduto: movimentoEstoqueList[i].idProduto, 
                      idVariante: movimentoEstoqueList[i].idVariante, 
                      gradePosicao: 8, 
                      tipoAtualizacaoEstoque: tipoAtualizacaoEstoque,
                      quantidade: movimentoEstoqueList[i].et8
                    ));
                  }
                  break;
                case 9: 
                  if (movimentoEstoqueList[i].et9 != null) {
                    movimentoEstoque.movimentoEstoqueItem.add(MovimentoEstoqueItem(
                      idProduto: movimentoEstoqueList[i].idProduto, 
                      idVariante: movimentoEstoqueList[i].idVariante, 
                      gradePosicao: 9, 
                      tipoAtualizacaoEstoque: tipoAtualizacaoEstoque,
                      quantidade: movimentoEstoqueList[i].et9
                    ));
                  }
                  break;
                case 10: 
                  if (movimentoEstoqueList[i].et10 != null) {
                    movimentoEstoque.movimentoEstoqueItem.add(MovimentoEstoqueItem(
                      idProduto: movimentoEstoqueList[i].idProduto, 
                      idVariante: movimentoEstoqueList[i].idVariante, 
                      gradePosicao: 10, 
                      tipoAtualizacaoEstoque: tipoAtualizacaoEstoque,
                      quantidade: movimentoEstoqueList[i].et10
                    ));
                  }
                  break;
                case 11: 
                  if (movimentoEstoqueList[i].et11 != null) {
                    movimentoEstoque.movimentoEstoqueItem.add(MovimentoEstoqueItem(
                      idProduto: movimentoEstoqueList[i].idProduto, 
                      idVariante: movimentoEstoqueList[i].idVariante, 
                      gradePosicao: 11, 
                      tipoAtualizacaoEstoque: tipoAtualizacaoEstoque,
                      quantidade: movimentoEstoqueList[i].et11
                    ));
                  }
                  break;
                case 12: 
                  if (movimentoEstoqueList[i].et12 != null) {
                    movimentoEstoque.movimentoEstoqueItem.add(MovimentoEstoqueItem(
                      idProduto: movimentoEstoqueList[i].idProduto, 
                      idVariante: movimentoEstoqueList[i].idVariante, 
                      gradePosicao: 12, 
                      tipoAtualizacaoEstoque: tipoAtualizacaoEstoque,
                      quantidade: movimentoEstoqueList[i].et12
                    ));
                  }
                  break;
                case 13: 
                  if (movimentoEstoqueList[i].et13 != null) {
                    movimentoEstoque.movimentoEstoqueItem.add(MovimentoEstoqueItem(
                      idProduto: movimentoEstoqueList[i].idProduto, 
                      idVariante: movimentoEstoqueList[i].idVariante, 
                      gradePosicao: 13, 
                      tipoAtualizacaoEstoque: tipoAtualizacaoEstoque,
                      quantidade: movimentoEstoqueList[i].et13
                    ));
                  }
                  break;
                case 14: 
                  if (movimentoEstoqueList[i].et14 != null) {
                    movimentoEstoque.movimentoEstoqueItem.add(MovimentoEstoqueItem(
                      idProduto: movimentoEstoqueList[i].idProduto, 
                      idVariante: movimentoEstoqueList[i].idVariante, 
                      gradePosicao: 14, 
                      tipoAtualizacaoEstoque: tipoAtualizacaoEstoque,
                      quantidade: movimentoEstoqueList[i].et14
                    ));
                  }
                  break;
                case 15: 
                  if (movimentoEstoqueList[i].et15 != null) {
                    movimentoEstoque.movimentoEstoqueItem.add(MovimentoEstoqueItem(
                      idProduto: movimentoEstoqueList[i].idProduto, 
                      idVariante: movimentoEstoqueList[i].idVariante, 
                      gradePosicao: 15, 
                      tipoAtualizacaoEstoque: tipoAtualizacaoEstoque,
                      quantidade: movimentoEstoqueList[i].et15
                    ));
                  }
                  break;
                default:
              }
            }
          } else {
            movimentoEstoque.movimentoEstoqueItem.add(MovimentoEstoqueItem(
              idProduto: movimentoEstoqueList[i].idProduto, 
              idVariante: movimentoEstoqueList[i].idVariante, 
              tipoAtualizacaoEstoque: tipoAtualizacaoEstoque,
              quantidade: movimentoEstoqueList[i].estoqueTotal
            ));
          }
        }  
          
        if (movimentoEstoque != null) {
          for (var i=0; i < movimentoEstoque.movimentoEstoqueItem.length; i++){
            print("for movimentoEstoqueItem");
            if (i == 0) {
              _queryMovimentoEstoqueItem = '{data: [';
            }  

            if ((movimentoEstoque.movimentoEstoqueItem[i].id != null) && (movimentoEstoque.movimentoEstoqueItem[i].id > 0)) {
              _queryMovimentoEstoqueItem = _queryMovimentoEstoqueItem + "{id: ${movimentoEstoque.movimentoEstoqueItem[i].id},";
            } else {
              _queryMovimentoEstoqueItem = _queryMovimentoEstoqueItem + "{";
            }    

            _queryMovimentoEstoqueItem = _queryMovimentoEstoqueItem + 
              """
                id_produto: ${movimentoEstoque.movimentoEstoqueItem[i].idProduto},
                id_variante: ${movimentoEstoque.movimentoEstoqueItem[i].idVariante},
                grade_posicao: ${movimentoEstoque.movimentoEstoqueItem[i].gradePosicao},
                tipo_atualizacao_estoque: ${movimentoEstoque.movimentoEstoqueItem[i].tipoAtualizacaoEstoque.index},
                quantidade: ${movimentoEstoque.movimentoEstoqueItem[i].quantidade.toInt().toString()},
              }  
              """;
            if (i == movimentoEstoque.movimentoEstoqueItem.length-1){
              _queryMovimentoEstoqueItem = _queryMovimentoEstoqueItem + 
                """],
                    on_conflict: {
                      constraint: movimento_estoque_item_pkey, 
                      update_columns: data_atualizacao
                    }  
                  }},
                """;
            }
          }
          print("_queryMovimentoEstoqueItem: $_queryMovimentoEstoqueItem");
        
        
          _queryMovimentoEstoque = """
            insert_movimento_estoque(objects: {
              movimento_estoque_items: $_queryMovimentoEstoqueItem
              on_conflict: {
                constraint: movimento_estoque_pkey, 
                update_columns: data_atualizacao
              }) {
              returning {
                id
              }
            }
          """;
        }
      }  

      print("_queryMovimentoEstoque: "+_queryMovimentoEstoque);
      _query = _queryMovimentoEstoque != "" ? _query+=_queryMovimentoEstoque+"}" : _query+="}";

      print("3");
      print("_query: "+_query);
      print("4");
      var data = await _hasuraBloc.hasuraConnect.mutation(_query);
      produto.id = data["data"]["insert_produto"]["returning"][0]["id"];
      produto.idPessoaGrupo = data["data"]["insert_produto"]["returning"][0]["id_pessoa_grupo"];
      if (movimentoEstoque != null) {
        movimentoEstoque.id = data["data"]["insert_movimento_estoque"]["returning"][0]["id"];
        if (movimentoEstoque.id > 0) {
          String _queryAtualizaMovimentoEstoque = """query atualizaMovimentoEstoque {
            atualiza_movimento_estoque(args: {pid_movimento_estoque: ${movimentoEstoque.id}}) {
              id
            }
          }  
          """; 
          var dataAtualizaMovimentoEstoque = await _hasuraBloc.hasuraConnect.query(_queryAtualizaMovimentoEstoque);
          movimentoEstoque.id = dataAtualizaMovimentoEstoque["data"]["atualiza_movimento_estoque"][0]["id"];
        }
      }
      return produto;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<produto_bloc> saveOnServer');
      await log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "produtoDao",
        nomeFuncao: "saveOnServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: produto.toString(),
        query: _query
      );
      return null;
    }   
  }  

  Future<String> getProdutoAutoInc() async {
    String _query = """
      mutation updateAutoInc {
        update_produto_autoinc(
          where: {},
          _inc: {autoinc: 1}) {
            returning {
              autoinc
          }
        }
      }
    """;

    try {
      var data = await _hasuraBloc.hasuraConnect.mutation(_query);
      produto.idAparente = data["data"]["update_produto_autoinc"]['returning'][0]["autoinc"].toString();
      return produto.idAparente;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<produto_bloc> getProdutoAutoInc');
      await log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "produtoDao",
        nomeFuncao: "getProdutoAutoInc",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: produto.toString(),
        query: _query
      );
      return null;
    }   
  }  

  @override
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': produto.id,
        'id_pessoa_grupo': produto.idPessoaGrupo,
        'id_aparente': produto.idAparente,
        'id_categoria': produto.idCategoria,
        'id_grade': produto.idGrade,
        'nome': produto.nome,
        'iconecor': produto.iconeCor,
        'preco_custo': produto.precoCusto,
        'ehativo': produto.ehativo,
        'ehdeletado': produto.ehdeletado,
        'ehservico': produto.ehservico,
        'data_cadastro': produto.dataCadastro.toString(),
        'data_atualizacao': produto.dataAtualizacao.toString(),
      };
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<produto_bloc> toMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "produtoDao",
        nomeFuncao: "toMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      return null;
    }   
  }

  String entityToJson() {
    final dyn = _toJson();
    return json.encode(dyn);
  }

  IEntity entityFromJson(String str) {
    final jsonData = json.decode(str);
    return _fromJson(jsonData);
  }

  IEntity _fromJson(Map<String, dynamic> json) {
    CategoriaDAO categoriaDao = CategoriaDAO(_hasuraBloc, _appGlobalBloc, categoria: this.produto.categoria);
    EstoqueDAO estoqueDao = EstoqueDAO(_hasuraBloc, _appGlobalBloc, estoque: this.produto.estoque);
    //ProdutoImagemDAO produtoImagemDAO = ProdutoImagemDAO(_hasuraBloc, produtoImagemList: produto.produtoImagem);
    return Produto(
      id: json['id'],
      idPessoaGrupo: json['id_pessoa_grupo'],
      idAparente: json['id_aparente'],
      idCategoria: json['id_categoria'],
      idGrade: json['id_grade'],
      nome: json['nome'],
      iconeCor: json['iconecor'],
      precoCusto: json['preco_custo'],
      ehativo: json['ehativo'],
      ehdeletado: json['ehdeletado'],
      ehservico: json['ehservico'],
      dataCadastro: DateTime.parse(json['data_cadastro']),
      dataAtualizacao: DateTime.parse(json['data_atualizacao']),
      estoque: estoqueDao.fromMap(json['estoque']),
      categoria: categoriaDao.fromMap(json['categoria']),
      //produto_imagem:produtoImagemDAO.prepareListFromJson(json['produto_imagem']),
    );
  }

  @override
  Future<IEntity> delete(int id) async {
    return produto;
  }  

  Map<String, dynamic> _toJson() {
    CategoriaDAO categoriaDao = CategoriaDAO(_hasuraBloc, _appGlobalBloc, categoria: produto.categoria);
    EstoqueDAO estoqueDao = EstoqueDAO(_hasuraBloc, _appGlobalBloc, estoque: this.produto.estoque);
    ProdutoImagemDAO produto_imagemDao = ProdutoImagemDAO(_hasuraBloc, _appGlobalBloc, produtoImagemList: produto.produtoImagem);
    return {
    'id': produto.id,
    'id_pessoa_grupo': produto.idPessoaGrupo,
    'id_aparente': produto.idAparente,
    'id_categoria': produto.idCategoria,
    'id_grade': produto.idGrade,
    'nome': produto.nome,
    'iconecor' : produto.iconeCor,
    'preco_custo': produto.precoCusto,
    'ehativo': produto.ehativo,
    'ehdeletado': produto.ehdeletado,
    'ehservico': produto.ehservico,
    'data_cadastro': produto.dataCadastro.toString(),
    'data_atualizacao': produto.dataAtualizacao.toString(),
    'categoria': categoriaDao.toMap(),
    'estoque': estoqueDao.toMap(),
    'produto_imagem': produto_imagemDao.prepareListToJson(),
    };
  }
}