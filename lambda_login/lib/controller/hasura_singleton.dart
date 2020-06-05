library hasuraSingleton;

import '../packages/hasura_connect-0.1.2/lib/hasura_connect.dart';

final HasuraSingleton hasuraSingleton = new HasuraSingleton._private();

class HasuraSingleton {
  //String token;
  String url = "http://ec2-54-233-64-9.sa-east-1.compute.amazonaws.com:8080/v1/graphql";
  HasuraConnect hasuraConnect;
  HasuraSingleton._private(){}

  getHasuraConnect({bool admin=false, String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiaWRfZ3J1cG8iOjEsIm5hbWUiOiJHdXN0YXZvIiwiYWRtaW4iOnRydWUsImh0dHBzOi8vaGFzdXJhLmlvL2p3dC9jbGFpbXMiOnsieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ1c2VyIl0sIngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6InVzZXIiLCJ4LWhhc3VyYS11c2VyLWlkIjoiMSIsIngtaGFzdXJhLW9yZy1pZCI6IjEifX0.VS7R31gh34yLFy2Twz4Vr2fYkdAS79YyzG7sZucDlUU"}) {
    var header = {"":""};
    if (admin) {
      header = {"x-hasura-admin-secret":"admclick2211"};
    }
    hasuraConnect = HasuraConnect(url, headers: header, token: () async {
      return "Bearer " + token;
    });
  }

  // static HasuraSingleton _instance;
  // static String url = "http://ec2-54-233-64-9.sa-east-1.compute.amazonaws.com:8080/v1/graphql";
  // factory HasuraSingleton({String token = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiaWRfZ3J1cG8iOjEsIm5hbWUiOiJHdXN0YXZvIiwiYWRtaW4iOnRydWUsImh0dHBzOi8vaGFzdXJhLmlvL2p3dC9jbGFpbXMiOnsieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ1c2VyIl0sIngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6InVzZXIiLCJ4LWhhc3VyYS11c2VyLWlkIjoiMSIsIngtaGFzdXJhLW9yZy1pZCI6IjEifX0.VS7R31gh34yLFy2Twz4Vr2fYkdAS79YyzG7sZucDlUU"}) {
  //   _instance ??= HasuraSingleton._internalConstructor(token);
  //   return _instance;
  // }
  // HasuraSingleton._internalConstructor(this.token);
  // HasuraConnect hasuraConnect = HasuraConnect(url, token: () async {
  //    return token;
  // });

  // String token;
}