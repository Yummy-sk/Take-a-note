class Category{
  int id;
  DateTime dateTime;
  String todoList;
  bool isDone;

  categoryMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['dateTime'] = dateTime;
    mapping['todoList'] = todoList;
    mapping['isdone'] = isDone;
    return mapping;
  }
}