class IEntity {}

abstract class IEntityDAO {
  String get tableName;



  Map<String, dynamic> toMap() {}

  IEntity fromMap(Map<String, dynamic> map) {}

  Future<IEntity> insert() async {}

  Future<IEntity> getById(int id) async {}

  Future<List> getAll({bool preLoad = false}) async {}
}
