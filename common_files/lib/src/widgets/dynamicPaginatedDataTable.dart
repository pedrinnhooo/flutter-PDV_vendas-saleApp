import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;

import 'LoadingIcon.dart';
import 'custom/custom_paginated_data_table.dart';
  
class DynamicPaginatedDataTable extends StatefulWidget {
  DynamicPaginatedDataTable.build({
    Key key,
    @required this.header,
    @required this.itemColumns,
    @required this.itemSource,
    this.sortColumnIndex,
    this.sortAscending,
    this.rowsPerPage,
    this.initLoadingWidget,
    this.moreLoadingWidget,
    @required this.dataRequester,
    @required this.initRequester,
    this.bloc,
    this.stream,
    this.appBarHeader,
    this.rowColor = Colors.transparent,
    this.headersBackgroundColor = Colors.transparent,
    this.columnSortedColor = Colors.transparent,
    this.darkColumnsNameColor = Colors.white,
    this.selectedSortedHeaderColor = Colors.white,
    this.bottomColor = Colors.transparent,
    this.headerBorder = false,
  })
      : assert(header != null),
        assert(itemColumns != null),
        assert(itemSource != null),
        super(key: key);

  final String header;
  final Function itemColumns;
  final Function itemSource;
  final int sortColumnIndex;
  final bool sortAscending;
  final int rowsPerPage;
  final Widget initLoadingWidget;
  final Widget moreLoadingWidget;
  final Function dataRequester;
  final Function initRequester;
  final dynamic bloc;
  final Stream stream;
  final String appBarHeader;
  final Color rowColor;
  final Color headersBackgroundColor;
  final Color columnSortedColor;
  final Color darkColumnsNameColor;
  final Color selectedSortedHeaderColor;
  final Color bottomColor;
  final bool headerBorder;

  @override
  State createState() => new DynamicPaginatedDataTableState();
}

class DynamicPaginatedDataTableState extends State<DynamicPaginatedDataTable> {
  bool isPerformingRequest = false;
  ScrollController _controller = new ScrollController();
  DynamicPaginatedDataTableBloc dynamicPaginatedDataTableBloc;
  List _dataList;
  int _rowsPerPage;
  
  @override
  void initState() {
    _rowsPerPage = widget.rowsPerPage;
    super.initState();
    dynamicPaginatedDataTableBloc = DynamicPaginatedDataTableBloc();
    dynamicPaginatedDataTableBloc.updateDataList(this._dataList);
    this._onRefresh();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget returnRangePicker(BuildContext context) {
    return new Theme(
      data: Theme.of(context).copyWith(
        accentColor: Theme.of(context).primaryIconTheme.color,
        indicatorColor: Colors.white,
        dialogBackgroundColor: Theme.of(context).primaryColor,
        primaryColor: Theme.of(context).accentColor, // Header
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.accent,
          highlightColor: Colors.white, // onHover
          buttonColor: Theme.of(context).primaryColor,
          colorScheme: Theme.of(context).colorScheme.copyWith(
            onSecondary: Colors.yellow,
            primary: Colors.blueAccent,
            surface: Colors.pinkAccent,
            secondary: Theme.of(context).primaryIconTheme.color,
            brightness: Brightness.dark,
            onBackground: Theme.of(context).primaryColor
          ),
          disabledColor: Colors.redAccent
        )
      ),
      child: new Builder(
        builder: (context) => new FlatButton(
          onPressed: () async {
            final List<DateTime> picked = await DateRangePicker.showDatePicker(
              locale: Locale("pt"),
              context: context,
              firstDate: DateTime(DateTime.now().year-1,1,1),
              initialFirstDate: DateTime.now(),
              initialLastDate: DateTime.now(),
              lastDate: DateTime(DateTime.now().year,12,31)
            );
            if (picked != null && picked.length >= 2) {
              _onDateChange(picked[0], picked[1]);
            }
          },
          child: Icon(Icons.filter_list, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color loadingColor = Colors.white;
    widget.stream.where((list) => list != null).listen((onData){
      dynamicPaginatedDataTableBloc.updateDataList(onData);
    }, cancelOnError: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.appBarHeader, style: Theme.of(context).textTheme.title),
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: returnRangePicker(context),
            // InkWell(
            //   child: Icon(Icons.filter_list), onTap: () async {
            //     final List<DateTime> picked = await DateRangePicker.showDatePicker(
            //       locale: Locale("pt"),
            //       context: context,
            //       firstDate: DateTime(DateTime.now().year-1,1,1),
            //       initialFirstDate: DateTime.now(),
            //       initialLastDate: DateTime.now(),
            //       lastDate: DateTime(DateTime.now().year,12,31)
            //     );
            //     if (picked != null && picked.length >= 2) {
            //       _onDateChange(picked[0], picked[1]);
            //     }
            //   }
            // ),
          )
        ]
      ),    
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: StreamBuilder(
                          stream: dynamicPaginatedDataTableBloc.dataListOut,
                          builder: (context, snapshot) {
                            List<dynamic> _internalDataList = snapshot.data;
                            if(!snapshot.hasData || snapshot.data.length == 0){
                              return dataTableloadingProgress(
                                loadingColor,
                                initLoadingWidget: this.widget.initLoadingWidget,
                              );
                            } else if(_internalDataList.length == 0){
                              return Center(
                                child: Text("Não há dados a serem exibidos", 
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300
                                ),
                                textAlign: TextAlign.center),
                              );
                            } else {
                              return RefreshIndicator(
                                displacement: 20,
                                color: loadingColor,
                                onRefresh: this._onRefresh,
                                child: CustomPaginatedDataTable(
                                  header: Container(
                                    color: Theme.of(context).primaryColor,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            "Período: " + DateFormat('dd/MM/yyyy').format(widget.bloc.intialDate)
                                                        +" à " +
                                                          DateFormat('dd/MM/yyyy').format(widget.bloc.finalDate),
                                            style: TextStyle(color: Colors.white70, fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                  rowsPerPage: _rowsPerPage,
                                  availableRowsPerPage: <int>[PaginatedDataTable.defaultRowsPerPage, PaginatedDataTable.defaultRowsPerPage * 2],
                                  onRowsPerPageChanged: (value) {
                                    setState(() {
                                      _rowsPerPage = value;
                                    });
                                  },
                                  sortColumnIndex: widget.sortColumnIndex,
                                  sortAscending: widget.sortAscending,
                                  columns: widget.itemColumns(),
                                  source: widget.itemSource(snapshot.data, context),
                                  columnSpacing: 15,
                                  onPageChanged: (value){                            
                                    _loadMore();
                                  },
                                  cardColor: Theme.of(context).accentColor,
                                  darkColumnsNameColor: widget.darkColumnsNameColor,
                                  lightColumnsNameColor: Colors.white,
                                  darkRowsNameColor: Colors.white,
                                  lightRowsNameColor: Colors.white,
                                  rowColor: widget.rowColor,
                                  headersBackgroundColor: widget.headersBackgroundColor,
                                  headerBorder: widget.headerBorder,
                                  columnSortedColor: widget.columnSortedColor,
                                  selectedSortedHeaderColor: widget.selectedSortedHeaderColor,
                                  bottomColor: widget.bottomColor,
                                  totalRegisterCount: snapshot.data[0].registerCount,
                                )
                              );
                            }
                          }
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      )
    );
  }

  Future<Null> _onDateChange(DateTime initialDate, DateTime finalDate) async {
    if(widget.bloc != null){
      widget.bloc.intialDate = initialDate;
      widget.bloc.finalDate = finalDate;
      widget.bloc.offset = 0;
    }
    List<dynamic> initDataList = await widget.initRequester();
    dynamicPaginatedDataTableBloc.updateDataList(initDataList);
    return;
  }

  Future<Null> _onRefresh() async {
    if(widget.bloc != null){
      widget.bloc.offset = 0;
    }
    List<dynamic> initDataList = await widget.initRequester();
    dynamicPaginatedDataTableBloc.updateDataList(initDataList);
    return;
  }

  _loadMore() async {
    dynamicPaginatedDataTableBloc.updateIsPerformingRequest(true);
    List newDataList = await widget.dataRequester();
    if (newDataList != null) {
      if (newDataList.length == 0) {
        double edge = 50.0;
        double offsetFromBottom = _controller.position.maxScrollExtent - _controller.position.pixels;
        if (offsetFromBottom < edge) {
          _controller.animateTo(_controller.offset - (edge - offsetFromBottom), duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
        }
      } else {
        //dynamicPaginatedDataTableBloc.addToDataList(newDataList);
        dynamicPaginatedDataTableBloc.updateDataList(newDataList);
      }
    }
    dynamicPaginatedDataTableBloc.updateIsPerformingRequest(false);
  }
}

Widget dataTableloadingProgress(loadingColor, {Widget initLoadingWidget}) {
  if (initLoadingWidget == null) {
    initLoadingWidget = Loading();
  }
  return Center(
    child: initLoadingWidget,
  );
}

Widget dataTableopacityLoadingProgress(isPerformingRequest, loadingColor, {Widget loadingWidget}) {
  if (loadingWidget == null) {
    loadingWidget = Loading();
  }
  return new Padding(
    padding: const EdgeInsets.all(8.0),
    child: new Center(
      child: new Opacity(
        opacity: isPerformingRequest ? 1.0 : 0.0,
        child: loadingWidget,
      ),
    ),
  );
}

class DynamicPaginatedDataTableBloc extends BlocBase {
  bool isPerformingRequest = false;
  BehaviorSubject<bool> isPerformingRequestController;
  Stream<bool> get isPerformingRequestOut => isPerformingRequestController.stream;
  List<dynamic> _dataList = [];
  BehaviorSubject<List<dynamic>> dataListController;
  Stream<List<dynamic>> get dataListOut => dataListController.stream;

  DynamicPaginatedDataTableBloc(){
    dataListController = BehaviorSubject.seeded(_dataList);
    isPerformingRequestController = BehaviorSubject.seeded(isPerformingRequest);
  }

  updateIsPerformingRequest(bool value){
    isPerformingRequest = value;
    isPerformingRequestController.add(isPerformingRequest);
  }

  addToDataList(List<dynamic> newValuesToDataList){
    _dataList += newValuesToDataList;
    dataListController.add(_dataList);
  }

  updateDataList(List<dynamic> newDataList){
    _dataList = newDataList;
    dataListController.add(_dataList);
  }

  @override
  void dispose() {
    dataListController.close();
    isPerformingRequestController.close();
    super.dispose();
  }
}