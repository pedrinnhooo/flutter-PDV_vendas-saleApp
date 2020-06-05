import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'LoadingIcon.dart';

class DynamicGridView extends StatefulWidget {
  DynamicGridView.build({
    Key key,
    @required this.itemBuilder,
    @required this.dataRequester,
    @required this.initRequester,
    this.gridItemAspectRatio = 1.0,
    this.scrollPhysics = const ClampingScrollPhysics(),
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
  final double gridItemAspectRatio;
  final ScrollPhysics scrollPhysics;
  final Widget initLoadingWidget;
  final Widget moreLoadingWidget;
  final Widget noDataWidget;
  final dynamic bloc;
  final Stream stream;

  @override
  State createState() => new DynamicGridViewState();
}

class DynamicGridViewState extends State<DynamicGridView> {
  ScrollController _controller = new ScrollController();
  DynamicGridViewBloc dynamicListViewBloc;
  List _dataList;

  @override
  void initState() {
    super.initState();
    dynamicListViewBloc = DynamicGridViewBloc();
    dynamicListViewBloc.updateDataList(this._dataList);
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
    widget.stream.where((list) => list != null).listen((onData){
      dynamicListViewBloc.updateDataList(onData);
    }, cancelOnError: false);
    return StreamBuilder(
      stream: dynamicListViewBloc.dataListOut,
      builder: (context, snapshot) {
        List<dynamic> _internalDataList = snapshot.data;
        if(_internalDataList == null){
          return loadingGridProgress(
            loadingColor,
            initLoadingWidget: this.widget.initLoadingWidget,
          );
        } else if(_internalDataList.length == 0){
          return widget.noDataWidget != null 
          ? widget.noDataWidget 
          : Center(
            child: Text("Não há dados a serem exibidos.", 
              style: Theme.of(context).textTheme.body1,
              textAlign: TextAlign.center
            ),
          );
        } else { 
          return RefreshIndicator(
            displacement: 20,
            color: loadingColor,
            onRefresh: this._onRefresh,
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: widget.scrollPhysics,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: widget.gridItemAspectRatio),
              itemCount: _internalDataList.length + 1,
              itemBuilder: (context, index) {
                if (index == _internalDataList.length) {
                  return StreamBuilder(
                    initialData: true,
                    stream: dynamicListViewBloc.isPerformingRequestOut,
                    builder: (context, snapshot) {
                      return AnimatedOpacity(
                        opacity: snapshot.data ? 0.0 : 0.0,
                        duration: Duration(milliseconds: 100),
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          )  
                        )
                      );
                    }
                  );
                } else {
                  return widget.itemBuilder(_internalDataList, context, index);
                }
              },
              controller: _controller,
            ),
          );
        }
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

Widget loadingGridProgress(loadingColor, {Widget initLoadingWidget}) {
  if (initLoadingWidget == null) {
    initLoadingWidget = Loading();
  }
  return Center(
    child: initLoadingWidget,
  );
}

Widget opacityGridLoadingProgress(isPerformingRequest, loadingColor, {Widget loadingWidget}) {
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

class DynamicGridViewBloc extends BlocBase {
  bool isPerformingRequest = false;
  BehaviorSubject<bool> isPerformingRequestController;
  Stream<bool> get isPerformingRequestOut => isPerformingRequestController.stream;
  List<dynamic> _dataList = [];
  BehaviorSubject<List<dynamic>> dataListController;
  Stream<List<dynamic>> get dataListOut => dataListController.stream;

  DynamicGridViewBloc(){
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