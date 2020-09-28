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

  dropTable() async{
    return await _repository.deleteOptionTable();
  }
}