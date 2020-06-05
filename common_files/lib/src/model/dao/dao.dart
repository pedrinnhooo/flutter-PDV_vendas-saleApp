import 'dart:io';

import 'package:common_files/src/model/entities/interfaces.dart';
import 'package:common_files/src/utils/scriptsUpdate.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:version/version.dart';

import '../../../common_files.dart';

class Dao { 
  Database database;
  Batch batch;
  
  /*
    Versions
    1-OnConfigure
    2-OnCreate/OnUpdate/OnDowngrade
    3-OnOpen
  */

  init() async{
    await openLocalDatabase();
    if(await database.getVersion() == 2){
      await createDatabase();
      await updateDatabase();
    } else {
      await updateDatabase();
    }
  }

  Future openLocalDatabase() async {
    String path = await getDatabasesPath();
    if(await File("$path/$databaseName").exists()){
      database = await openDatabase(join(await getDatabasesPath(), databaseName), version: 1);
    } else {
      database = await openDatabase(join(await getDatabasesPath(), databaseName), version: 2);
    }
  }

  Future createDatabase() async {
    batch = database.batch();
    if(Version.parse(scriptsToExecute[0].keys.single.toString()) == Version.parse('1.0.0')){
      scriptsToExecute[0].values.forEach((scriptList) {
        scriptList.forEach((script) {
          batch.execute(script);
        });
      });
      await batch.commit();
      print("======= SCRIPT INICIAL EXECUTADO COM SUCESSO =======");
      database.setVersion(1);
    }
  }

  Future updateDatabase() async {
    database.setVersion(2);
    batch = database.batch();
    Version versaoAtual = Version.parse(await getClientVersion());
    scriptsToExecute.forEach((element) async {
      if(versaoAtual < Version.parse(element.keys.single)){
        print("VERSAO CLIENTE $versaoAtual");
        print("ATUALIZAÇÃO: ${element.keys.single}");
        element.values.forEach((scriptList) {
          scriptList.forEach((script) {
            batch.execute(script);
          });
        });
      }
    });
    await batch.commit();
    print("======= SCRIPT DE ATUALIZACAO EXECUTADO COM SUCESSO =======");
    database.setVersion(1);
  }

  getClientVersion() async {
    try {
      var map = await getRawQuery('SELECT id_versao FROM configuracao_app');
      return map.first['id_versao'].toString();
    } catch (e) {
    }
  }

  Future<int> insert(IEntityDAO entity) async {
    final database = openDatabase(join(await getDatabasesPath(), databaseName), version: 1);
    final Database db = await database;

    return await db.insert(
      entity.tableName,
      entity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Database> getDatabase() async {
    final database =
        openDatabase(join(await getDatabasesPath(), databaseName), version: 1);
    final Database db = await database;
    return db;
  }

  Future<int> delete(IEntityDAO entity, int id) async {
    final database = openDatabase(join(await getDatabasesPath(), databaseName), version: 1);
    final Database db = await database;
      
    if (id > 0) {
      return await db.delete(
            entity.tableName,
            where: 'id = ?', 
            whereArgs: [id]);    
    } else {
      return await db.delete(
        entity.tableName
      );
    }  
  }

  Future<IEntity> getById(IEntityDAO entity, int id, {bool temCampoEhDeletado = false}) async {
    String where = temCampoEhDeletado ? "id = ? and ehdeletado = 0 " : "id = ?";
    final database = openDatabase(join(await getDatabasesPath(), databaseName), version: 1);
    final Database db = await database;
    List<Map<String, dynamic>> maps =
        await db.query(entity.tableName, where: where, whereArgs: [id]);
    Map<String, dynamic> mapRead = maps.first;
    return entity.fromMap(mapRead);
  }

  Future<int> update(IEntityDAO entity, int id) async {
    final database = openDatabase(join(await getDatabasesPath(), databaseName), version: 1);
    final Database db = await database;

    int result = await db.update(entity.tableName, entity.toMap(),
        where: 'id = ?', whereArgs: [id]);
    print(result);
    return result;
  }

  Future<List> getList(IEntityDAO entity, String where, List<dynamic> args, {String orderBy}) async {
    final database = openDatabase(join(await getDatabasesPath(), databaseName), version: 1);
    final Database db = await database;

    //var result = await db.query(this.entity.tableName);
    List<Map<String, dynamic>> maps;
    if (where != "") {
      maps = await db.query(entity.tableName, where: where, whereArgs: args, orderBy: orderBy);
    } else {
      maps = await db.query(entity.tableName);
    }

    return maps;

    /*List<Entity> entities = List<Entity>();
    for (var i = 0; i < maps.length; i++){
      Map<String, dynamic> mapRead = maps[i];
      var newEntity = entity.newInstance();
      newEntity = entity.fromMap(mapRead);
      print(newEntity.toString());
      entities.insert(i,newEntity);
    }
    print(entities);*/

    /*if(result.isNotEmpty){
      var model = result.map((modelMap) => this.entity.fromMap(modelMap)).toList();
      return model;
    }*/
    //return entities;
  }


  Future<List<Map>> getRawQuery(String query) async {
    final database = openDatabase(join(await getDatabasesPath(), databaseName), version: 1);
    final Database db = await database;
    List<Map> maps;

    maps = await db.rawQuery(query);

    return maps;
  }  

  void printer(IEntityDAO entity) {
    print("MAOE:" + entity.toMap().toString());
    //getList(entity);
  }
}
