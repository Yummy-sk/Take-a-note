import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_a_note_project/model/todo_model.dart';
import 'package:take_a_note_project/services/todo_service.dart';

class TodoListHandler with ChangeNotifier{
  SharedPreferences prefs;
  Map<DateTime, List<dynamic>> events;
  List<dynamic> selectedEvents;
  TodoModel todoModel;
  List<TodoModel> doneTodo;
  List<TodoModel> onProgressTodo;
  TodoService _todoService = new TodoService();

  TodoListHandler(){
    this.selectedEvents = [];
    initPrefs();
    doneTodo = List<TodoModel>();
    onProgressTodo = List<TodoModel>();
  }

  getOnProgress(DateTime dateTime) async {
    onProgressTodo.clear();
    var todos = await _todoService.readTodoOnProgress('todo', dateTime.millisecondsSinceEpoch, 0);
    todos.forEach((todo){
      var todoModel = TodoModel();
      todoModel.key = todo['key'];
      todoModel.dateTime = todo['dateTime'];
      todoModel.todo = todo['todo'];
      todoModel.isDone = todo['isDone'];
      onProgressTodo.add(todoModel);
    });
    print(onProgressTodo.length);
    notifyListeners();
  }

  getDone(DateTime dateTime) async {
    doneTodo.clear();
    var todos = await _todoService.readTodoOnProgress('todo', dateTime.millisecondsSinceEpoch, 1);
    todos.forEach((todo){
      var todoModel = TodoModel();
      todoModel.key = todo['key'];
      todoModel.dateTime = todo['dateTime'];
      todoModel.todo = todo['todo'];
      todoModel.isDone = todo['isDone'];
      doneTodo.add(todoModel);
    });
    print(doneTodo.length);
    notifyListeners();
  }

  setTodo(TodoModel todoModel){
    _todoService.updateTodo(todoModel);
  }

  Map<String, dynamic> toMap(TextEditingController eventController) {
    return {
      'todo': eventController.text,
      'isDone': false
    };
  }

  Map<String, dynamic> encodedMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {newMap[key.toString()] = map[key];});
    return newMap;
  }

  Map<DateTime,  dynamic> decodedMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {newMap[DateTime.parse(key)] = map[key];});
    return newMap;
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    events = Map<DateTime, List<dynamic>>.from(decodedMap(json.decode(prefs.getString("events") ?? "{}")));
    notifyListeners();
  }

  List<dynamic> loadList(DateTime dateTime) {
    return events[dateTime];
  }

  addTodoList(DateTime dateTime, TextEditingController eventController) async {
    if(eventController.text.isEmpty) { return; }
    else {
      todoModel = TodoModel();
      if (events[dateTime] != null) {
        //await TodoService().dropTable();
        todoModel.dateTime = dateTime.millisecondsSinceEpoch;
        todoModel.todo = eventController.text;
        var result = await TodoService().saveTodo(todoModel);
        print(result);
        //events[dateTime].add(toMap(eventController));
      } else {
        todoModel.dateTime = dateTime.millisecondsSinceEpoch;
        todoModel.todo = eventController.text;
        var result = await TodoService().saveTodo(todoModel);
        print(result);
        //events[dateTime] = [toMap(eventController)];
      }

      eventController.clear();
      save();
      eventController.clear();
      getOnProgress(dateTime);
      notifyListeners();
    }
  }

  changeList(int index, TextEditingController eventController) {
    selectedEvents[index]["todo"] = eventController.text;
    save();
  }

  void save() {
    prefs.setString("events", json.encode(encodedMap(events)));
  }

  setIsDone(int index) {
    selectedEvents[index]["isDone"] == true
        ? selectedEvents[index]["isDone"] = false
        : selectedEvents[index]["isDone"] = true;
    save();
    notifyListeners();
  }

}