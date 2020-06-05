import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:rxdart/rxdart.dart';

class ConsultaVendaBloc extends BlocBase {
  AppGlobalBloc _appGlobalBloc;
  HasuraBloc _hasuraBloc;
  MovimentoDAO _movimentoDAO;
  Movimento _movimento;

  List<Movimento> _movimentoList = [];
  BehaviorSubject<List<Movimento>> _movimentoListController;
  Stream<List<Movimento>> get movimentoListOut => _movimentoListController.stream;

  ConsultaVendaBloc(this._appGlobalBloc, this._hasuraBloc){
    _movimento = Movimento();
    _movimentoListController = BehaviorSubject.seeded(_movimentoList);
  }

  getAllMovimento(DateTime dataInicial, DateTime dataFinal) async {
    _movimentoDAO = MovimentoDAO(this._hasuraBloc, this._appGlobalBloc, _movimento);
    _movimentoDAO.filterEhOrcamento = false;
    _movimentoDAO.filterEhCancelado = FilterEhCancelado.naoCancelados;
    _movimentoDAO.loadMovimentoItem = true;
    _movimentoDAO.loadProduto = true;
    _movimentoDAO.filterData = true;
    _movimentoDAO.filterDataInicial = dataFinal;
    _movimentoDAO.filterDataFinal = dataFinal;
    _movimentoList = await _movimentoDAO.getAll(preLoad: true);
    _movimentoListController.add(_movimentoList);
  }

  cancelMovimento(int index) async {
    _movimentoList[index].ehcancelado = 1;
    _movimentoList[index].ehsincronizado = 0;
    _movimentoList[index].ehfinalizado = 0;
    MovimentoDAO movimentoDAO = MovimentoDAO(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>(), _movimentoList[index]);
    await movimentoDAO.insert();
    movimentoDAO = null;
    _movimentoList = await _movimentoDAO.getAll(preLoad: true);
    _movimentoListController.add(_movimentoList);
  }

  @override
  void dispose() {
    _movimentoListController.close();
    super.dispose();
  }
}
