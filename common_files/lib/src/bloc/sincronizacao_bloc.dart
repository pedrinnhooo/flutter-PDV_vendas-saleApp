import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:common_files/src/sync/sincronizacao_lambda.dart';

class SincronizacaoBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  SharedVendaBloc _vendaBloc;
  AppGlobalBloc appGlobalBloc;
  SincronizacaoHasura sincronizacaoHasura;
  SincronizacaoLambda sincronizacaoLambda;

  SincronizacaoBloc(this._hasuraBloc, this._vendaBloc, this.appGlobalBloc) {
    //sincronizacaoHasura = SincronizacaoHasura(_hasuraBloc, _vendaBloc, appGlobalBloc);
    //sincronizacaoLambda = SincronizacaoLambda(_hasuraBloc, _vendaBloc, appGlobalBloc);
  }

  initBloc() async {
    if (sincronizacaoHasura != null) { 
      await _hasuraBloc.initBloc();
      sincronizacaoHasura.dispose();
    }  
    if (sincronizacaoLambda != null) {
      sincronizacaoLambda.dispose();    
    }
    
    sincronizacaoHasura = SincronizacaoHasura(_hasuraBloc, _vendaBloc, appGlobalBloc);
    sincronizacaoLambda = SincronizacaoLambda(_hasuraBloc, _vendaBloc, appGlobalBloc);
  }

  @override
  void dispose() {
    sincronizacaoHasura.dispose();
    sincronizacaoLambda.dispose();
    super.dispose();
  }
}
