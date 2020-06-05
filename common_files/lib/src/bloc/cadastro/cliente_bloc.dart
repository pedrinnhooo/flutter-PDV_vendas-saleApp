import 'package:common_files/common_files.dart';

class ClienteBloc extends PessoaBloc {
  SharedVendaBloc _sharedVendaBloc;
  HasuraBloc _hasuraBloc;
  AppGlobalBloc appGlobalBloc;
  String filtroNome="";
  
  ClienteBloc(this._hasuraBloc, this._sharedVendaBloc, this.appGlobalBloc) : super(_hasuraBloc, _sharedVendaBloc, appGlobalBloc) {
    initPessoaBloc();
  }
  
  @override
  initPessoaBloc() {
    ehLoja = false;
    ehCliente = true;
    ehFornecedor = false;
    ehVendedor = false;
    ehRevenda = false;
  }

  @override
  savePessoa() {
    pessoa.ehCliente = 1;
    super.savePessoa();
  }  

  @override
  void dispose() {
    super.dispose();
  }
}
