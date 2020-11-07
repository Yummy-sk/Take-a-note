class TodoModel {
  int key;
  int dateTime;
  String todo;
  int isDone;
  String startTime;
  String endTime;
  
  TodoModel() {
    this.isDone = 0;
    this.startTime = ' ';
    this.endTime = ' ';
  }

  todoModelMap() {
    var mapping =  Map<String, dynamic>();
    mapping['key'] = this.key;
    mapping['dateTime'] = this.dateTime;
    mapping['todo'] = this.todo;
    mapping['isDone'] = this.isDone;
    mapping['startTime'] = this.startTime;
    mapping['endTime'] = this.endTime;

    return mapping;
  }
}