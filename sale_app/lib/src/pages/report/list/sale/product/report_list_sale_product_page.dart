import 'package:common_files/common_files.dart';
import 'package:fluggy/src/pages/report/dashboard/dashboard/dashboard_module.dart';
import 'package:fluggy/src/pages/report/list/sale/product/report_list_sale_product_module.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportListSaleProductPage extends StatefulWidget {
  @override
  _ReportListSalePageState createState() => _ReportListSalePageState();
}

class _ReportListSalePageState extends State<ReportListSaleProductPage>{

  ReportListSaleProductBloc reportListSaleProductBloc;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  ReportListSaleProductTableSource _reportListSaleProductDataSource;
  DashboardBloc _dashboardBloc;

  @override
  void initState() {    
    reportListSaleProductBloc = ReportListSaleProductModule.to.getBloc<ReportListSaleProductBloc>();
    _dashboardBloc = DashboardModule.to.getBloc<DashboardBloc>();
    reportListSaleProductBloc.intialDate = _dashboardBloc.dataInicial;
    reportListSaleProductBloc.finalDate = _dashboardBloc.dataFinal;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  void _sort<T>(
    Comparable<T> getField(ReportListSaleProductEntity d), int columnIndex, bool ascending) {
      _reportListSaleProductDataSource._sort<T>(getField, ascending);
      setState(() {
        _sortColumnIndex = columnIndex;
        _sortAscending = ascending;
      });
    }  

  @override
  Widget build(BuildContext context) {    

    Future _initRequester() async {
      return reportListSaleProductBloc.getReportFromServer();
    }

    Future<List> _dataRequester() async {
      return Future.delayed(Duration(milliseconds: 100), () async {
        return await reportListSaleProductBloc.getReportFromServer();
      });
    }
    List<CustomDataColumn> _buildColumns() {
      return [
        CustomDataColumn(
          label: Text("Código"),
          tooltip: "Código do produto",
          onSort: (columnIndex, ascending) =>
              _sort<String>((d) => d.productApparentId, columnIndex, ascending),),
        CustomDataColumn(
          label: Text("Nome"),
          tooltip: "Nome do produto",
          onSort: (columnIndex, ascending) =>
              _sort<String>((d) => d.productName, columnIndex, ascending),),
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
      ];
    }

    Function _itemColumns = () {
      return _buildColumns();
    };

    CustomDataTableSource _buildRows(List dataList, BuildContext context) {
      _reportListSaleProductDataSource = ReportListSaleProductTableSource(dataList, context);
      return _reportListSaleProductDataSource;
    }

    Function _itemSource = (List dataList, BuildContext context) {
      return _buildRows(dataList, context);
    };

    return Column(
      children: <Widget>[ 
        Expanded(
          child: DynamicPaginatedDataTable.build(
            appBarHeader: "Relatório de produtos",
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
            bloc: reportListSaleProductBloc,
            stream: reportListSaleProductBloc.reportListSaleOut,
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

class ReportListSaleProductTableSource extends CustomDataTableSource {
  List _dataList;
  int _rowSelectedCount = 0;

  ReportListSaleProductTableSource(this._dataList, context);  
  @override
  CustomDataRow getRow(int index) {    
    if (index < 0 || index > _dataList.length)
      return null;
    else {
      return CustomDataRow.byIndex(
        onSelectChanged: (booleano) {
          print("CLICK: ${_dataList[index].productId}");
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
        Text("${_dataList.productApparentId}", style: TextStyle(fontSize: 10.00),),
        hasData: true
      ),
      CustomDataCell(
        Text("${_dataList.productName}", style: TextStyle(fontSize: 10.00),),
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
    ];
  }

  void _sort<T>(Comparable<T> getField(ReportListSaleProductEntity d), bool ascending) {
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