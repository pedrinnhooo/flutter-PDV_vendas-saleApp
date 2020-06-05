import 'package:dio/dio.dart';

class MercadopagoLoja {
  String _name;
  BusinessHours _businessHours;
  Location _location;
  String _externalId;
  String _idLoja;

  MercadopagoLoja(
      {String name,
      BusinessHours businessHours,
      Location location,
      String externalId,
      String idLoja}) {
    this._name = name;
    this._businessHours = businessHours;
    this._location = location == null ? Location() : location;
    this._externalId = externalId;
    this._idLoja = idLoja;
  }

  String get name => _name;
  set name(String name) => _name = name;
  BusinessHours get businessHours => _businessHours;
  set businessHours(BusinessHours businessHours) => _businessHours = businessHours;
  Location get location => _location;
  set location(Location location) => _location = location;
  String get externalId => _externalId;
  set externalId(String externalId) => _externalId = externalId;
  String get idLoja => _idLoja;
  set idLoja(String idLoja) => _idLoja = idLoja;

  MercadopagoLoja.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    // _businessHours = json['business_hours'] != null
    //     ? new BusinessHours.fromJson(json['business_hours'])
    //     : null;
    _location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    _externalId = json['external_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    // if (this._businessHours != null) {
    //   data['business_hours'] = this._businessHours.toJson();
    // }
    if (this._location != null) {
      data['location'] = this._location.toJson();
    }
    data['external_id'] = this._externalId;
    return data;
  }

  static fromMap(data) {}

  Future<String> postmercadopago (
    String accessToken, String userId
  ) async {
    var dio = Dio();
    print('Json Mercadopago');
    print(this.toJson());
    try {
      Response response = await dio.post(
      "https://api.mercadopago.com/users/$userId/stores?access_token=APP_USR-$accessToken",
      data: this.toJson());
      print(response.data['marketplace']);
      print('ID loja: ' +response.data['id'].toString());
      idLoja = response.data['id'].toString();
      print(response.statusCode.toString()); 
      return idLoja;
    } catch (erro) {
      print('retorno de erro:');
      print(erro.response.data);
      return null;  
    }
  }

  Future<String> getMercadopago (
    String accessToken, String userId
  ) async {
    var dio = Dio();
    try {
      Response response = await dio.get("https://api.mercadopago.com/users/$userId/stores/search?access_token=APP_USR-$accessToken");
      print(response);
      idLoja = response.data['results'][0]['id'].toString();
      return idLoja;
      } catch (erro) {
      print('retorno de erro:');
      print(erro);
      return null;  
      } 
   }
}

class BusinessHours {
  List<Monday> _monday;
  List<Tuesday> _tuesday;
  List<Wednesday> _wednesday;
  List<Thursday> _thursday;
  List<Friday> _friday;
  List<Saturday> _saturday;
  List<Sunday> _sunday;

  BusinessHours(
      {List<Monday> monday,
      List<Tuesday> tuesday,
      List<Wednesday> wednesday,
      List<Thursday> thursday,
      List<Friday> friday,
      List<Saturday> saturday,
      List<Sunday> sunday}) {
    this._monday = monday;
    this._tuesday = tuesday;
    this._wednesday = wednesday;
    this._thursday = thursday;
    this._friday = friday;
    this._saturday = saturday;
    this._sunday = sunday;
  }

  List<Monday> get monday => _monday;
  set monday(List<Monday> monday) => _monday = monday;
  List<Tuesday> get tuesday => _tuesday;
  set tuesday(List<Tuesday> tuesday) => _tuesday = tuesday;
  List<Wednesday> get wednesday => _wednesday;
  set wednesday(List<Wednesday> wednesday) => _wednesday = wednesday;
  List<Thursday> get thursday => _thursday;
  set thursday(List<Thursday> thursday) => _thursday = thursday;
  List<Friday> get friday => _friday;
  set friday(List<Friday> friday) => _friday = friday;
  List<Saturday> get saturday => _saturday;
  set saturday(List<Saturday> saturday) => _saturday = saturday;
  List<Sunday> get sunday => _sunday;
  set sunday(List<Sunday> sunday) => _sunday = sunday;

  BusinessHours.fromJson(Map<String, dynamic> json) {
    if (json['monday'] != null) {
      _monday = new List<Monday>();
      json['monday'].forEach((v) {
        _monday.add(new Monday.fromJson(v));
      });
    }
    if (json['tuesday'] != null) {
      _tuesday = new List<Tuesday>();
      json['tuesday'].forEach((v) {
        _tuesday.add(new Tuesday.fromJson(v));
      });
    }
    if (json['Wednesday'] != null) {
      _wednesday = new List<Wednesday>();
      json['Wednesday'].forEach((v) {
        _wednesday.add(new Wednesday.fromJson(v));
      });
    }
    if (json['Thursday'] != null) {
      _thursday = new List<Thursday>();
      json['Thursday'].forEach((v) {
        _thursday.add(new Thursday.fromJson(v));
      });
    }
    if (json['Friday'] != null) {
      _friday = new List<Friday>();
      json['Friday'].forEach((v) {
        _friday.add(new Friday.fromJson(v));
      });
    }
    if (json['Saturday'] != null) {
      _saturday = new List<Saturday>();
      json['Saturday'].forEach((v) {
        _saturday.add(new Saturday.fromJson(v));
      });
    }
    if (json['Sunday'] != null) {
      _sunday = new List<Sunday>();
      json['Sunday'].forEach((v) {
        _sunday.add(new Sunday.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._monday != null) {
      data['monday'] = this._monday.map((v) => v.toJson()).toList();
    }
    if (this._tuesday != null) {
      data['tuesday'] = this._tuesday.map((v) => v.toJson()).toList();
    }
    if (this._wednesday != null) {
      data['Wednesday'] = this._wednesday.map((v) => v.toJson()).toList();
    }
    if (this._thursday != null) {
      data['Thursday'] = this._thursday.map((v) => v.toJson()).toList();
    }
    if (this._friday != null) {
      data['Friday'] = this._friday.map((v) => v.toJson()).toList();
    }
    if (this._saturday != null) {
      data['Saturday'] = this._saturday.map((v) => v.toJson()).toList();
    }
    if (this._sunday != null) {
      data['Sunday'] = this._sunday.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Monday {
  String _open;
  String _close;

  Monday({String open, String close}) {
    this._open = open;
    this._close = close;
  }

  String get open => _open;
  set open(String open) => _open = open;
  String get close => _close;
  set close(String close) => _close = close;

  Monday.fromJson(Map<String, dynamic> json) {
    _open = json['open'];
    _close = json['close'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['open'] = this._open;
    data['close'] = this._close;
    return data;
  }
}

class Tuesday {
  String _open;
  String _close;

  Tuesday({String open, String close}) {
    this._open = open;
    this._close = close;
  }

  String get open => _open;
  set open(String open) => _open = open;
  String get close => _close;
  set close(String close) => _close = close;

  Tuesday.fromJson(Map<String, dynamic> json) {
    _open = json['open'];
    _close = json['close'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['open'] = this._open;
    data['close'] = this._close;
    return data;
  }
}

class Wednesday {
  String _open;
  String _close;

  Wednesday({String open, String close}) {
    this._open = open;
    this._close = close;
  }

  String get open => _open;
  set open(String open) => _open = open;
  String get close => _close;
  set close(String close) => _close = close;

  Wednesday.fromJson(Map<String, dynamic> json) {
    _open = json['open'];
    _close = json['close'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['open'] = this._open;
    data['close'] = this._close;
    return data;
  }
}
class Thursday {
  String _open;
  String _close;

  Thursday({String open, String close}) {
    this._open = open;
    this._close = close;
  }

  String get open => _open;
  set open(String open) => _open = open;
  String get close => _close;
  set close(String close) => _close = close;

  Thursday.fromJson(Map<String, dynamic> json) {
    _open = json['open'];
    _close = json['close'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['open'] = this._open;
    data['close'] = this._close;
    return data;
  }
}

class Friday {
  String _open;
  String _close;

  Friday({String open, String close}) {
    this._open = open;
    this._close = close;
  }

  String get open => _open;
  set open(String open) => _open = open;
  String get close => _close;
  set close(String close) => _close = close;

  Friday.fromJson(Map<String, dynamic> json) {
    _open = json['open'];
    _close = json['close'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['open'] = this._open;
    data['close'] = this._close;
    return data;
  }
}

class Saturday {
  String _open;
  String _close;

  Saturday({String open, String close}) {
    this._open = open;
    this._close = close;
  }

  String get open => _open;
  set open(String open) => _open = open;
  String get close => _close;
  set close(String close) => _close = close;

  Saturday.fromJson(Map<String, dynamic> json) {
    _open = json['open'];
    _close = json['close'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['open'] = this._open;
    data['close'] = this._close;
    return data;
  }
}

class Sunday {
  String _open;
  String _close;

  Sunday({String open, String close}) {
    this._open = open;
    this._close = close;
  }

  String get open => _open;
  set open(String open) => _open = open;
  String get close => _close;
  set close(String close) => _close = close;

  Sunday.fromJson(Map<String, dynamic> json) {
    _open = json['open'];
    _close = json['close'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['open'] = this._open;
    data['close'] = this._close;
    return data;
  }
}
class Location {
  String _streetNumber;
  String _streetName;
  String _cityName;
  String _stateName;
  double _latitude;
  double _longitude;
  String _reference;

  Location(
      {String streetNumber,
      String streetName,
      String cityName,
      String stateName,
      double latitude,
      double longitude,
      String reference}) {
    this._streetNumber = streetNumber;
    this._streetName = streetName;
    this._cityName = cityName;
    this._stateName = stateName;
    this._latitude = latitude;
    this._longitude = longitude;
    this._reference = reference;
  }

  String get streetNumber => _streetNumber;
  set streetNumber(String streetNumber) => _streetNumber = streetNumber;
  String get streetName => _streetName;
  set streetName(String streetName) => _streetName = streetName;
  String get cityName => _cityName;
  set cityName(String cityName) => _cityName = cityName;
  String get stateName => _stateName;
  set stateName(String stateName) => _stateName = stateName;
  double get latitude => _latitude;
  set latitude(double latitude) => _latitude = latitude;
  double get longitude => _longitude;
  set longitude(double longitude) => _longitude = longitude;
  String get reference => _reference;
  set reference(String reference) => _reference = reference;

  Location.fromJson(Map<String, dynamic> json) {
    _streetNumber = json['street_number'];
    _streetName = json['street_name'];
    _cityName = json['city_name'];
    _stateName = json['state_name'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _reference = json['reference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street_number'] = this._streetNumber;
    data['street_name'] = this._streetName;
    data['city_name'] = this._cityName;
    data['state_name'] = this._stateName;
    data['latitude'] = this._latitude;
    data['longitude'] = this._longitude;
    data['reference'] = this._reference;
    return data;
  }
  

}
