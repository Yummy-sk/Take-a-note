import 'package:take_a_note_project/model/todo_model.dart';
import 'package:take_a_note_project/repositories/repository.dart';

class TodoService{
  Repository _repository;

  TodoService() {
    _repository = Repository();
  }

  saveTodo(TodoModel todoModel) async{
    return await _repository.insertData('todo', todoModel.todoModelMap());
  }

  readTodo() async {
    return await _repository.readData('todo');
  }

  readTodoOnProgress(table, dateTime, isDone) async {
    return await _repository.readDataOnProgress(table, dateTime, isDone);
  }

  readTodoDone(table, dateTime, isDone) async {
    return await _repository.readDataOnProgress(table, dateTime, isDone);
  }

  updateTodo(TodoModel todoModel) async {
    return await _repository.updateData('todo', todoModel.todoModelMap());
  }

  deleteTodo(key) async{
    return await _repository.deleteData('todo', key);
  }

  dropTable() async{
    return await _repository.deleteOptionTable();
  }
}