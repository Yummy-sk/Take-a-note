import 'package:flutter/foundation.dart';
import 'package:take_a_note_project/pomodoro/todoList/repository.dart';
import 'package:take_a_note_project/pomodoro/todoList/category.dart';

class CategoryService {
  Repository _repository;
  CategoryService() {
    _repository = Repository();
  }
  saveCategory(category) async{
    return await _repository.insertData('categories', category.categoryMap());
  }
}