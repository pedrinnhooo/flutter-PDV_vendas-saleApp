import 'dart:convert';

import 'package:common_files/src/bloc/hasura_bloc.dart';
import 'package:common_files/src/model/dao/dao.dart';
import 'package:common_files/src/model/entities/cadastro/categoria/categoria.dart';
import 'package:common_files/src/model/entities/cadastro/categoria/categoriaDao.dart';
import 'package:common_files/src/model/entities/cadastro/grade/grade.dart';
import 'package:common_files/src/model/entities/cadastro/grade/gradeDao.dart';
import 'package:common_files/src/model/entities/cadastro/preco_tabela/preco_tabela_item.dart';
import 'package:common_files/src/model/entities/cadastro/preco_tabela/preco_tabela_itemDao.dart';
import 'package:common_files/src/model/entities/cadastro/produto/produto.dart';
import 'package:common_files/src/model/entities/cadastro/produto/produto_variante.dart';
import 'package:common_files/src/model/entities/cadastro/produto/produto_varianteDao.dart';
import 'package:common_files/src/model/entities/cadastro/produto_imagem/produto_imagem.dart';
import 'package:common_files/src/model/entities/cadastro/produto_imagem/produto_imagemDao.dart';
import 'package:common_files/src/model/entities/interfaces.dart';
import 'package:common_files/src/model/entities/operacao/estoque/estoqueDao.dart';

class ProdutoDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  final String tableName = "produto";
  int filterCategoria;
  String filterText;
  bool filterEhativo = true;
  int filterPrecoTabela = 1;
  bool loadCategoria = false;
  bool loadGrade = false;
  bool loadProdutoImagem = false;
  bool loadProdutoVariante = false;
  bool loadPrecoTabela = false;
  bool loadProdutoEstoque = false;

  Produto produto;
  List<Produto> produtoList;
  ProdutoImagem produtoImagem;
  ProdutoVariante produtoVariante;
  List<PrecoTabelaItem> precoTabelaItemList;

  @override
  Dao dao;

  ProdutoDAO(this._hasuraBloc, this.produto) {
    dao = Dao();
    produtoImagem = ProdutoImagem();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    this.produto.id = map['id'];
    this.produto.idPessoaGrupo = map['id_pessoa_grupo'];
    this.produto.idAparente = map['id_aparente'];
    this.produto.idCategoria = map['id_categoria'];
    this.produto.idGrade = map['id_grade'];
    this.produto.nome = map['nome'];
    this.produto.iconeCor = map['iconecor'];
    this.produto.precoCusto = map['preco_custo'];
    this.produto.ehativo = map['ehativo'];
    this.produto.dataCadastro = DateTime.parse(map['data_cadastro']);
    this.produto.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
    this.produto.categoria = map['categoria'];
    this.produto.estoque = map['estoque'];
    return this.produto;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where = "";
    where = "1 = 1 ";
    where = filterEhativo ? where + "and ehativo = 1 " : where; 
    List<dynamic> args = [];
    if ((filterText != "") || (filterCategoria > 0)){
      if (filterText != ""){
        where = where + "and (nome like '%"+filterText+"%')" ;
      }
      if (filterCategoria > 0) {
        where = where + "and id_categoria = ?";
        args.add(filterCategoria);
      }
    }

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
               dataCadastro: DateTime.parse(list[i]['data_cadastro']),
               dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
      );
    });

    if (preLoad) {
      for (var produto in produtoList) {
        CategoriaDAO categoriaDAO = CategoriaDAO(_hasuraBloc, categoria: produto.categoria);
        EstoqueDAO estoqueDAO = EstoqueDAO(estoque: produto.estoque);
        GradeDAO gradeDAO = GradeDAO(_hasuraBloc, grade: produto.grade);
        ProdutoImagemDAO produtoImagemDAO =
            ProdutoImagemDAO(_hasuraBloc, produtoImagem: produtoImagem);
        ProdutoVarianteDAO produtoVarianteDAO =
            ProdutoVarianteDAO(_hasuraBloc, produtoVariante: produtoVariante);
        PrecoTabelaItemDAO precoTabelaItemDAO = PrecoTabelaItemDAO(_hasuraBloc, produto.precoTabelaItem);

        produto.categoria = loadCategoria
            ? await categoriaDAO.getById(produto.idCategoria)
            : produto.categoria;

        

        produto.grade = ((produto.idGrade > 0) && (loadGrade))
            ? await gradeDAO.getById(produto.idGrade)
            : produto.grade;

        if(loadProdutoEstoque){
          produto.estoque = await estoqueDAO.consultaEstoque(idProduto: produto.id);
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
          precoTabelaItemList = await precoTabelaItemDAO.getAll();
          produto.precoTabelaItem = precoTabelaItemList.first;
        }

        categoriaDAO = null;
        estoqueDAO = null;
        gradeDAO = null;
        produtoImagemDAO = null;
        produtoVarianteDAO = null;
      }
    }
    return produtoList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool id=false, bool idPessoaGrupo=false,
    bool categoria=false, bool variante=false, bool produtoImagem=false, bool grade=false,
    bool idCategoria=false, bool idGrade=false, bool precoCusto=false, bool ehAtivo=false, bool idAparente=false, 
    bool ehDeletado=false, bool dataCadastro=false, bool dataAtualizacao=false, bool varianteDeletada=false,
    bool iconeCor=false, String filtroNome=""}) async {
    String query = """ {
        produto( 
          where: {
          nome: {${filtroNome != "" ? '_ilike:  '+'"$filtroNome%"' : ''}}}, 
          order_by: {nome: asc}) {
          ${id ? "id" : ""}
          ${idPessoaGrupo ? "id_pessoa_grupo" : ""}
          ${idAparente ? "id_aparente" : ""}
          ${idCategoria ? "id_categoria" : ""}
          ${idGrade ? "id_grade" : ""}
          nome
          ${iconeCor ? "iconecor" : ""} 
          ${precoCusto ? "preco_custo" : ""}
          ${ehAtivo ? "ehativo" : ""}
          ${dataCadastro ? "data_cadastro" : ""}
          ${dataAtualizacao ? "data_atualizacao" : ""}
          ${categoria ? "categoria": ""} """;
          
          query += 
            variante ? """
              produto_variante(
                where: {
                  ehdeletado: {_eq: ${varianteDeletada ? 1 : 0}}
                }
              ) {
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
                  possui_imagem
                  data_cadastro
                  data_atualizacao
                  }
                }
              preco_tabela_items(where: {preco_tabela: {id: {_eq: 1}}}, limit: 1) {
                id
                id_preco_tabela
                id_produto
                preco
                data_cadastro
                data_atualizacao
              }
              """ 
            : "";

          query += """
          ${produtoImagem ? "produto_imagem" : "" }
          ${grade ? "produto_grade" : ""}
        }
      }
    """;
    
    var data = await _hasuraBloc.hasuraConnect.query(query);
    produtoList = [];
    List<ProdutoVariante> produtoVarianteList = [];
    List<ProdutoImagem> produtoImagemList = [];
    PrecoTabelaItem precoTabelaItem;

    for(var i = 0; i < data['data']['produto'].length; i++){
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
        precoTabelaItem = PrecoTabelaItem.fromJson(data['data']['produto'][i]['preco_tabela_items'][0]);
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
          precoCusto: data['data']['produto'][i]['preco_custo'],
          ehativo: data['data']['produto'][i]['ehativo'],
          categoria: data['data']['produto'][i]['categoria'],
          grade: data['data']['produto'][i]['produto_grade'],
          precoTabelaItem: precoTabelaItem,
          produtoImagem: produtoImagemList,
          produtoVariante: produtoVarianteList,
          dataCadastro: DateTime.parse(data['data']['produto'][i]['data_cadastro']),
          dataAtualizacao: DateTime.parse(data['data']['produto'][i]['data_atualizacao'])
        )      
      );
    }
    return produtoList;
  }  

  @override
  Future<IEntity> getById(int id) async {
    produto = await dao.getById(this, id);
    Categoria categoria = Categoria();
    CategoriaDAO categoriaDao = CategoriaDAO(_hasuraBloc, categoria: categoria);
    produto.categoria = await categoriaDao.getById(produto.idCategoria);

    if (produto.idGrade > 0) {
      Grade grade = Grade();
      GradeDAO gradeDao = GradeDAO(_hasuraBloc, grade: grade);
      produto.grade = await gradeDao.getById(produto.idGrade);
    }
    ProdutoImagemDAO produtoImagemDao =
        ProdutoImagemDAO(_hasuraBloc, produtoImagem: this.produtoImagem);
    produtoImagemDao.filterProduto = produto.id;
    produto.produtoImagem = await produtoImagemDao.getAll();

    ProdutoVarianteDAO produtoVarianteDao =
        ProdutoVarianteDAO(_hasuraBloc, produtoVariante: this.produtoVariante);
    produtoVarianteDao.filterProduto = produto.id;
    produto.produtoVariante = await produtoVarianteDao.getAll(preLoad: true);

    PrecoTabelaItemDAO precoTabelaItemDAO = PrecoTabelaItemDAO(_hasuraBloc, produto.precoTabelaItem);
    precoTabelaItemDAO.filterProduto = produto.id;
    precoTabelaItemDAO.filterPrecoTabela = this.filterPrecoTabela;
    precoTabelaItemList = await precoTabelaItemDAO.getAll();
    produto.precoTabelaItem = precoTabelaItemList.first;

    return produto;
  }

  Future<Produto> getByIdFromServer(int id) async {
    String query = """ 
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
          data_atualizacao
          data_cadastro
          categoria {
            id
            nome
          }
          produto_grade {
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
              possui_imagem
              data_cadastro
              data_atualizacao
            }
          }
          produto_imagem {
            id
            imagem
          }
          preco_tabela_items(where: {preco_tabela: {id: {_eq: 1}}}, limit: 1) {
            id
            id_preco_tabela
            id_produto
            preco
            data_cadastro
            data_atualizacao
          }
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    Grade grade;
    PrecoTabelaItem precoTabelaItem;
    List<ProdutoImagem> produtoImagemList = [];
    List<ProdutoVariante> produtoVarianteList = [];

    Categoria categoria = Categoria();
    categoria.id = data['data']['produto'][0]['categoria']['id'];
    categoria.nome = data['data']['produto'][0]['categoria']['nome'];

    // if(data['data']['produto'][0]['produto_grade'] != null){
    //   grade = Grade();
    //   GradeDAO gradeDao = GradeDAO(_hasuraBloc, grade: grade);
    //   grade = await gradeDao.getByIdFromServer(data['data']['produto'][0]['id_grade']);
    // }

    // if(data['data']['produto'][0]['produto_imagem'] != null){
    //   ProdutoImagemDAO produtoimagemDao = ProdutoImagemDAO(produto_imagem: this.produto_imagem);
    //   produtoimagemDao.filter_produto = data['data']['produto'][0]['id'];
    //   produtoImagemList = await produtoimagemDao.getAllFromServer();
    // }

    if(data['data']['produto'][0]['produto_variante'] != null){
      data['data']['produto'][0]['produto_variante'].forEach((v) {
        produtoVarianteList.add(ProdutoVariante.fromJson(v));
      });
    }

    if(data['data']['produto'][0]['preco_tabela_items'] != null){
      precoTabelaItem = PrecoTabelaItem.fromJson(data['data']['produto'][0]['preco_tabela_items'][0]);
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
      categoria: categoria,
      grade: grade,
      precoTabelaItem: precoTabelaItem,
      produtoImagem: produtoImagemList,
      produtoVariante: produtoVarianteList,
      dataCadastro: DateTime.parse(data['data']['produto'][0]['data_cadastro']),
      dataAtualizacao: DateTime.parse(data['data']['produto'][0]['data_atualizacao'])
    );
    categoria = null;
    grade = null;
    produtoImagemList = null;
    produtoVarianteList = null;
    return produto;
  }  

  @override
  Future<IEntity> insert() async {
    this.produto.id = await dao.insert(this);
    return this.produto;
  }

  Future<IEntity> saveOnServer() async {
    String _query = """ mutation saveProduto {
      insert_produto(objects: {""";
  
    if ((produto.id != null) && (produto.id > 0)) {
      _query = _query + "id: ${produto.id},";
    }  
    
    _query = _query + """
        nome: "${produto.nome}",
        iconecor: "${produto.iconeCor}",
        id_grade: ${produto.idGrade},
        id_categoria: ${produto.idCategoria}, 
        id_aparente: "${produto.idAparente}", 
        ehativo: "${produto.ehativo}", 
        preco_custo: ${produto.precoCusto},
        data_cadastro: "${produto.dataCadastro}",
        data_atualizacao: "${produto.dataAtualizacao}",
         preco_tabela_items: {
          data: {""";

          if ((produto.id != null) && (produto.id > 0)) {
            _query += "id: ${produto.precoTabelaItem.id},";
          } 
          
          _query += """
            id_preco_tabela: ${produto.precoTabelaItem.idPrecoTabela},
            preco: ${produto.precoTabelaItem.preco},
            data_cadastro: "${produto.precoTabelaItem.dataCadastro}",
            data_atualizacao: "${produto.precoTabelaItem.dataAtualizacao}"
          }, 
          on_conflict: {
            constraint: preco_tabela_item_pkey, 
            update_columns: [
              id_preco_tabela,
              id_produto,
              preco,
              data_atualizacao
            ]}}, 
      }, on_conflict: {
          constraint: produto_pkey, 
          update_columns: [
            nome, 
            iconecor,
            id_grade,
            id_categoria,
            id_aparente,
            ehativo, 
            preco_custo, 
            data_atualizacao
          ]
        }
      ) {
      returning {
          id
        }
      }
    }
    """;

    try {
      var data = await _hasuraBloc.hasuraConnect.mutation(_query);
      produto.id = data["data"]["insert_produto"]["returning"][0]["id"];
      return produto;
    } catch (error) {
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
      produto.idAparente = data["data"]["produto_autoinc"]['returning'][0]["autoinc"];
      return produto.idAparente;
    } catch (error) {
      return null;
    }  
  }  

  @override
  Map<String, dynamic> toMap() {
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
      'data_cadastro': produto.dataCadastro.toString(),
      'data_atualizacao': produto.dataAtualizacao.toString(),
    };
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
    CategoriaDAO categoriaDao = CategoriaDAO(_hasuraBloc, categoria: this.produto.categoria);
    EstoqueDAO estoqueDao = EstoqueDAO(estoque: this.produto.estoque);
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
      dataCadastro: DateTime.parse(json['data_cadastro']),
      dataAtualizacao: DateTime.parse(json['data_atualizacao']),
      estoque: estoqueDao.fromMap(json['estoque']),
      categoria: categoriaDao.fromMap(json['categoria']),
      //produto_imagem:produtoImagemDAO.prepareListFromJson(json['produto_imagem']),
    );
  }

  Map<String, dynamic> _toJson() {
    CategoriaDAO categoriaDao = CategoriaDAO(_hasuraBloc, categoria: produto.categoria);
    EstoqueDAO estoqueDao = EstoqueDAO(estoque: this.produto.estoque);
    ProdutoImagemDAO produto_imagemDao = ProdutoImagemDAO(_hasuraBloc, produtoImagemList: produto.produtoImagem);
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
    'data_cadastro': produto.dataCadastro.toString(),
    'data_atualizacao': produto.dataAtualizacao.toString(),
    'categoria': categoriaDao.toMap(),
    'estoque': estoqueDao.toMap(),
    'produto_imagem': produto_imagemDao.prepareListToJson(),
    };
  }
}
