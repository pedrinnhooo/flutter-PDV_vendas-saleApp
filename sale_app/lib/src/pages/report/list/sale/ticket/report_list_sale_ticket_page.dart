import 'package:common_files/common_files.dart';
import 'package:fluggy/src/pages/report/dashboard/dashboard/dashboard_module.dart';
import 'package:fluggy/src/pages/report/list/sale/ticket/report_list_sale_ticket_detail_page.dart';
import 'package:fluggy/src/pages/report/list/sale/ticket/report_list_sale_ticket_module.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import '../../../../../app_module.dart';

class ReportListSaleTicketPage extends StatefulWidget {
  @override
  _ReportListSalePageState createState() => _ReportListSalePageState();
}

class _ReportListSalePageState extends State<ReportListSaleTicketPage>{
  ReportListSaleTicketBloc reportListSaleTicketBloc;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  ReportListSaleTicketTableSource _reportListSaleTicketDataSource;
  DashboardBloc _dashboardBloc;

  @override
  void initState() {    
    reportListSaleTicketBloc = ReportListSaleTicketModule.to.getBloc<ReportListSaleTicketBloc>();
    _dashboardBloc = DashboardModule.to.getBloc<DashboardBloc>();
    reportListSaleTicketBloc.intialDate = _dashboardBloc.dataInicial;
    reportListSaleTicketBloc.finalDate = _dashboardBloc.dataFinal;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  void _sort<T>(
    Comparable<T> getField(ReportListSaleTicketEntity d), int columnIndex, bool ascending) {
      _reportListSaleTicketDataSource._sort<T>(getField, ascending);
      setState(() {
        _sortColumnIndex = columnIndex;
        _sortAscending = ascending;
      });
    }  

  @override
  Widget build(BuildContext context) {    

    Future _initRequester() async {
      return reportListSaleTicketBloc.getReportFromServer();
    }

    Future<List> _dataRequester() async {
      return Future.delayed(Duration(milliseconds: 100), () async {
        return await reportListSaleTicketBloc.getReportFromServer();
      });
    }
    List<CustomDataColumn> _buildColumns() {
      return [
        CustomDataColumn(
          label: Text("Código"),
          tooltip: "Código da venda",
          onSort: (columnIndex, ascending) =>
              _sort<num>((d) => d.saleId, columnIndex, ascending),),
        CustomDataColumn(
          label: Text("Data"),
          tooltip: "Data da venda",
          onSort: (columnIndex, ascending) =>
              _sort<DateTime>((d) => d.dateSale, columnIndex, ascending),),
        CustomDataColumn(
          label: Text("Valor"),
          tooltip: "Valor da venda",
          onSort: (columnIndex, ascending) =>
              _sort<num>((d) => d.totalNetAmount, columnIndex, ascending),),
        CustomDataColumn(
          label: Text("Cliente"),
          tooltip: "Cliente da venda",
          onSort: (columnIndex, ascending) =>
              _sort<String>((d) => d.clientName, columnIndex, ascending),),
        CustomDataColumn(
          label: Text("Vendedor"),
          tooltip: "Vendedor da venda",
          onSort: (columnIndex, ascending) =>
              _sort<String>((d) => d.sellerName, columnIndex, ascending),),
      ];
    }

    Function _itemColumns = () {
      return _buildColumns();
    };

    CustomDataTableSource _buildRows(List dataList, BuildContext context) {
      _reportListSaleTicketDataSource = ReportListSaleTicketTableSource(dataList, context);
      return _reportListSaleTicketDataSource;
    }

    Function _itemSource = (List dataList, BuildContext context) {
      return _buildRows(dataList, context);
    };
    
    return Column(
      children: <Widget>[ 
        Expanded(
          child: DynamicPaginatedDataTable.build(
            appBarHeader: "Relatório de vendas",
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
            bloc: reportListSaleTicketBloc,
            stream: reportListSaleTicketBloc.reportListSaleOut,
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

class ReportListSaleTicketTableSource extends CustomDataTableSource {
  List _dataList;
  int _rowSelectedCount = 0;
  SharedVendaBloc saleBloc = AppModule.to.getBloc<SharedVendaBloc>();
  BuildContext context;

  ReportListSaleTicketTableSource(this._dataList, BuildContext context){
    this.context = context;
  }
  
  @override
  CustomDataRow getRow(int index) {
    if (index < 0 || index > _dataList.length)
      return null;
    else {
      return CustomDataRow.byIndex(
        onSelectChanged: (booleano) async {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => ReportListSaleTicketDetailPage(index: _dataList[index].saleId,),
              settings: RouteSettings(name: '/ReportListSaleTicketDetailPage'),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 180),
            ),
          );
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
      CustomDataCell(
        Text("${_dataList.saleId}", style: TextStyle(fontSize: 10.00),),
        hasData: true
      ),
      CustomDataCell(
        Text("${DateFormat('dd/MM/yyyy').format(_dataList.dateSale)}", style: TextStyle(fontSize: 10.00),),
        hasData: true
      ),      
      CustomDataCell(
        Container(
          alignment: Alignment.centerRight,
          child: Text("${NumberFormat("#,##0.00", "pt_BR").format(_dataList.totalNetAmount)}", style: TextStyle(fontSize: 10.00),)),
        hasData: true
      ),
      CustomDataCell(
        Text("${_dataList.clientName}", style: TextStyle(fontSize: 10.00),),
        hasData: true
      ),
      CustomDataCell(
        Text("${_dataList.sellerName}", style: TextStyle(fontSize: 10.00),),
        hasData: true
      ),
    ];
  }

  void _sort<T>(Comparable<T> getField(ReportListSaleTicketEntity d), bool ascending) {
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