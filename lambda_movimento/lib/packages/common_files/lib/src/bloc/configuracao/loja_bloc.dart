import 'package:common_files/src/bloc/cadastro/pessoa_bloc.dart';
import 'package:common_files/src/bloc/hasura_bloc.dart';

class LojaBloc extends PessoaBloc {
  HasuraBloc _hasuraBloc;
  String filtroNome="";
  
  LojaBloc(this._hasuraBloc) : super(_hasuraBloc) {
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
