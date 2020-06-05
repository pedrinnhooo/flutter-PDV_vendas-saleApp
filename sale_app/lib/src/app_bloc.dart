import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:intercom_flutter/intercom_flutter.dart';

class AppBloc extends BlocBase {
  Dao dao;
  Locale _locale;
  BehaviorSubject _localeController;
  Stream get localeOut => _localeController.stream;

  AppBloc(){
    _localeController = BehaviorSubject.seeded(_locale);
    dao = Dao();
    init();
  }

  init() async {
    await dao.init();
  }

  setLocale({Locale locale}){
    this._locale = locale;
    _localeController.add(locale);
  }

  // getLojaFromDevice() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   int idLoja = sharedPreferences.getInt("idLoja");
  //   PessoaDAO pessoaDAO = PessoaDAO(AppModule.to.getBloc<HasuraBloc>(), loja);
  //   loja = await pessoaDAO.getById(idLoja);
  // }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    _localeController.close();
    super.dispose();
  }
}
