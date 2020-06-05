import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'LoadingIcon.dart';

class DynamicListView extends StatefulWidget {
  DynamicListView.build({
    Key key,
    @required this.itemBuilder,
    @required this.dataRequester,
    @required this.initRequester,
    this.bloc,
    this.stream,
    this.initLoadingWidget,
    this.moreLoadingWidget,
    this.noDataWidget
  })
      : assert(itemBuilder != null),
        assert(dataRequester != null),
        assert(initRequester != null),
        super(key: key);

  final Function itemBuilder;
  final Function dataRequester;
  final Function initRequester;
  final Widget initLoadingWidget;
  final Widget moreLoadingWidget;
  final Widget noDataWidget;
  final dynamic bloc;
  final Stream stream;

  @override
  State createState() => new DynamicListViewState();
}

class DynamicListViewState extends State<DynamicListView> {
  ScrollController _controller = new ScrollController();
  DynamicListViewBloc dynamicListViewBloc;

  @override
  void initState() {
    super.initState();
    dynamicListViewBloc = DynamicListViewBloc();
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

  @override
  Widget build(BuildContext context) {
    Color loadingColor = Colors.white;
    bool visible = false;
    widget.stream.where((list) => list != null).listen((onData){
      dynamicListViewBloc.updateDataList(onData);
    }, cancelOnError: false);

    Widget customNoDataWidget = CircularProgressIndicator(backgroundColor: Colors.white,);

    return StreamBuilder<List<dynamic>>(
      initialData: List<dynamic>(0),
      stream: dynamicListViewBloc.dataListOut,
      builder: (context, snapshot) {
        List<dynamic> _internalDataList = snapshot.data;
        return AnimatedSwitcher(
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          duration: Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation){
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: _internalDataList.length == 0 
            ? FutureBuilder(
                future: Future.delayed(Duration(seconds: 2)),
                builder: (context, snapshot) => 
                  snapshot.connectionState == ConnectionState.done
                  ? widget.noDataWidget != null
                    ? widget.noDataWidget 
                    : Center(
                      child: Text("Não há dados a serem exibidos.", 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w300
                        ),
                        textAlign: TextAlign.center
                      ),
                    )
                  : CircularProgressIndicator(backgroundColor: Colors.white,)
              )
            : RefreshIndicator(
            displacement: 20,
            color: loadingColor,
            onRefresh: this._onRefresh,
            child: ListView.builder(
              controller: _controller,
              itemCount: _internalDataList.length + 1,
              itemBuilder: (context, index) {
                if (index == _internalDataList.length) {
                  return StreamBuilder(
                    initialData: true,
                    stream: dynamicListViewBloc.isPerformingRequestOut,
                    builder: (context, snapshot) {
                      return AnimatedOpacity(
                        opacity: snapshot.data ? 0.0 : 0.0,
                        duration: Duration(milliseconds: 200),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            )  
                          ),
                        )
                      );
                    }
                  );
                } else {
                  return widget.itemBuilder(snapshot.data, context, index);
                }
              },
            ),
          )
        );
      }
    );
  }

  Future<Null> _onRefresh() async {
    if(widget.bloc != null){
      widget.bloc.offset = 0;
    }
    List<dynamic> initDataList = await widget.initRequester();
    dynamicListViewBloc.updateDataList(initDataList);
    return;
  }

  _loadMore() async {
    dynamicListViewBloc.updateIsPerformingRequest(true);
    List newDataList = await widget.dataRequester();
    if (newDataList != null) {
      if (newDataList.length == 0) {
        double edge = 50.0;
        double offsetFromBottom = _controller.position.maxScrollExtent - _controller.position.pixels;
        if (offsetFromBottom < edge) {
          _controller.animateTo(_controller.offset - (edge - offsetFromBottom), duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
        }
      } else {
        dynamicListViewBloc.updateDataList(newDataList);
      }
    }
    dynamicListViewBloc.updateIsPerformingRequest(false);
  }
}

Widget loadingProgress(loadingColor, {Widget initLoadingWidget}) {
  if (initLoadingWidget == null) {
    initLoadingWidget = Loading();
  }
  return Center(
    child: initLoadingWidget,
  );
}

Widget opacityLoadingProgress(isPerformingRequest, loadingColor, {Widget loadingWidget}) {
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

class DynamicListViewBloc extends BlocBase {
  bool isPerformingRequest = false;
  BehaviorSubject<bool> isPerformingRequestController;
  Stream<bool> get isPerformingRequestOut => isPerformingRequestController.stream;
  List<dynamic> _dataList = [];
  BehaviorSubject<List<dynamic>> dataListController;
  Stream<List<dynamic>> get dataListOut => dataListController.stream;

  DynamicListViewBloc(){
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