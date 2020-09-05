import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:take_a_note_project/main.dart';

class TodoItem {
  int id;
  String todo;
  bool isDone;
  DateTime time;

  TodoItem({
    this.id,
    this.todo,
    this.isDone,
    this.time
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todo': todo,
      'isDone': isDone,
      'time': time
    };
  }
}

void main() async {
  database = openDatabase (
    // 데이터베이스 경로를 지정합니다. 참고: `path` 패키지의 `join` 함수를 사용하는 것이
    // 각 플랫폼 별로 경로가 제대로 생성됐는지 보장할 수 있는 가장 좋은 방법입니다.
    join(await getDatabasesPath(), 'todo_database.db'),
    // 데이터베이스가 처음 생성될 때, dog를 저장하기 위한 테이블을 생성합니다.
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE dogs(id INTEGER PRIMARY KEY, time TEXT, todo TEXT, isDone BOOLEAN)",
      );
    },
    // 버전을 설정하세요. onCreate 함수에서 수행되며 데이터베이스 업그레이드와 다운그레이드를
    // 수행하기 위한 경로를 제공합니다.
    version: 1,
  );

}

  Future<void> insertTodo(TodoItem todoItem) async {
    // 데이터베이스 reference를 얻습니다.
    final Database db = await database;

    // Dog를 올바른 테이블에 추가합니다. 동일한 dog가 두번 추가되는 경우를 처리하기 위해
    // `conflictAlgorithm`을 명시할 수 있습니다.
    //
    // 본 예제에서는, 이전 데이터를 갱신하도록 하겠습니다.
    await db.insert(
      'todos',
      todoItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<DateTime, dynamic>> todos() async {
    // 데이터베이스 reference를 얻습니다.
    final Database db = await database;

    // 모든 Dog를 얻기 위해 테이블에 질의합니다.
    final List<Map<String, dynamic>> items = await db.query('todos');
    Map<DateTime, dynamic> eventResult = {};
    // List<Map<String, dynamic>를 List<Dog>으로 변환합니다.
    items.forEach((item) {
      eventResult[item['time']] = TodoItem(
        id: item['id'],
        todo: item['todo'],
        isDone: item['isDone'],
        time: item['time'],
      );
    });
    return eventResult;
  }

  Future<void> updateTodo(TodoItem todoItem) async {
    // 데이터베이스 reference를 얻습니다.
    final db = await database;

    // 주어진 Dog를 수정합니다.
    await db.update(
      'todos',
      todoItem.toMap(),
      // Dog의 id가 일치하는 지 확인합니다.
      where: "id = ?",
      // Dog의 id를 whereArg로 넘겨 SQL injection을 방지합니다.
      whereArgs: [todoItem.id],
    );
  }

  Future<void> deleteTodos(int id) async {
    // 데이터베이스 reference를 얻습니다.
    final db = await database;

    // 데이터베이스에서 Dog를 삭제합니다.
    await db.delete(
      'todos',
      // 특정 dog를 제거하기 위해 `where` 절을 사용하세요
      where: "id = ?",
      // Dog의 id를 where의 인자로 넘겨 SQL injection을 방지합니다.
      whereArgs: [id],
    );
  }