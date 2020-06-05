import 'package:common_files/src/bloc/cadastro/pessoa_bloc.dart';
import 'package:common_files/src/bloc/hasura_bloc.dart';

class VendedorBloc extends PessoaBloc{
  HasuraBloc _hasuraBloc;
  String filtroNome="";
  

  VendedorBloc(this._hasuraBloc) : super(_hasuraBloc) {
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
