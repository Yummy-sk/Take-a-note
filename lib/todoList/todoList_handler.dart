import 'package:flutter/material.dart';
import 'package:take_a_note_project/model/todo_model.dart';
import 'package:take_a_note_project/services/todo_service.dart';

class TodoListHandler with ChangeNotifier{
  Map<DateTime, List<dynamic>> events;
  List<dynamic> selectedEvents;
  TodoModel todoModel;
  List<TodoModel> doneTodo;
  List<TodoModel> onProgressTodo;
  TodoService _todoService = new TodoService();

  TodoListHandler(){
    this.selectedEvents = [];
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

  deleteTodo(int key){
    _todoService.deleteTodo(key);
  }

  relodeTodos(DateTime dateTime){
    getOnProgress(dateTime);
    getDone(dateTime);
  }


  addTodoList(DateTime dateTime, TextEditingController eventController) async {
    if(eventController.text.isEmpty) { return; }
    else {
      todoModel = TodoModel();
      if (events[dateTime] != null) {
        todoModel.dateTime = dateTime.millisecondsSinceEpoch;
        print(dateTime);
        todoModel.todo = eventController.text;
        var result = await TodoService().saveTodo(todoModel);
        print(result);
      } else {
        todoModel.dateTime = dateTime.millisecondsSinceEpoch;
        todoModel.todo = eventController.text;
        var result = await TodoService().saveTodo(todoModel);
        print(result);
      }
      eventController.clear();
      getOnProgress(dateTime);
      notifyListeners();
    }
  }

}