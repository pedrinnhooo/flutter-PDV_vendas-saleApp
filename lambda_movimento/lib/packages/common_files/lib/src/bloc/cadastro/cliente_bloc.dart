import 'package:common_files/common_files.dart';

class ClienteBloc extends PessoaBloc {
  HasuraBloc _hasuraBloc;
  String filtroNome="";
  
  ClienteBloc(this._hasuraBloc) : super(_hasuraBloc) {
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
