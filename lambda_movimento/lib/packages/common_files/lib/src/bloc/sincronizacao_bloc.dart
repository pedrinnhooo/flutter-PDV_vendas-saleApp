import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:common_files/src/sync/sincronizacao.dart';

class SincronizacaoBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  SharedVendaBloc _vendaBloc;
  Sincronizacao sincronizacao;

  SincronizacaoBloc(this._hasuraBloc, this._vendaBloc) {
    sincronizacao = Sincronizacao(_hasuraBloc, _vendaBloc);
  }

  @override
  void dispose() {
    sincronizacao.dispose();
    super.dispose();
  }
}
