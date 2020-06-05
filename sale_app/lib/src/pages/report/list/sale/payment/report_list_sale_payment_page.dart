import 'package:common_files/common_files.dart';
import 'package:fluggy/src/pages/report/dashboard/dashboard/dashboard_module.dart';
import 'package:fluggy/src/pages/report/list/sale/payment/report_list_sale_payment_module.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportListSalePaymentPage extends StatefulWidget {
  @override
  _ReportListSalePageState createState() => _ReportListSalePageState();
}

class _ReportListSalePageState extends State<ReportListSalePaymentPage>{

  ReportListSalePaymentBloc reportListSalePaymentBloc;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  ReportListSalePaymentTableSource _reportListSalePaymentDataSource;
  DashboardBloc _dashboardBloc;

  @override
  void initState() {    
    reportListSalePaymentBloc = ReportListSalePaymentModule.to.getBloc<ReportListSalePaymentBloc>();
    _dashboardBloc = DashboardModule.to.getBloc<DashboardBloc>();
    reportListSalePaymentBloc.intialDate = _dashboardBloc.dataInicial;
    reportListSalePaymentBloc.finalDate = _dashboardBloc.dataFinal;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  void _sort<T>(
    Comparable<T> getField(ReportListSalePaymentEntity d), int columnIndex, bool ascending) {
      _reportListSalePaymentDataSource._sort<T>(getField, ascending);
      setState(() {
        _sortColumnIndex = columnIndex;
        _sortAscending = ascending;
      });
    }  

  @override
  Widget build(BuildContext context) {    

    Future _initRequester() async {
      return reportListSalePaymentBloc.getReportFromServer();
    }

    Future<List> _dataRequester() async {
      return Future.delayed(Duration(milliseconds: 100), () async {
        return await reportListSalePaymentBloc.getReportFromServer();
      });
    }
    List<CustomDataColumn> _buildColumns() {
      return [
        // CustomDataColumn(
        //   label: Text("Código"),
        //   tooltip: "Código do tipo de pagamento",
        //   onSort: (columnIndex, ascending) =>
        //       _sort<num>((d) => d.paymentId, columnIndex, ascending),),
        CustomDataColumn(
          label: Text("Descrição"),
          tooltip: "Descrição do tipo de pagamento",
          onSort: (columnIndex, ascending) =>
              _sort<String>((d) => d.paymentDescription, columnIndex, ascending),),
        CustomDataColumn(
          label: Text("Quantidade"),
          tooltip: "Quantidade vendida",
          onSort: (columnIndex, ascending) =>
              _sort<num>((d) => d.soldAmount, columnIndex, ascending),),
        CustomDataColumn(
          label: Text("Valor"),
          tooltip: "Valor vendido",
          onSort: (columnIndex, ascending) =>
              _sort<num>((d) => d.netTotal, columnIndex, ascending),),
        CustomDataColumn(
          label: Text("Percentual"),
          tooltip: "Percentual referente ao total de vendas",
          onSort: (columnIndex, ascending) =>
              _sort<num>((d) => d.percentageSale, columnIndex, ascending),),
      ];
    }

    Function _itemColumns = () {
      return _buildColumns();
    };

    CustomDataTableSource _buildRows(List dataList, BuildContext context) {
      _reportListSalePaymentDataSource = ReportListSalePaymentTableSource(dataList, context);
      return _reportListSalePaymentDataSource;
    }

    Function _itemSource = (List dataList, BuildContext context) {
      return _buildRows(dataList, context);
    };

    return Column(
      children: <Widget>[ 
        Expanded(
          child: DynamicPaginatedDataTable.build(
            appBarHeader: "Relatório de tipo de pagamento",
            header: "",
            itemColumns: _itemColumns,
            itemSource: _itemSource,
            sortColumnIndex: _sortColumnIndex == null ? 0 : _sortColumnIndex,
            sortAscending: _sortAscending,
            rowsPerPage: _rowsPerPage,
            initLoadingWidget: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CircularProgressIndicator(backgroundColor: Colors.white,),
            ),
            moreLoadingWidget: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CircularProgressIndicator(backgroundColor: Colors.white,),
            ),
            dataRequester: _dataRequester,
            initRequester: _initRequester,
            bloc: reportListSalePaymentBloc,
            stream: reportListSalePaymentBloc.reportListSaleOut,
            headerBorder: true,
            selectedSortedHeaderColor: Theme.of(context).primaryIconTheme.color,
            bottomColor: Theme.of(context).primaryColor, 
            rowColor: Colors.white24,
            headersBackgroundColor: Theme.of(context).primaryColor, 
          ),
        ),
      ]
    );
  }
}

class ReportListSalePaymentTableSource extends CustomDataTableSource {
  List _dataList;
  int _rowSelectedCount = 0;

  ReportListSalePaymentTableSource(this._dataList, context);  
  @override
  CustomDataRow getRow(int index) {    
    if (index < 0 || index > _dataList.length)
      return null;
    else {
      return CustomDataRow.byIndex(
        onSelectChanged: (booleano) {
          print("CLICK: ${_dataList[index].paymentId}");
        },
        cells: buildCells(_dataList[index]),
        index: index,
      );
    }
  }

  /// Creates the cells of the table.
  /// 
  /// WARNING: it will make the zebra effect only if Text widget is passed through CustomDataCell.
  ///
  /// The [_dataList] argument must not be null.
  List<CustomDataCell> buildCells(_dataList) {
    return [
      // CustomDataCell(
      //   Text("${_dataList.paymentId}", style: TextStyle(fontSize: 10.00),),
      //   hasData: true
      // ),
      CustomDataCell(
        Text("${_dataList.paymentDescription}", style: TextStyle(fontSize: 10.00),),
        hasData: true
      ),      
      CustomDataCell(
        Container(
          alignment: Alignment.centerRight,
          child: Text("${NumberFormat("#,##0.00", "pt_BR").format(_dataList.soldAmount)}", style: TextStyle(fontSize: 10.00),)),
        hasData: true
      ),
      CustomDataCell(
        Container(
          alignment: Alignment.centerRight,
          child: Text("${NumberFormat("#,##0.00", "pt_BR").format(_dataList.netTotal)}", style: TextStyle(fontSize: 10.00),)),
        hasData: true
      ),
      CustomDataCell(
        Container(
          alignment: Alignment.centerRight,
          child: Text("${NumberFormat("#,##0.00", "pt_BR").format(_dataList.percentageSale)}" + "%", style: TextStyle(fontSize: 10.00),)),
        hasData: true
      ),      
    ];
  }

  void _sort<T>(Comparable<T> getField(ReportListSalePaymentEntity d), bool ascending) {
  _dataList.sort((a, b) {
    final Comparable<T> aValue = getField(a);  
    final Comparable<T> bValue = getField(b);
    return ascending
      ? Comparable.compare(aValue, bValue)
      : Comparable.compare(bValue, aValue);
  });
   notifyListeners();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _dataList.length;

  @override
  int get selectedRowCount => _rowSelectedCount;
}