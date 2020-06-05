import 'package:common_files/common_files.dart';

class ReportListSalePaymentEntity implements IEntity {
  int _personGroupId;
  int _paymentId;
  String _paymentDescription;
  double _soldAmount;
  double _netTotal;
  double _percentageSale;
  int _registerCount;

  ReportListSalePaymentEntity(
      {int personGroupId,
      int paymentId,
      String paymentDescription = "",
      double soldAmount = 0.00,
      double netTotal = 0.00,
      double percentageSale = 0.00,
      int registerCount = 0}) {
    this._personGroupId = personGroupId;        
    this._paymentId = paymentId;
    this._paymentDescription = paymentDescription;
    this._soldAmount = soldAmount;
    this._netTotal = netTotal;
    this._percentageSale = percentageSale;
    this._registerCount = registerCount;
  }

  int get personGroupId => _personGroupId;
  set personGroupId(int _personGroupId) => _personGroupId = personGroupId;

  int get paymentId => _paymentId;
  set paymentId(int _paymentId) => _paymentId = paymentId;
  
  String get paymentDescription => _paymentDescription;
  set paymentDescription(String _paymentDescription) => _paymentDescription = paymentDescription;
  
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
      paymentId:          ${_paymentId.toString()},    
      paymentDescription: ${_paymentDescription.toString()}, 
      soldAmount:         ${_soldAmount.toString()},
      netTotal:           $_netTotal,
      percentageSale:     $_percentageSale,
      registerCount:      $_registerCount,
    ''';
  }

  ReportListSalePaymentEntity.fromJson(Map<String, dynamic> json) {
    _personGroupId      = json['person_grou_id'];
    _paymentId          = json['paymentId'];
    _paymentDescription = json['paymentDescription'];
    _soldAmount         = json['soldAmount'];
    _netTotal           = json['netTotal'];
    _percentageSale     = json['percentageSale'];
    _registerCount      = json['registerCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['person_grou_id']      = this._personGroupId;
    data['paymentId']           = this._paymentId;
    data['paymentDescription']  = this._paymentDescription;
    data['soldAmount']          = this._soldAmount;
    data['netTotal']            = this._netTotal;
    data['percentageSale']      = this._percentageSale;
    data['registerCount']       = this._registerCount;
    return data;
  }

  static List<ReportListSalePaymentEntity> fromJsonList(List list){
    if(list == null) return null;
    return list
      .map((item) => ReportListSalePaymentEntity.fromJson(item))
      .toList();
  }  
}
