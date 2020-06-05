import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:rxdart/rxdart.dart';

class VendaTransacaoBloc extends BlocBase {
  //dispose will be called automatically by closing its streams
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  Transacao _transacao;
  List<Transacao> _transacaoList = [];
  BehaviorSubject<Transacao> _transacaoController;
  Stream<Transacao> get transacaoOut => _transacaoController.stream;
  BehaviorSubject<List<Transacao>> _transacaoListController;
  Stream<List<Transacao>> get transacaoListOut =>
      _transacaoListController.stream;

  VendaTransacaoBloc(this._hasuraBloc, this._appGlobalBloc){
    _transacao = Transacao();
    _transacaoListController = BehaviorSubject.seeded(_transacaoList);    
  }

  getAllTransacao() async {
    TransacaoDAO transacaoDAO = TransacaoDAO(_hasuraBloc, _transacao, _appGlobalBloc);
    _transacaoList = await transacaoDAO.getAll();
    _transacaoListController.add(_transacaoList);
  } 

  @override
  void dispose() {
    //_transacaoController.close();
    _transacaoListController.close();
    super.dispose();
  }
}
