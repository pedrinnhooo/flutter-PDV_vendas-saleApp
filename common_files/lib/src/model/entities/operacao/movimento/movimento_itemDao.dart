import 'package:common_files/common_files.dart';

class MovimentoItemDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "movimento_item";
  String filterText;
  int filterMovimento;
  bool loadProduto = false;
  int filterPrecoTabela = 1;
    
  MovimentoItem movimentoItem;
  Produto produto;
  List<MovimentoItem> movimentoItemList;

  @override
  Dao dao;

  MovimentoItemDAO(this._hasuraBloc, this._appGlobalBloc, this.movimentoItem) {
    dao = Dao();
    movimentoItem = movimentoItem == null ? MovimentoItem() : movimentoItem;
    produto = produto == null ? Produto() : produto;
  }  

  @override
  IEntity fromMap(Map<String, dynamic> map) {}

  @override
  Future<List> getAll({bool preLoad=false}) async {
    String where = "1 = 1 and (ehdeletado = 0)";
    where = filterMovimento > 0 ? where + " and id_movimento_app = $filterMovimento" : where; 

    List<dynamic> args = [];

    List list = await dao.getList(this, where, args);
    movimentoItemList = List.generate(list.length, (i) {
      return MovimentoItem(
               idApp: list[i]['id_app'],
               id: list[i]['id'],
               idMovimentoApp: list[i]['id_movimento_app'],
               idMovimento: list[i]['id_movimento'],
               idProduto: list[i]['id_produto'],
               idVariante: list[i]['id_variante'],
               gradePosicao: list[i]['grade_posicao'],
               sequencial: list[i]['sequencial'],
               quantidade: list[i]['quantidade'],
               precoCusto: list[i]['preco_custo'],
               precoTabela: list[i]['preco_tabela'],
               precoVendido: list[i]['preco_vendido'],
               totalBruto: list[i]['total_bruto'],
               totalLiquido: list[i]['total_liquido'],
               totalDesconto: list[i]['total_desconto'],
               ehservico: list[i]['ehservico'],
               observacao: list[i]['observacao'],
               garantia: list[i]['garantia'],
               observacaoInterna: list[i]['observacao_interna'],
               ehdeletado: list[i]['ehdeletado'],
               prazoEntrega: list[i]['prazo_entrega'] != null ? DateTime.parse(list[i]['prazo_entrega']) : DateTime.now(),
               dataCadastro: DateTime.parse(list[i]['data_cadastro']),
               dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
      );
    });
   
    if (preLoad) {
      for (var movimentoItem in movimentoItemList){
        this.produto = Produto();
        ProdutoDAO produtoDAO = ProdutoDAO(_hasuraBloc, _appGlobalBloc, this.produto);

        if (loadProduto) {
          produtoDAO.filterPrecoTabela = this.filterPrecoTabela;
          movimentoItem.produto = await produtoDAO.getById(movimentoItem.idProduto);
        }

        produtoDAO = null;
      }
    }  
    return movimentoItemList;  
  }

  @override
  Future<IEntity> getById(int id) async {
    movimentoItem = await dao.getById(this, id);
    return movimentoItem;
  }

  @override
  Future<IEntity> insert() async {
    this.movimentoItem.idApp = await dao.insert(this);
    return this.movimentoItem;
  }

  @override
  Future<IEntity> delete(int id) async {
    await dao.delete(this, id);
    return this.movimentoItem;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id_app': this.movimentoItem.idApp,
      'id': this.movimentoItem.id,
      'id_movimento_app': this.movimentoItem.idMovimentoApp,
      'id_movimento': this.movimentoItem.idMovimento,
      'id_produto': this.movimentoItem.idProduto,
      'id_variante': this.movimentoItem.idVariante,
      'grade_posicao': this.movimentoItem.gradePosicao,
      'sequencial': this.movimentoItem.sequencial,
      'quantidade': this.movimentoItem.quantidade,
      'preco_custo': this.movimentoItem.precoCusto,
      'preco_tabela': this.movimentoItem.precoTabela,
      'preco_vendido': this.movimentoItem.precoVendido,
      'total_bruto': this.movimentoItem.totalBruto,
      'total_liquido': this.movimentoItem.totalLiquido,
      'total_desconto': this.movimentoItem.totalDesconto,
      'prazo_entrega': this.movimentoItem.prazoEntrega.toString(),
      'garantia': this.movimentoItem.garantia,
      'observacao': this.movimentoItem.observacao,
      'observacao_interna': this.movimentoItem.observacaoInterna,
      'ehservico': this.movimentoItem.ehservico,
      'ehdeletado': this.movimentoItem.ehdeletado,
      'data_cadastro': this.movimentoItem.dataCadastro.toString(),
      'data_atualizacao': this.movimentoItem.dataAtualizacao.toString()
    };
  }
}
