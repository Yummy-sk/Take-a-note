class TodoModel {
  int key;
  int dateTime;
  String todo;
  int isDone;
  
  TodoModel() {
    this.isDone = 0;
  }

  todoModelMap() {
    var mapping =  Map<String, dynamic>();
    mapping['key'] = this.key;
    mapping['dateTime'] = this.dateTime;
    mapping['todo'] = this.todo;
    mapping['isDone'] = this.isDone;

    return mapping;
  }
}