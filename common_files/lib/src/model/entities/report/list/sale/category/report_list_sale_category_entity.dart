import 'package:common_files/common_files.dart';

class ReportListSaleCategoryEntity implements IEntity {
  int _personGroupId;
  int _categoryId;
  String _categoryDescription;
  double _soldAmount;
  double _netTotal;
  double _percentageSale;
  int _registerCount;

  ReportListSaleCategoryEntity(
      {int personGroupId,
      int categoryId,
      String categoryDescription = "",
      double soldAmount = 0.00,
      double netTotal = 0.00,
      double percentageSale = 0.00,
      int registerCount = 0}) {
    this._personGroupId = personGroupId;        
    this._categoryId = categoryId;
    this._categoryDescription = categoryDescription;
    this._soldAmount = soldAmount;
    this._netTotal = netTotal;
    this._percentageSale = percentageSale;
    this._registerCount = registerCount;
  }

  int get personGroupId => _personGroupId;
  set personGroupId(int _personGroupId) => _personGroupId = personGroupId;

  int get categoryId => _categoryId;
  set categoryId(int _categoryId) => _categoryId = categoryId;
  
  String get categoryDescription => _categoryDescription;
  set categoryDescription(String _categoryDescription) => _categoryDescription = categoryDescription;
  
  double get soldAmount => _soldAmount;
  set soldAmount(double _soldAmount) => _soldAmount = soldAmount;
  
  double get netTotal => _netTotal;
  set netTotal(double _netTotal) => _netTotal = netTotal;

  double get percentageSale => _percentageSale;
  set percentageSale(double _percentageSale) => _percentageSale = percentageSale;

  int get registerCount => _registerCount;
  set registerCount(int _registerCount) => _registerCount = registerCount;

  String toString() {
    return '''
      personGroupId:      ${_personGroupId.toString()},
      categoryId:          ${_categoryId.toString()},    
      categoryDescription: ${_categoryDescription.toString()}, 
      soldAmount:         ${_soldAmount.toString()},
      netTotal:           $_netTotal,
      percentageSale:     $_percentageSale,
      registerCount:      $_registerCount,
    ''';
  }

  ReportListSaleCategoryEntity.fromJson(Map<String, dynamic> json) {
    _personGroupId      = json['person_grou_id'];
    _categoryId          = json['categoryId'];
    _categoryDescription = json['categoryDescription'];
    _soldAmount         = json['soldAmount'];
    _netTotal           = json['netTotal'];
    _percentageSale     = json['percentageSale'];
    _registerCount      = json['registerCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['person_grou_id']      = this._personGroupId;
    data['categoryId']           = this._categoryId;
    data['categoryDescription']  = this._categoryDescription;
    data['soldAmount']          = this._soldAmount;
    data['netTotal']            = this._netTotal;
    data['percentageSale']      = this._percentageSale;
    data['registerCount']       = this._registerCount;
    return data;
  }

  static List<ReportListSaleCategoryEntity> fromJsonList(List list){
    if(list == null) return null;
    return list
      .map((item) => ReportListSaleCategoryEntity.fromJson(item))
      .toList();
  }  
}
