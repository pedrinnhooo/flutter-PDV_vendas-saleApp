import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:common_files/common_files.dart';

class ReportListSaleProductBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  ReportListSaleProductEntity reportListSaleProductEntity;
  ReportListSaleProductDAO reportListSaleProductDAO;
  List<ReportListSaleProductEntity> reportListProductSale = [];
  BehaviorSubject<List<ReportListSaleProductEntity>> reportListSaleProductController;
  Stream<List<ReportListSaleProductEntity>> get reportListSaleOut => reportListSaleProductController.stream;
  int offset = 0;
  int rowsPerPage = 11;
  DateTime intialDate = DateTime.now();
  DateTime finalDate = DateTime.now();

  ReportListSaleProductBloc(this._hasuraBloc, this._appGlobalBloc) {
    reportListSaleProductEntity = ReportListSaleProductEntity();
    reportListSaleProductDAO = ReportListSaleProductDAO(_hasuraBloc, _appGlobalBloc, reportListSaleProductEntity: reportListSaleProductEntity);
    reportListSaleProductController = BehaviorSubject.seeded(reportListProductSale);
  }
  
  getReportFromServer() async {
    ReportListSaleProductEntity _reportListSaleProductEntity = ReportListSaleProductEntity();
    ReportListSaleProductDAO _reportListSaleProductDAO = ReportListSaleProductDAO(_hasuraBloc, _appGlobalBloc, reportListSaleProductEntity: _reportListSaleProductEntity);
    reportListProductSale = offset == 0 ? [] : reportListProductSale; 
    reportListProductSale += await _reportListSaleProductDAO.getReportFromServer(personId: 0, initialDate: intialDate, finalDate: finalDate, offset: offset, rowsPerPage: rowsPerPage);
    reportListSaleProductController.add(reportListProductSale);
    offset += rowsPerPage;
    return reportListProductSale;
  }
  
    @override
    void dispose() {
      reportListSaleProductController.close();
      super.dispose();
    }
  }