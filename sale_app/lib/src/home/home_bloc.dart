import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:intercom_flutter/intercom_flutter.dart';

class HomeBloc extends BlocBase {
  //dispose will be called automatically by closing its streams
  AppGlobalBloc _appGlobalBloc = AppModule.to.getBloc<AppGlobalBloc>();

  HomeBloc(){
    init();
  }

  init() async {
    //Intercom.registerUnidentifiedUser();    
    // Intercom.registerIdentifiedUser(
    //   userId: _appGlobalBloc.usuario.id.toString(), 
    // );    
  }

  @override
  void dispose() {
    super.dispose();
  }
}
