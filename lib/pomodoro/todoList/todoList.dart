import 'dart:convert';
import 'Dart:math';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './dateBaseHelper.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {

  CalendarController _controller;
  Map<DateTime, dynamic> _events; // DateTime과 동적 타입을 저장하는 맵
  TextEditingController _eventController; // 문자열 조작을 위한 컨트롤러
  List<dynamic> _selectedEvents;

  @override
  void initState() async{
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    _events = await todos();
    _selectedEvents = [];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                _TableCalendar(),
               ... _selectedEvents.map((todoItem) => Card(
                 elevation: 5.0,
                 child:  ListTile(
                   contentPadding: EdgeInsets.only(left: 30),
                   title: Text(todoItem.todo),
                 ),
               )),
              ],
            )
          )
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showAddDialog,
      ),
    );
  }

  Widget _TableCalendar(){
    return TableCalendar( // Calendar Style
      events: _events,
      calendarStyle: CalendarStyle( // Calendar Style
        todayColor: Colors.orange,
      ),
      calendarController: _controller,
      onDaySelected: (date, events) {
        setState(() {
          _selectedEvents = events;
        });
      },
    );
  }

  _showAddDialog(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            controller: _eventController,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Save"),
              onPressed: (){
                if(_eventController.text.isEmpty) return;
                setState(() {
                  TodoItem todoItem = TodoItem(
                    id: 0,
                    todo: _eventController.text,
                    isDone: false,
                    time: _controller.selectedDay,
                  );

                  if (_events[_controller.selectedDay] != null){
                    _events[_controller.selectedDay].add(todoItem);
                  }else {
                    _events[_controller.selectedDay] = [todoItem];
                  }
                  _eventController.clear();
                  insertTodo(todoItem);
                  _eventController.clear();
                  Navigator.pop(context);
                });
              },
            )
          ],
        )
    );
  }
}
