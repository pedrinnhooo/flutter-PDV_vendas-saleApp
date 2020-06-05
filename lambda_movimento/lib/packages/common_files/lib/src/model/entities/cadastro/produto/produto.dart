import 'package:common_files/src/model/entities/cadastro/categoria/categoria.dart';
import 'package:common_files/src/model/entities/cadastro/grade/grade.dart';
import 'package:common_files/src/model/entities/cadastro/preco_tabela/preco_tabela_item.dart';
import 'package:common_files/src/model/entities/cadastro/produto/produto_variante.dart';
import 'package:common_files/src/model/entities/cadastro/produto_imagem/produto_imagem.dart';
import 'package:common_files/src/model/entities/interfaces.dart';
import 'package:common_files/src/model/entities/operacao/estoque/estoque.dart';

class Produto extends IEntity {
  int _id;
  int _idPessoaGrupo;
  String _idAparente;
  int _idCategoria;
  int _idGrade;
  String _nome;
  String _iconeCor;
  double _precoCusto;
  int _ehativo = 1;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;
  Categoria _categoria;
  Estoque _estoque;
  Grade _grade;
  List<ProdutoImagem> _produtoImagem;
  List<ProdutoVariante> _produtoVariante;
  PrecoTabelaItem _precoTabelaItem;

  Produto(
      {int id,
      int idPessoaGrupo,
      String idAparente,
      int idCategoria,
      int idGrade = 0,
      String nome,
      String iconeCor = "0XFF808080",
      double precoCusto = 0.0,
      int ehativo = 1,
      DateTime dataCadastro,
      DateTime dataAtualizacao,
      Categoria categoria,
      Estoque estoque,
      Grade grade,
      List<ProdutoImagem> produtoImagem,
      List<ProdutoVariante> produtoVariante,
      PrecoTabelaItem precoTabelaItem}) {
    this._id = id;
    this._idPessoaGrupo = idPessoaGrupo;
    this._idAparente = idAparente;
    this._idCategoria = idCategoria;
    this._idGrade = idGrade;
    this._nome = nome;
    this._iconeCor = iconeCor;
    this._precoCusto = precoCusto;
    this._ehativo = ehativo;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
    this._categoria = categoria == null ? Categoria() : categoria;
    this._estoque = estoque == null ? Estoque() : estoque;
    this._grade = grade == null ? Grade() : grade;
    this._produtoImagem = produtoImagem == null ? [] : produtoImagem;
    this._produtoVariante = produtoVariante == null ? [] : produtoVariante;
    this._precoTabelaItem = precoTabelaItem == null ? PrecoTabelaItem() : precoTabelaItem;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoaGrupo => _idPessoaGrupo;
  set idPessoaGrupo(int idPessoaGrupo) => _idPessoaGrupo = idPessoaGrupo;
  String get idAparente => _idAparente;
  set idAparente(String idAparente) => _idAparente = idAparente;
  int get idCategoria => _idCategoria;
  set idCategoria(int idCategoria) => _idCategoria = idCategoria;
  int get idGrade => _idGrade;
  set idGrade(int idGrade) => _idGrade = idGrade;
  String get nome => _nome;
  set nome(String nome) => _nome = nome;
  String get iconeCor => _iconeCor;
  set iconeCor(String iconeCor) => _iconeCor = iconeCor;
  double get precoCusto => _precoCusto;
  set precoCusto(double precoCusto) => _precoCusto = precoCusto;
  int get ehativo => _ehativo;
  set ehativo(int ehativo) => _ehativo = ehativo;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;
  Categoria get categoria => _categoria;
  set categoria(Categoria categoria) => _categoria = categoria;
  Estoque get estoque => _estoque;
  set estoque(Estoque estoque) => _estoque = estoque;
  Grade get grade => _grade;
  set grade(Grade grade) => _grade = grade;
  List<ProdutoImagem> get produtoImagem => _produtoImagem;
  set produtoImagem(List<ProdutoImagem> produtoImagem) =>
      _produtoImagem = produtoImagem;
  List<ProdutoVariante> get produtoVariante => _produtoVariante;
  set produtoVariante(List<ProdutoVariante> produtoVariante) =>
      _produtoVariante = produtoVariante;
  PrecoTabelaItem get precoTabelaItem => _precoTabelaItem;
  set precoTabelaItem(PrecoTabelaItem precoTabelaItem) => _precoTabelaItem = precoTabelaItem;

  Produto.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoaGrupo = json['id_pessoa_grupo'];
    _idAparente = json['id_aparente'];
    _idCategoria = json['id_categoria'];
    _idGrade = json['id_grade'];
    _nome = json['nome'];
    _iconeCor = json['iconecor'];
    _precoCusto = double.parse(json['preco_custo'].toString());
    _ehativo = json['ehativo'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
    _categoria = json['categoria'] != null
        ? new Categoria.fromJson(json['categoria'])
        : null;
    _estoque = json['estoque'] != null 
      ? Estoque.fromJson(json['estoque'])
      : null;
    _grade = json['grade'] != null ? new Grade.fromJson(json['grade']) : null;
    if (json['produto_imagem'] != null) {
      _produtoImagem = new List<ProdutoImagem>();
      json['produto_imagem'].forEach((v) {
        _produtoImagem.add(new ProdutoImagem.fromJson(v));
      });
    }
    if (json['produto_variante'] != null) {
      _produtoVariante = new List<ProdutoVariante>();
      json['produto_variante'].forEach((v) {
        _produtoVariante.add(new ProdutoVariante.fromJson(v));
      });
    }
    _precoTabelaItem = json['preco_tabela_item'] != null
        ? new PrecoTabelaItem.fromJson(json['preco_tabela_item'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_pessoa_grupo'] = this._idPessoaGrupo;
    data['id_aparente'] = this._idAparente;
    data['id_categoria'] = this._idCategoria;
    data['id_grade'] = this._idGrade;
    data['nome'] = this._nome;
    data['iconecor'] = this._iconeCor;
    data['preco_custo'] = this._precoCusto;
    data['ehativo'] = this._ehativo;
    data['data_cadastro'] = this._dataCadastro.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    if (this._categoria != null) {
      data['categoria'] = this._categoria.toJson();
    }
    if(this._estoque != null){
      data['estoque'] = this._estoque.toJson();
    }
    if (this._grade != null) {
      data['grade'] = this._grade.toJson();
    }
    if (this._produtoImagem != null) {
      data['produto_imagem'] =
          this._produtoImagem.map((v) => v.toJson()).toList();
    }
    if (this._produtoVariante != null) {
      data['produto_variante'] =
          this._produtoVariante.map((v) => v.toJson()).toList();
    }
    if (this._precoTabelaItem != null) {
      data['preco_tabela_item'] = this._precoTabelaItem.toJson();
    }
    return data;
  }
}
