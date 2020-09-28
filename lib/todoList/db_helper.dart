//import 'dart:io';
//import 'package:path/path.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:take_a_note_project/todoList/todo_list_model.dart';
//
//class DBHelper {
//  DBHelper._();
//  static final DBHelper _db = DBHelper._();
//  factory DBHelper() => _db;
//
//  static Database _database;
//
//  Future<Database> get database async {
//    if(_database != null) return _database;
//
//    _database = await initDB();
//    return _database;
//  }
//
//  final String TableName = 'TodoListDb';
//
//  initDB() async {
//    Directory directory = await getApplicationDocumentsDirectory();
//    String path = join(directory.path, 'TodoListDatabase');
//
//    return await openDatabase(
//      path,
//      version: 1,
//      onCreate: (db, version) async {
//        await db.execute('''
//            CREATE TABLE $TableName(
//            dateTime INTEGER PRIMARY KEY,
//            todo TEXT,
//            isDone INTEGER
//            )
//          ''');
//      },
//    );
//  }
//
//  createTodo(TodoListModel todoListModel) async {
//    final db  = await database;
//    var res = await db.rawInsert('INSERT INTO $TableName values(?, ?, ?)',
//        [todoListModel.dateTime, todoListModel.todo, todoListModel.isDone]);
//    return res;
//  }
//
//  getTodo(DateTime dateTime) async {
//    int storedDateTime = dateTime.millisecondsSinceEpoch;
//    final db = await database;
//    var res = await db.rawQuery('SELECT * FROM $TableName WHERE dateTime = ?', [storedDateTime]);
//    return res.isNotEmpty ? TodoListModel(res.first['dateTime'], res.first['todo']) : Null;
//  }
//
//  Future <List<TodoListModel>> getAllTodos() async {
//    final db = await database;
//    var res = await db.rawQuery('SELECT * FROM $TableName');
//    List<TodoListModel> list = res.isNotEmpty ? res.map((c) => TodoListModel(c['dateTime'], c['todo'])).toList() : [];
//    return list;
//  }
//
//  deleteTodo(int index) async {
//    final db = await database;
//    var res = db.rawDelete('DELETE FROM $TableName WHERE index = ?', [index]);
//    return res;
//  }
//
//  deleteAllTodos() async {
//    final db = await database;
//    db.rawDelete('DELETE FROM $TableName');
//  }
//
//  updateTodo(TodoListModel todoListModel) async {
//    final db = await database;
//    var res = db.rawUpdate('UPDATE $TableName SET todo = ? WHERE = ?', [todoListModel.todo, todoListModel.dateTime]);
//    return res;
//  }
//
//}