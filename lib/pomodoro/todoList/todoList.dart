import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:take_a_note_project/pomodoro/todoList/todoList_handler.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {

  CalendarController controller;
  TodoListHandler todoListHandler;

  @override
  void initState() {
    super.initState();
    controller = CalendarController();
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
      body: SafeArea(
        child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                _TableCalendar(),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: todoListHandler.selectedEvents.length,
                  itemBuilder: (context, index) {
                    return Card(
                        elevation: 5,
                        color: todoListHandler.selectedEvents[index]["isdone"] == true ? Colors.deepPurpleAccent : Colors.white,
                        child: ListTile(
                          leading: todoListHandler.selectedEvents[index]["isdone"]  == true
                              ? Icon(Icons.check_circle, color: Colors.white)
                              : Icon(Icons.radio_button_unchecked, color: Colors.blueAccent,),
                          title: todoListHandler.selectedEvents[index]["isdone"] == true
                              ? Text(todoListHandler.selectedEvents[index]["todo"], style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20, color: Colors.white),)
                              : Text(todoListHandler.selectedEvents[index]["todo"], style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),),
                          trailing: IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: (){

                            },
                          ),
                          onTap: () => {
                            setState((){
                              todoListHandler.selectedEvents[index]["isdone"] == true ? todoListHandler.selectedEvents[index]["isdone"] = false : todoListHandler.selectedEvents[index]["isdone"] = true;
                              todoListHandler.save();
                            })
                          },
                        )
                    );
                  },
                )
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
  Widget _TableCalendar(){
    return TableCalendar( // Calendar Style
      initialCalendarFormat: CalendarFormat.week,
      events: todoListHandler.events,
      calendarStyle: CalendarStyle(
        // Calendar Style
        todayColor: Colors.orange,
        selectedColor: Theme.of(context).primaryColor,
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
        });
      },
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, events) => Container(
          child: Text(date.day.toString(), style: TextStyle(color: Colors.white),),
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        todayDayBuilder:  (context, date, events) => Container(
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

  _showAddDialog(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("할 일을 추가합니다.", style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 24.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          content: TextField(
            controller: todoListHandler.eventController,
          ),
          actions: <Widget>[
            RaisedButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.lightBlue)
              ),
              child: Text("Save", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue),),
              onPressed: (){
                todoListHandler.addTodoList(controller.selectedDay);
                Navigator.pop(context);
              },
            )
          ],
        )
    );
  }

  changeList(int index){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("할 일을 수정합니다.", style: TextStyle(fontWeight: FontWeight.bold),),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        content: TextField(controller: todoListHandler.eventController),
        actions: <Widget>[
          RaisedButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.lightBlue)
              ),
              child: Text("Save", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue),),
            onPressed: (){
              changeList(index);
              Navigator.pop(context);
            }
            ),
          RaisedButton(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.deepOrangeAccent)
            ),
            child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent),),
            onPressed: (){
              Navigator.pop(context);
            },
          )
        ],
      )
    );
  }

  Widget _deleteColor(){
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.deepOrangeAccent, Colors.orange, Colors.orangeAccent, Colors.amberAccent, Colors.yellow, Colors.yellow]
          )
      ),
    );
  }

}


//todoListHandler.selectedEvents.removeAt(index);
//todoListHandler.save();
//
//changeList(index);