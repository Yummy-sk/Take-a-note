import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection{
  saveDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'todoList_db');
    var database =
    await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);
    return database;
  }

  _onCreatingDatabase(Database database, int version) async {
    // Create table todos
    await database.execute(
        "CREATE TABLE todo(key INTEGER PRIMARY KEY AUTOINCREMENT, dateTime INTEGER, todo TEXT, isDone INTEGER)");
  }
}