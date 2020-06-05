import 'package:common_files/common_files.dart';

class VendedorBloc extends PessoaBloc{
  SharedVendaBloc _sharedVendaBloc;
  HasuraBloc _hasuraBloc;
  AppGlobalBloc appGlobalBloc;
  String filtroNome="";
  

  VendedorBloc(this._hasuraBloc, this._sharedVendaBloc, this.appGlobalBloc) : super(_hasuraBloc, _sharedVendaBloc, appGlobalBloc) {
    initPessoaBloc();
  }

  @override
  initPessoaBloc() {
    ehLoja = false;
    ehCliente = false;
    ehFornecedor = false;
    ehVendedor = true;
    ehRevenda = false;
  }

  @override
  savePessoa() {
    pessoa.ehVendedor = 1;
    super.savePessoa();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
