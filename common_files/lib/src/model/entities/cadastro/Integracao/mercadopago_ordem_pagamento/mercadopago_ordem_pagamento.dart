import 'package:dio/dio.dart';

class MercadopagoOrdemPagamento {
  String _externalReference;
  String _notificationUrl;
  List<Items> _items;
  String _mercadopagoQrCode; 

  MercadopagoOrdemPagamento(
      {String externalReference,
       String notificationUrl, 
       List<Items> items,
       String mercadopagoQrCode}) {
    this._externalReference = externalReference;
    this._notificationUrl = notificationUrl;
    this._items = items;
    this._mercadopagoQrCode = mercadopagoQrCode;
  }

  String get externalReference => _externalReference;
  set externalReference(String externalReference) =>
      _externalReference = externalReference;
  String get notificationUrl => _notificationUrl;
  set notificationUrl(String notificationUrl) =>
      _notificationUrl = notificationUrl;
  List<Items> get items => _items;
  set items(List<Items> items) => _items = items;
  String get mercadopagoQrCode => _mercadopagoQrCode;
  set mercadopagoQrCode(String mercadopagoQrCode) => _mercadopagoQrCode = mercadopagoQrCode;

  MercadopagoOrdemPagamento.fromJson(Map<String, dynamic> json) {
    _externalReference = json['external_reference'];
    _notificationUrl = json['notification_url'];
    if (json['items'] != null) {
      _items = new List<Items>();
      json['items'].forEach((v) {
        _items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['external_reference'] = this._externalReference;
    data['notification_url'] = this._notificationUrl;
    if (this._items != null) {
      data['items'] = this._items.map((v) => v.toJson()).toList();
    }
    return data;
  }
  
  Future<MercadopagoOrdemPagamento> mercadopagoOrdemPagamentoPost(String accessToken, String userId, String idLoja) async {
    var dio = Dio();
    print('Json Ordem');
    print(this.toJson());
    try {
      Response response = await dio.post(
        "https://api.mercadopago.com/mpmobile/instore/qr/$userId/$idLoja?access_token=APP_USR-$accessToken",
        data: this.toJson());
      print(response.statusCode.toString());  
    } catch (erro) {
      print(erro.response.data);
      return null;  
    }
  }
}

class Items {
  String _title;
  String _currencyId;
  double _unitPrice;
  double _quantity;

  Items({String title, String currencyId, double unitPrice, double quantity}) {
    this._title = title;
    this._currencyId = currencyId;
    this._unitPrice = unitPrice;
    this._quantity = quantity;
  }

  String get title => _title;
  set title(String title) => _title = title;
  String get currencyId => _currencyId;
  set currencyId(String currencyId) => _currencyId = currencyId;
  double get unitPrice => _unitPrice;
  set unitPrice(double unitPrice) => _unitPrice = unitPrice;
  double get quantity => _quantity;
  set quantity(double quantity) => _quantity = quantity;

  Items.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _currencyId = json['currency_id'];
    _unitPrice = json['unit_price'];
    _quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this._title;
    data['currency_id'] = this._currencyId;
    data['unit_price'] = this._unitPrice;
    data['quantity'] = this._quantity;
    return data;
  }
}