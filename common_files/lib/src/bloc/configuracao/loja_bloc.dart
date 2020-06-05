import 'package:common_files/common_files.dart';

class LojaBloc extends PessoaBloc {
  SharedVendaBloc _sharedVendaBloc;
  HasuraBloc _hasuraBloc;
  AppGlobalBloc appGlobalBloc;
  String filtroNome="";
  
  LojaBloc(this._hasuraBloc, this._sharedVendaBloc, this.appGlobalBloc) : super(_hasuraBloc, _sharedVendaBloc, appGlobalBloc) {
    initPessoaBloc();
  }
  
  @override
  initPessoaBloc() {
    ehLoja = true;
    ehCliente = false;
    ehFornecedor = false;
    ehVendedor = false;
    ehRevenda = false;
  }

  @override
  savePessoa() {
    pessoa.ehLoja = 1;
    super.savePessoa();
  }  

  @override
  void dispose() {
    super.dispose();
  }
}
