import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:common_files/common_files.dart';

class ReportListSalePaymentBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  ReportListSalePaymentEntity reportListSalePaymentEntity;
  ReportListSalePaymentDAO reportListSalePaymentDAO;
  List<ReportListSalePaymentEntity> reportListPaymentSale = [];
  BehaviorSubject<List<ReportListSalePaymentEntity>> reportListSalePaymentController;
  Stream<List<ReportListSalePaymentEntity>> get reportListSaleOut => reportListSalePaymentController.stream;
  int offset = 0;
  int rowsPerPage = 11;
  DateTime intialDate = DateTime.now();
  DateTime finalDate = DateTime.now();

  ReportListSalePaymentBloc(this._hasuraBloc, this._appGlobalBloc) {
    reportListSalePaymentEntity = ReportListSalePaymentEntity();
    reportListSalePaymentDAO = ReportListSalePaymentDAO(_hasuraBloc, _appGlobalBloc, reportListSalePaymentEntity: reportListSalePaymentEntity);
    reportListSalePaymentController = BehaviorSubject.seeded(reportListPaymentSale);
  }
  
  getReportFromServer() async {
    ReportListSalePaymentEntity _reportListSalePaymentEntity = ReportListSalePaymentEntity();
    ReportListSalePaymentDAO _reportListSalePaymentDAO = ReportListSalePaymentDAO(_hasuraBloc, _appGlobalBloc, reportListSalePaymentEntity: _reportListSalePaymentEntity);
    reportListPaymentSale = offset == 0 ? [] : reportListPaymentSale; 
    reportListPaymentSale += await _reportListSalePaymentDAO.getReportFromServer(personId: 0, initialDate: intialDate, finalDate: finalDate, offset: offset, rowsPerPage: rowsPerPage);
    reportListSalePaymentController.add(reportListPaymentSale);
    offset += rowsPerPage;
    return reportListPaymentSale;
  }
  
    @override
    void dispose() {
      reportListSalePaymentController.close();
      super.dispose();
    }
  }