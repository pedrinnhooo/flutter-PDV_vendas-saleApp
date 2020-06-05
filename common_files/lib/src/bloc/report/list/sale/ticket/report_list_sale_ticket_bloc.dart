import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:common_files/common_files.dart';

class ReportListSaleTicketBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  ReportListSaleTicketEntity reportListSaleTicketEntity;
  ReportListSaleTicketDAO reportListSaleTicketDAO;
  List<ReportListSaleTicketEntity> reportListTicketSale = [];
  BehaviorSubject<List<ReportListSaleTicketEntity>> reportListSaleTicketController;
  Stream<List<ReportListSaleTicketEntity>> get reportListSaleOut => reportListSaleTicketController.stream;
  Movimento movimento;
  BehaviorSubject<Movimento> movimentoController;
  Stream<Movimento> get movimentoOut => movimentoController.stream;
  int offset = 0;
  int rowsPerPage = 11;
  DateTime intialDate = DateTime.now();
  DateTime finalDate = DateTime.now();

  ReportListSaleTicketBloc(this._hasuraBloc, this._appGlobalBloc) {
    movimento = Movimento();
    reportListSaleTicketEntity = ReportListSaleTicketEntity();
    reportListSaleTicketDAO = ReportListSaleTicketDAO(_hasuraBloc, _appGlobalBloc, reportListSaleTicketEntity: reportListSaleTicketEntity);
    reportListSaleTicketController = BehaviorSubject.seeded(reportListTicketSale);
    movimentoController = BehaviorSubject.seeded(movimento);
  }
  
  getReportFromServer() async {
    ReportListSaleTicketEntity _reportListSaleTicketEntity = ReportListSaleTicketEntity();
    ReportListSaleTicketDAO _reportListSaleTicketDAO = ReportListSaleTicketDAO(_hasuraBloc, _appGlobalBloc, reportListSaleTicketEntity: _reportListSaleTicketEntity);
    // _dashboardBloc = DashboardBloc.to.getBloc<DashboardBloc>
    reportListTicketSale = offset == 0 ? [] : reportListTicketSale; 
    reportListTicketSale += await _reportListSaleTicketDAO.getReportFromServer(personId: 0, initialDate: intialDate, finalDate: finalDate, offset: offset, rowsPerPage: rowsPerPage);
    reportListSaleTicketController.add(reportListTicketSale);
    offset += rowsPerPage;
    return reportListTicketSale;
  }

  getSaleById(int id) async {
    try {
      MovimentoDAO _movimentoDAO = MovimentoDAO(_hasuraBloc, _appGlobalBloc, movimento);
      movimento = await _movimentoDAO.getByIdFromServer(id);
      movimentoController.add(movimento);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<report_list_sale_ticket_bloc> getSaleById');
      await log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "report_list_sale_ticket_bloc",
        nomeFuncao: "getSaleById",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: "id: ${id.toString()}"
      );
    }   
  }
  
  @override
  void dispose() {
    reportListSaleTicketController.close();
    movimentoController.close();
    super.dispose();
  }
}