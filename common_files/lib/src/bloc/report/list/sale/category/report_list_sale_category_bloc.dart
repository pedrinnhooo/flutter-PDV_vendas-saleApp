import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:common_files/common_files.dart';

class ReportListSaleCategoryBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  ReportListSaleCategoryEntity reportListSaleCategoryEntity;
  ReportListSaleCategoryDAO reportListSaleCategoryDAO;
  List<ReportListSaleCategoryEntity> reportListCategorySale = [];
  BehaviorSubject<List<ReportListSaleCategoryEntity>> reportListSaleCategoryController;
  Stream<List<ReportListSaleCategoryEntity>> get reportListSaleOut => reportListSaleCategoryController.stream;
  int offset = 0;
  int rowsPerPage = 11;
  DateTime intialDate = DateTime.now();
  DateTime finalDate = DateTime.now();

  ReportListSaleCategoryBloc(this._hasuraBloc, this._appGlobalBloc) {
    reportListSaleCategoryEntity = ReportListSaleCategoryEntity();
    reportListSaleCategoryDAO = ReportListSaleCategoryDAO(_hasuraBloc, _appGlobalBloc, reportListSaleCategoryEntity: reportListSaleCategoryEntity);
    reportListSaleCategoryController = BehaviorSubject.seeded(reportListCategorySale);
  }
  
  getReportFromServer() async {
    ReportListSaleCategoryEntity _reportListSaleCategoryEntity = ReportListSaleCategoryEntity();
    ReportListSaleCategoryDAO _reportListSaleCategoryDAO = ReportListSaleCategoryDAO(_hasuraBloc, _appGlobalBloc, reportListSaleCategoryEntity: _reportListSaleCategoryEntity);
    reportListCategorySale = offset == 0 ? [] : reportListCategorySale;
    reportListCategorySale += await _reportListSaleCategoryDAO.getReportFromServer(personId: 0, initialDate: intialDate, finalDate: finalDate, offset: offset, rowsPerPage: rowsPerPage);
    reportListSaleCategoryController.add(reportListCategorySale);
    offset += rowsPerPage;
    return reportListCategorySale;
  }
  
    @override
    void dispose() {
      reportListSaleCategoryController.close();
      super.dispose();
    }
  }