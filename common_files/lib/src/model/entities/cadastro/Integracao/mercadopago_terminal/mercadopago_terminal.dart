import 'package:dio/dio.dart';

class MercadopagoTerminal {
  String _name;
  bool _fixedAmount;
  Null _category;
  String _storeId;
  String _externalStoreId;
  String _externalId;
  String _idTerminal; 
  String _qrCode;
  String _status;

  MercadopagoTerminal(
      {String name,
      bool fixedAmount,
      Null category,
      String storeId,
      String externalStoreId,
      String externalId,
      String idTerminal,
      String qrCode,
      String status}) {
    this._name = name;
    this._fixedAmount = fixedAmount;
    this._category = category;
    this._storeId = storeId;
    this._externalStoreId = externalStoreId;
    this._externalId = externalId;
    this._idTerminal = idTerminal;
    this._qrCode = qrCode;
    this._status = status;

  }

  String get name => _name;
  set name(String name) => _name = name;
  bool get fixedAmount => _fixedAmount;
  set fixedAmount(bool fixedAmount) => _fixedAmount = fixedAmount;
  Null get category => _category;
  set category(Null category) => _category = category;
  String get storeId => _storeId;
  set storeId(String storeId) => _storeId = storeId;
  String get externalStoreId => _externalStoreId;
  set externalStoreId(String externalStoreId) =>
      _externalStoreId = externalStoreId;
  String get externalId => _externalId;
  set externalId(String externalId) => _externalId = externalId;
  String get idTerminal => _idTerminal;
  set idTerminal(String idTerminal) => _idTerminal = idTerminal;
  String get qrCode => _qrCode;
  set qrCode(String qrCode) => _qrCode = qrCode;
  String get status => _status;
  set status(String qrCode) => _status = status;

  MercadopagoTerminal.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _fixedAmount = json['fixed_amount'];
    _category = json['category'];
    _storeId = json['store_id'];
    _externalStoreId = json['external_store_id'];  
    _externalId = json['external_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['fixed_amount'] = this._fixedAmount;
    data['category'] = this._category;
    data['store_id'] = this._storeId;
    data['external_store_id'] = this._externalStoreId;
    data['external_id'] = this._externalId;
    return data;
  }
   Future<List<String>> mercadopagoTerminalPost(
     String accessToken 
   ) async {
    List<String> stringList = [];
    var dio = Dio();
    print('Json Terminal');
    print(this.toJson());
    print(accessToken);
    try {
      Response response = await dio.post(
        "https://api.mercadopago.com/pos?access_token=APP_USR-$accessToken",
        data: this.toJson());

      print(response.data['id'].toString());
      print(response.data['qr']['image'].toString());
      idTerminal = response.data['id'].toString();
      qrCode = response.data['qr']['image'].toString();
      stringList.add(idTerminal);
      stringList.add(qrCode);
      print(response.statusCode.toString());
      print(stringList);
      return stringList;
     } catch (erro) {
       print(erro);
       return stringList;  
    }
  }

  Future<MercadopagoTerminal>getMercadopagoTerminalGet() async {
    var dio = Dio();
    try {
      Response response = await dio.get("https://api.mercadopago.com/pos?access_token=APP_USR-4733894957635786-012219-c728662aedf49205559022d6199344e4-260362652");
      print(response);
      idTerminal = response.data['results'][0]['id'];
      print(idTerminal);
      print(response.data['results'][0]['qr']['image']);
      qrCode = response.data['results'][0]['qr']['image'].toString();
      print(qrCode);
      
      } catch (erro) {
      print('retorno de erro:');
      print(erro.response.data);
      return null;  
      } 
   }
}