import 'package:postgres/postgres.dart';
import 'package:teste_postgres/teste_postgres.dart' as teste_postgres;

main(List<String> arguments) async {
  final String postgresUrl = "graphqldb.clb0ejaw4ykt.sa-east-1.rds.amazonaws.com";
  final String postgresUsername = "zumaadmin";
  final String postgresPassword = "newappzuma2211";
  final String postgresDatabase = "postgres";    
    
  var postgresConnection = PostgreSQLConnection(postgresUrl, 5432, 
    postgresDatabase, username: postgresUsername, password: postgresPassword);


  if (postgresConnection.isClosed) {
    print("Abre conexao");
    await postgresConnection.open();
  }  
  String sql = """
    select p.id, p.id_pessoa_grupo, p.razao_nome, p.password, ct.email
    from pessoa p 
    inner join contato ct on ct.id_pessoa = p.id
    where p.ehusuario = 1 and ct.email = @aValue 
  """; 
  // select p.id, p.id_pessoa_grupo, p.razao_nome, p.password
  // from pessoa p 
  // left join contato c on c.id_pessoa = p.id
  // where p.ehusuario = 1 and c.email = '${_login.usuario.contato[0].email}'
  print("Sql: "+sql);
  var result = await postgresConnection.query(sql, substitutionValues: {
    "aValue" : "gvnn360@live.com"
  });
  print(result.length.toString());
  if (result.length > 0) {
    print("result.first[0]: "+result.first[0].toString());
    print("result.first[1]: "+result.first[1].toString());
    print("result.first[2]: "+result.first[2].toString());
    print("result.first[3]: "+result.first[3].toString());
    print("result.first[4]: "+result.first[4].toString());
  }  
}
