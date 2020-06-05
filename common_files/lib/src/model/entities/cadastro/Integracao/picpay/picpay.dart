
import 'package:dio/dio.dart';

class Picpay {
  String _referenceId;
  String _callbackUrl;
  String _returnUrl;
  String _picpayQrCode;
  double _value;
  DateTime _expiresAt;
  Buyer _buyer;

  Picpay(
      {String referenceId,
      String callbackUrl,
      String returnUrl,
      String picpayQrCode,
      double value,
      DateTime expiresAt,
      Buyer buyer}) {
    this._referenceId = referenceId;
    this._callbackUrl = callbackUrl;
    this._returnUrl = returnUrl;
    this._picpayQrCode = picpayQrCode;
    this._value = value;
    this._expiresAt = expiresAt == null ? DateTime.now() : expiresAt;
    this._buyer = buyer;
  }

  String get referenceId => _referenceId;
  set referenceId(String referenceId) => _referenceId = referenceId;
  String get callbackUrl => _callbackUrl;
  set callbackUrl(String callbackUrl) => _callbackUrl = callbackUrl;
  String get returnUrl => _returnUrl;
  set returnUrl(String returnUrl) => _returnUrl = returnUrl;
  String get picpayQrCode => _picpayQrCode;
  set picpayQrCode(String picpayQrCode) => _picpayQrCode = picpayQrCode;
  double get value => _value;
  set value(double value) => _value = value;
  DateTime get expiresAt => _expiresAt;
  set expiresAt(DateTime expiresAt) => _expiresAt = expiresAt;
  Buyer get buyer => _buyer;
  set buyer(Buyer buyer) => _buyer = buyer;

  Picpay.fromJson(Map<String, dynamic> json) {
    _referenceId = json['referenceId'];
    _callbackUrl = json['callbackUrl'];
    _returnUrl = json['returnUrl'];
    _value = json['value'];
    _expiresAt = json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null;
    _buyer = json['buyer'] != null ? new Buyer.fromJson(json['buyer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['referenceId'] = this._referenceId;
    data['callbackUrl'] = this._callbackUrl;
    data['returnUrl'] = this._returnUrl;
    data['value'] = this._value;
    data['expiresAt'] = this._expiresAt.toString();
    if (this._buyer != null) {
      data['buyer'] = this._buyer.toJson();
    }
    return data;
  }

  Future<Picpay>  picpayOrdemPagamentoPost(String accessToken) async {
    var dio = Dio();
    dio.options.headers = {'x-picpay-token': '$accessToken'};
    print(dio.options.headers);
    print('Json Ordem');
    print(this.toJson());
    try {
      Response response = await dio.post(
        "https://appws.picpay.com/ecommerce/public/payments?x-picpay-token=$accessToken",
        data: this.toJson());
        picpayQrCode = response.data['qrcode']['base64'].toString();
      print(picpayQrCode);  
      print(response.statusCode);  
    } catch (erro) {
       print(erro.response.data);
      return null;  
    }
  }
}

class Buyer {
  String _firstName;
  String _lastName;
  String _document;
  String _email;
  String _phone;

  Buyer({String firstName,String lastName,String document,String email,String phone}) {
    this._firstName = firstName;
    this._lastName = lastName;
    this._document = document;
    this._email = email;
    this._phone = phone;
  }

  String get firstName => _firstName;
  set firstName(String firstName) => _firstName = firstName;
  String get lastName => _lastName;
  set lastName(String lastName) => _lastName = lastName;
  String get document => _document;
  set document(String document) => _document = document;
  String get email => _email;
  set email(String email) => _email = email;
  String get phone => _phone;
  set phone(String phone) => _phone = phone;

  Buyer.fromJson(Map<String, dynamic> json) {
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _document = json['document'];
    _email = json['email'];
    _phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this._firstName;
    data['lastName'] = this._lastName;
    data['document'] = this._document;
    data['email'] = this._email;
    data['phone'] = this._phone;
    return data;
  }
}