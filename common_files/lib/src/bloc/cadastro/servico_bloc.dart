import 'package:common_files/common_files.dart';

class ServicoBloc extends ProdutoBloc {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc appGlobalBloc;
  ConsultaEstoqueBloc _consultaEstoqueBloc;
  String filtroNome="";
  
  ServicoBloc(this._hasuraBloc, this.appGlobalBloc, this._consultaEstoqueBloc) : super(_hasuraBloc, appGlobalBloc, _consultaEstoqueBloc) {
    initProdutoBloc();
  }
  
  @override
  initProdutoBloc() {
    ehServico = true;
  }

  @override
  saveProduto() {
    produto.ehservico = 1;
    super.saveProduto();
  }  

  @override
  void dispose() {
    super.dispose();
  }
}
