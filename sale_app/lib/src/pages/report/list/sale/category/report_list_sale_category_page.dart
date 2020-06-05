import 'package:common_files/common_files.dart';
import 'package:fluggy/src/pages/report/dashboard/dashboard/dashboard_module.dart';
import 'package:fluggy/src/pages/report/list/sale/category/report_list_sale_category_module.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportListSaleCategoryPage extends StatefulWidget {
  @override
  _ReportListSalePageState createState() => _ReportListSalePageState();
}

class _ReportListSalePageState extends State<ReportListSaleCategoryPage>{

  ReportListSaleCategoryBloc reportListSaleCategoryBloc;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  ReportListSaleCategoryTableSource _reportListSaleCategoryDataSource;
  DashboardBloc _dashboardBloc;

  @override
  void initState() {    
    reportListSaleCategoryBloc = ReportListSaleCategoryModule.to.getBloc<ReportListSaleCategoryBloc>();
    _dashboardBloc = DashboardModule.to.getBloc<DashboardBloc>();
    reportListSaleCategoryBloc.intialDate = _dashboardBloc.dataInicial;
    reportListSaleCategoryBloc.finalDate = _dashboardBloc.dataFinal;    
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  void _sort<T>(
    Comparable<T> getField(ReportListSaleCategoryEntity d), int columnIndex, bool ascending) {
      _reportListSaleCategoryDataSource._sort<T>(getField, ascending);
      setState(() {
        _sortColumnIndex = columnIndex;
        _sortAscending = ascending;
      });
    }  

  @override
  Widget build(BuildContext context) {    

    Future _initRequester() async {
      return reportListSaleCategoryBloc.getReportFromServer();
    }

    Future<List> _dataRequester() async {
      return Future.delayed(Duration(milliseconds: 100), () async {
        return await reportListSaleCategoryBloc.getReportFromServer();
      });
    }
    List<CustomDataColumn> _buildColumns() {
      return [
        // CustomDataColumn(
        //   label: Text("Código"),
        //   tooltip: "Código da categoria",
        //   onSort: (columnIndex, ascending) =>
        //       _sort<num>((d) => d.categoryId, columnIndex, ascending),),
        CustomDataColumn(
          label: Text("Descrição"),
          tooltip: "Descrição da categoria",
          onSort: (columnIndex, ascending) =>
              _sort<String>((d) => d.categoryDescription, columnIndex, ascending),),
        CustomDataColumn(
          label: Text("Quantidade"),
          tooltip: "Quantidade categoria vendida",
          onSort: (columnIndex, ascending) =>
              _sort<num>((d) => d.soldAmount, columnIndex, ascending),),
        CustomDataColumn(
          label: Text("Valor"),
          tooltip: "Valor categoria vendida",
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
      _reportListSaleCategoryDataSource = ReportListSaleCategoryTableSource(dataList, context);
      return _reportListSaleCategoryDataSource;
    }

    Function _itemSource = (List dataList, BuildContext context) {
      return _buildRows(dataList, context);
    };

    return Column(
      children: <Widget>[ 
        Expanded(
          child: DynamicPaginatedDataTable.build(
            appBarHeader: "Relatório de categoria",
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
            bloc: reportListSaleCategoryBloc,
            stream: reportListSaleCategoryBloc.reportListSaleOut,
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

class ReportListSaleCategoryTableSource extends CustomDataTableSource {
  List _dataList;
  int _rowSelectedCount = 0;

  ReportListSaleCategoryTableSource(this._dataList, context);  
  @override
  CustomDataRow getRow(int index) {    
    if (index < 0 || index > _dataList.length)
      return null;
    else {
      return CustomDataRow.byIndex(
        onSelectChanged: (booleano) {
          print("CLICK: ${_dataList[index].categoryId}");
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
      //   Text("${_dataList.categoryId}", style: TextStyle(fontSize: 10.00),),
      //   hasData: true
      // ),
      CustomDataCell(
        Text("${_dataList.categoryDescription}", style: TextStyle(fontSize: 10.00),),
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

  void _sort<T>(Comparable<T> getField(ReportListSaleCategoryEntity d), bool ascending) {
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