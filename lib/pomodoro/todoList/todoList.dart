import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {

  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events; // DateTime과 동적 타입을 저장하는 맵
  TextEditingController _eventController; // 문자열 조작을 위한 컨트롤러
  SharedPreferences prefs; // key-value 형태의 Data를 디스크에 저장
  List<dynamic> _selectedEvents;

  Map<String, dynamic> encodedMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {newMap[key.toString()] = map[key];});
    return newMap;
  }

  Map<DateTime,  dynamic> decodedMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {newMap[DateTime.parse(key)] = map[key];});
    return newMap;
  }

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    _selectedEvents = [];
    initPrefs();
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(decodedMap(json.decode(prefs.getString("events") ?? "{}")));
    });
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
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _selectedEvents.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onLongPress: (){
                        setState(() {
                          _changeList(index);
                        });
                      },
                      child: Card(
                        child: Dismissible(
                            key: Key(_selectedEvents[index]["todo"]),
                            onDismissed: (direction) {
                              setState(() {
                                _selectedEvents.removeAt(index);
                                prefs.setString("events", json.encode(encodedMap(_events)));
                              });
                            },
                            background: Container(color: Colors.red),
                            child: ListTile(title: Text(_selectedEvents[index]["todo"]),)),
                      ),
                    );
                  },
                )
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
      initialCalendarFormat: CalendarFormat.week,
      events: _events,
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
      calendarController: _controller,
      onDaySelected: (date, events) {
        setState(() {
          _selectedEvents = events;
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
          child: Text(date.day.toString(), style: TextStyle(color: Colors.white),),
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
            controller: _eventController,
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

                if(_eventController.text.isEmpty) return;

                setState(() {

                  Map<String, dynamic> toMap() {
                    return {
                      'todo': _eventController.text,
                      'isDone': false
                    };
                  }

                  if (_events[_controller.selectedDay] != null){
                    _events[_controller.selectedDay].add(toMap());
                  }else {
                    _events[_controller.selectedDay] = [toMap()];
                  }
                  _eventController.clear();
                  prefs.setString("events", json.encode(encodedMap(_events)));
                  _eventController.clear();
                  Navigator.pop(context);
                });
              },
            )
          ],
        )
    );
  }
  _changeList(int index){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("할 일을 수정합니다.", style: TextStyle(fontWeight: FontWeight.bold),),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        content: TextField(controller: _eventController),
        actions: <Widget>[
          RaisedButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.lightBlue)
              ),
              child: Text("Save", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue),),
            onPressed: (){
              setState(() {
                _selectedEvents[index]["todo"] = _eventController.text;
                prefs.setString("events", json.encode(encodedMap(_events)));
                Navigator.pop(context);
              });
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
}