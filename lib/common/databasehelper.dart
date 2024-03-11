import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "MyROllCall.db";
  static final _databaseVersion = 1;

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE UserData (
            'SuperId' INTEGER NOT NULL,
            'UserName' TEXT NULL,
            'EmailId' TEXT NOT NULL,
            'RegistrationId' INTEGER NOT NULL,
            'AppType' TEXT NULL,
            'DeviceId' TEXT NULL,
            'Badge' TEXT NULL       
          )
          ''');
    await db.execute('''
          CREATE TABLE PassCode (
            'Id' INTEGER PRIMARY KEY,    
            'Password' TEXT NOT NULL
          )
          ''');

    // await db.execute('''
    //   CREATE TABLE Swipes (
    //         'Id' INTEGER PRIMARY KEY,
    //         'SuperId' INTEGER NOT NULL,
    //         'RegistrationId' INTEGER NOT NULL,
    //         'CardId' TEXT NOT NULL,
    //         'PunchDateTime' DateTime NOT NULL,
    //         'IsPushed' INTEGER NOT NULL DEFAULT 0
    //       )
    //       ''');

    // await db.execute('''
    //   CREATE TABLE UserData(
    //     'Id' INTEGER PRIMARY KEY,
    //     'SuperId' INTEGER NOT NULL,
    //     'OrgName' TEXT NULL,
    //     'RoleId' INTEGER NULL,
    //     'UserName' TEXT NULL,
    //     'EmailId' TEXT NULL,
    //     'RegistrationId' INTEGER NOT NULL,
    //     'AppType' TEXT NULL,
    //     'DeviceSDK' TEXT NULL
    //   )
    // ''');
  }

  Future<void> deleteDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    final response = await deleteDatabase(path);
    return response;
  }
  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    final result = await db.insert(table, row);
    return result;
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(String table, Map<String, dynamic> row, String where,
      List<dynamic> whereArgs) async {
    Database db = await instance.database;
    return await db.update(table, row, where: where, whereArgs: whereArgs);
  }

  Future<int> updateRaw(String query) async {
    Database db = await instance.database;
    final rowsaffected = await db.rawUpdate(query);
    return rowsaffected;
  }

  Future<List<Map<String, dynamic>>> queryRows(
      String table, String where, List<dynamic> whereArgs) async {
    Database db = await instance.database;
    return db.query(table, where: where, whereArgs: whereArgs);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> queryRowCount(String table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(
      String table, String where, List<dynamic> whereArgs) async {
    Database db = await instance.database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<int> deleteAll(String table) async {
    try {
      Database db = await instance.database;
      return await db.rawDelete("DELETE FROM $table");
    } on DatabaseException catch (e) {
      print(e);
      return 0;
    }
  }

  Future<int> deleteRaw(String query) async {
    try {
      Database db = await instance.database;
      return await db.rawDelete(query);
    } on DatabaseException catch (e) {
      print(e);
      return 0;
    }
  }
}
