import 'package:sqflite/sqflite.dart';
import 'package:take_a_note_project/repositories/database_connection.dart';

class Repository {
  DatabaseConnection _databaseConnection;

  Repository() {
    _databaseConnection = DatabaseConnection();
  }

  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await _databaseConnection.saveDatabase();
    return _database;
  }

  // Inserting data to Table
  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  readData(table) async{
    var connection = await database;
    return await connection.query(table);
  }

  deleteOptionTable() async {
    final db = await database;
    db.rawDelete("DROP TABLE IF EXISTS todo");
  }


}