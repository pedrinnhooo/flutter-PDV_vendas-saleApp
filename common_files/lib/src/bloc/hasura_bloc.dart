import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HasuraBloc extends BlocBase {
  static String url = "http://ec2-54-233-64-9.sa-east-1.compute.amazonaws.com:8080/v1/graphql";  
  HasuraConnect hasuraConnect;

  HasuraBloc() {
    initBloc();
  }

  initBloc() async {
    if (hasuraConnect != null) {
      await hasuraConnect.dispose();
    }
    hasuraConnect = HasuraConnect(url, token: (boolean) async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      //sharedPreferences or other storage logic
       return "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiaWRfZ3J1cG8iOjEsIm5hbWUiOiJHdXN0YXZvIiwiYWRtaW4iOnRydWUsImh0dHBzOi8vaGFzdXJhLmlvL2p3dC9jbGFpbXMiOnsieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ1c2VyIl0sIngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6InVzZXIiLCJ4LWhhc3VyYS11c2VyLWlkIjoiMSIsIngtaGFzdXJhLW9yZy1pZCI6IjEifX0.VS7R31gh34yLFy2Twz4Vr2fYkdAS79YyzG7sZucDlUU";
      // print(sharedPreferences.getString('token').split("|")[1]);
      // return "Bearer "+ sharedPreferences.getString('token').split("|")[1];
    });    
  }

  @override
  void dispose() {
    hasuraConnect.dispose();
    super.dispose();
  }
}