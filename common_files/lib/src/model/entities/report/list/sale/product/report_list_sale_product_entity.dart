import 'package:common_files/common_files.dart';

class ReportListSaleProductEntity implements IEntity {
  int _personGroupId;
  int _productId;
  String _productApparentId;
  String _productName;
  double _soldAmount;
  double _netTotal;
  int _registerCount;

  ReportListSaleProductEntity(
      {int personGroupId,
      int productId,
      String productApparentId = "",
      String productName = "",
      double soldAmount = 0.00,
      double netTotal = 0.00,
      int registerCount}) {
    this._personGroupId = personGroupId;        
    this._productId = productId;
    this._productApparentId = productApparentId;
    this._productName = productName;
    this._soldAmount = soldAmount;
    this._netTotal = netTotal;
    this._registerCount = registerCount;
  }

  int get personGroupId => _personGroupId;
  set personGroupId(int personGroupId) => _personGroupId = personGroupId;

  int get productId => _productId;
  set productId(int productId) => _productId = productId;
  
  String get productApparentId => _productApparentId;
  set productApparentId(String productApparentId) => _productApparentId = productApparentId;
  
  String get productName => _productName;
  set productName(String productName) => _productName = productName;
  
  double get soldAmount => _soldAmount;
  set soldAmount(double soldAmount) => _soldAmount = soldAmount;
  
  double get netTotal => _netTotal;
  set netTotal(double netTotal) => _netTotal = netTotal;

  int get registerCount => _registerCount;
  set registerCount(int registerCount) => _registerCount = registerCount;

  String toString() {
    return '''
      personGroupId:      ${_personGroupId.toString()},
      productId:          ${_productId.toString()},    
      productApparentId:  ${_productApparentId.toString()}, 
      productName:        ${_productName.toString()}, 
      soldAmount:         ${_soldAmount.toString()},
      netTotal:           $_netTotal,
      registerCount:      $_registerCount,
    ''';
  }

  ReportListSaleProductEntity.fromJson(Map<String, dynamic> json) {
    _personGroupId      = json['person_grou_id'];
    _productId          = json['productId'];
    _productApparentId  = json['productApparentId'];
    _productName        = json['productName'];
    _soldAmount         = json['soldAmount'];
    _netTotal           = json['netTotal'];
    _registerCount      = json['registerCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['person_grou_id']    = this._personGroupId;
    data['productId']         = this._productId;
    data['productApparentId'] = this._productApparentId;
    data['productName']       = this._productName;
    data['soldAmount']        = this._soldAmount;
    data['netTotal']          = this._netTotal;
    data['registerCount']     = this._registerCount;
    return data;
  }

  static List<ReportListSaleProductEntity> fromJsonList(List list){
    if(list == null) return null;
    return list
      .map((item) => ReportListSaleProductEntity.fromJson(item))
      .toList();
  }  
}
