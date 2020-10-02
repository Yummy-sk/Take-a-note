import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:take_a_note_project/model/todo_model.dart';
import 'package:take_a_note_project/todoList/header.dart';
import 'package:take_a_note_project/todoList/todoList_handler.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}class _TodoListState extends State<TodoList> {
  Header header;
  TodoModel todoModel;
  CalendarController controller;
  TodoListHandler todoListHandler;
  static TextEditingController eventController;


  @override
  void initState() {
    super.initState();
    header = Header();
    controller = CalendarController();
    eventController = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    todoListHandler = Provider.of<TodoListHandler>(context);
    return Scaffold(
      backgroundColor: Color(0xffFEE8D6),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _TableCalendar(),
                  SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                        children: [
                          _OnProgressBox(),
                          _DoneBox()
                        ]
                    ),
                  ),
                ],
              )
          )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: _showAddDialog,
      ),
    );
  }

  Widget _OnProgressBox() {
    return Stack(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            color: Color(0xffFFF8DC),
            child: Column(
              children: <Widget>[
                SizedBox(height: 50,),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: todoListHandler.onProgressTodo.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: todoCard(
                            context, todoListHandler.onProgressTodo, index),
                        onTap: () {
                          todoListHandler.onProgressTodo[index].isDone = 1;
                          todoListHandler.setTodo(
                              todoListHandler.onProgressTodo[index]);
                          todoListHandler.relodeTodos(controller.selectedDay);
                        },
                      );
                    }
                ),
                SizedBox(height: 20,)
              ],
            ),
          ),
          Header.getCardHeader(
              context: context, text: "TO DO", customColor: Color(0xffca3e47)),
        ]
    );
  }

  Widget _DoneBox() {
    return Stack(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            color: Colors.grey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 50,),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: todoListHandler.doneTodo.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: todoCard(
                            context, todoListHandler.doneTodo, index),
                        onTap: () {
                          todoListHandler.doneTodo[index].isDone = 0;
                          todoListHandler.setTodo(todoListHandler.doneTodo[index]);
                          todoListHandler.relodeTodos(controller.selectedDay);
                        },
                      );
                    }
                ),
                SizedBox(height: 20,)
              ],
            ),
          ),
          Header.getCardHeader(
              context: context, text: "DONE", customColor: Color(0xff34465d)),
        ]
    );
  }

  Widget _TableCalendar() {
    return TableCalendar( // Calendar Style
      initialCalendarFormat: CalendarFormat.week,
      events: todoListHandler.events,
      calendarStyle: CalendarStyle(
        // Calendar Style
        todayColor: Colors.orange,
        selectedColor: Theme
            .of(context)
            .primaryColor,
        todayStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          color: Colors.white,
        ),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonDecoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(20.0)
        ),
        formatButtonTextStyle: TextStyle(color: Colors.white),
      ),
      calendarController: controller,
      onDaySelected: (date, events) {
        setState(() {
          todoListHandler.selectedEvents = events;
          todoListHandler.relodeTodos(controller.selectedDay);
        });
      },
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, events) =>
            Container(
              child: Text(
                date.day.toString(), style: TextStyle(color: Colors.white),),
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .primaryColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
        todayDayBuilder: (context, date, events) =>
            Container(
              child: Text(
                date.day.toString(), style: TextStyle(color: Colors.white),),
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10.0)
              ),
            ),
      ),
    );
  }

  _showAddDialog() {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text(
                  "할 일을 추가합니다.", style: TextStyle(fontWeight: FontWeight.bold)),
              elevation: 24.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))
              ),
              content: TextField(
                controller: eventController,
              ),
              actions: <Widget>[
                RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.lightBlue)
                  ),
                  child: Text("Save", style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.lightBlue),),
                  onPressed: () {
                    todoListHandler.addTodoList(
                        controller.selectedDay, eventController);
                    Navigator.pop(context);
                  },
                )
              ],
            )
    );
  }

  changeList(todoItem) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text(
                "할 일을 수정합니다.", style: TextStyle(fontWeight: FontWeight.bold),),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))
              ),
              content: TextField(controller: eventController),
              actions: <Widget>[
                RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.lightBlue)
                    ),
                    child: Text("Save", style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.lightBlue),),
                    onPressed: () {
                      todoItem.todo = eventController.text;
                      todoListHandler.setTodo(todoItem);
                      todoListHandler.relodeTodos(controller.selectedDay);
                      eventController.clear();
                      Navigator.pop(context);
                    }
                ),
                RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.deepOrangeAccent)
                  ),
                  child: Text("Cancel", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent),),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            )
    );
  }

  deleteList(todoItem) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text(
                "정말 삭제하시겠어요?", style: TextStyle(fontWeight: FontWeight.bold),),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))
              ),
              actions: <Widget>[
                RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.lightBlue)
                    ),
                    child: Text("Yes", style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.lightBlue),),
                    onPressed: () {
                      todoListHandler.deleteTodo(todoItem.key);
                      todoListHandler.relodeTodos(controller.selectedDay);
                      Navigator.pop(context);
                    }
                ),
                RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.deepOrangeAccent)
                  ),
                  child: Text("Cancel", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent),),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            )
    );
  }

  Widget todoCard(BuildContext context, todoItem, int index) {
    Icon leading;
    Color color;
    Color titleColor;
    int isDone = todoItem[index].isDone;
    String toDo = todoItem[index].todo;

    if (isDone == 1) {
      color = Colors.white38;
      leading = Icon(Icons.check_circle, color: Colors.white);
      titleColor = Colors.white;
    } else {
      color = Color(0xffEEE8CD);
      leading = Icon(Icons.radio_button_unchecked, color: Colors.black38,);
      titleColor = Colors.black;
    }

    return Card(
        elevation: 5,
        color: color,
        child: ListTile(
          leading: leading,
          title: Text(toDo, style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 20, color: titleColor)),
          trailing: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              settingBox(context, todoItem[index]);
            },
          ),
        )
    );
  }

  Widget updateTodo(BuildContext context, todoItem) {
    return ListTile(
      leading: Icon(Icons.edit),
      title: Text("To Do 수정"),
      onTap: () {
        Navigator.pop(context);
        changeList(todoItem);
      },
    );
  }

  Widget deleteTodo(BuildContext context, todoItem) {
    return ListTile(
      leading: Icon(Icons.delete_forever),
      title: Text("To Do 삭제"),
      onTap: () {
        Navigator.pop(context);
        deleteList(todoItem);
      },
    );
  }

  settingBox(BuildContext context, todoItem) {
    showBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              color: Color(0xFF737373),
              height: 115,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .canvasColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(10),
                      topRight: const Radius.circular(10),
                    )),
                child: Column(
                  children: [
                    updateTodo(context, todoItem),
                    deleteTodo(context, todoItem)
                  ],
                ),
              ),
          );
        }
    );
  }
}
