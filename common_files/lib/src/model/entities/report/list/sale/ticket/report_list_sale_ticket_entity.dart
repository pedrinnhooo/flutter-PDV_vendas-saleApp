import 'package:common_files/common_files.dart';

class ReportListSaleTicketEntity implements IEntity {
  int _personGroupId;
  int _saleId;
  DateTime _dateSale;
  double _totalNetAmount;
  int _clientId;
  String _clientName;
  int _sellerId;
  String _sellerName;
  int _registerCount;

  ReportListSaleTicketEntity(
      {int personGroupId,
      int saleId,
      DateTime dateSale,
      double totalNetAmount = 0.0,
      int clientId = 0,
      String clientName = '',
      int sellerId,
      String sellerName = '',
      int registerCount}) {
    this._personGroupId =  personGroupId;        
    this._saleId =         saleId;
    this._dateSale =       dateSale;
    this._totalNetAmount = totalNetAmount;
    this._clientId =       clientId;
    this._clientName =     clientName;
    this._sellerId =       sellerId;
    this._sellerName =     sellerName;
    this._registerCount =  registerCount;
  }

  int get personGroupId => _personGroupId;
  set personGroupId(int _personGroupId) => _personGroupId = personGroupId;

  int get saleId => _saleId;
  set saleId(int _saleId) => _saleId = saleId;

  DateTime get dateSale => _dateSale;
  set dateSale(DateTime _dateSale) => _dateSale = dateSale;

  double get totalNetAmount => _totalNetAmount;
  set totalNetAmount(double _totalNetAmount) => _totalNetAmount = totalNetAmount;

  int get clientId => _clientId;
  set clientId(int _clientId) => _clientId = clientId;

  String get clientName => _clientName;
  set clientName(String _clientName) => _clientName = clientName;

  int get sellerId => _sellerId;
  set sellerId(int _sellerId) => _sellerId = sellerId;

  String get sellerName => _sellerName;
  set sellerName(String _sellerName) => _sellerName = sellerName;

  int get registerCount => _registerCount;
  set registerCount(int _registerCount) => _registerCount = registerCount;
  
  String toString() {
    return '''
      personGroupId:  ${_personGroupId.toString()},
      saleId:         ${_saleId.toString()},    
      dateSale:       ${_dateSale.toString()}, 
      totalNetAmount: ${_totalNetAmount.toString()}, 
      clientId:       ${_clientId.toString()},
      clientName:     $_clientName,
      sellerId:       ${_sellerId.toString()},
      sellerName:     $_sellerName,
      registerCount:  $_registerCount,
    ''';
  }

  ReportListSaleTicketEntity.fromJson(Map<String, dynamic> json) {
    _personGroupId =  json['person_grou_id'];
    _saleId =         json['saleId'];
    _dateSale =       DateTime.parse(json['dateSale']);
    _totalNetAmount = json['totalNetAmount'];
    _clientId =       json['clientId'];
    _clientName =     json['clientName'];
    _sellerId =       json['sellerId'];
    _sellerName =     json['sellerName'];
    _registerCount =  json['registerCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['person_grou_id'] =  this._personGroupId;
    data['saleId'] =          this._saleId;
    data['dateSale'] =        this._dateSale;
    data['totalNetAmount'] =  this._totalNetAmount;
    data['clientId'] =        this._clientId;
    data['clientName'] =      this._clientName;
    data['sellerId'] =        this._sellerId;
    data['sellerName'] =      this._sellerName;
    data['registerCount'] =   this._registerCount;
    return data;
  }

  static List<ReportListSaleTicketEntity> fromJsonList(List list){
    if(list == null) return null;
    return list
      .map((item) => ReportListSaleTicketEntity.fromJson(item))
      .toList();
  }  
}
