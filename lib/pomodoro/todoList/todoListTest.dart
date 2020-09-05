import 'dart:convert';
import 'Dart:math';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoListTest extends StatefulWidget {
  @override
  _TodoListTestState createState() => _TodoListTestState();
}

class _TodoListTestState extends State<TodoListTest> {

  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events; // DateTime과 동적 타입을 저장하는 맵
  TextEditingController _eventController; // 문자열 조작을 위한 컨트롤러
  SharedPreferences prefs; // key-value 형태의 Data를 디스크에 저장
  List<dynamic> _selectedEvents;

  int index = 0;
  Random random = new Random();
  List colors = [Colors.red, Colors.green, Colors.yellow, Colors.orange, Colors.tealAccent, Colors.green, Colors.indigo];

  Color changeIndex(){
    setState(() { () =>
    index = random.nextInt(colors.length);
    });
    return colors[index];
  }

// 타입은 key(String), value(dynamic) 패러미터는 ( key(DateTime), value(dynamic)인 Map)
  Map<String, dynamic> encodedMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {}; // 타입은 key(String), value(dynamic)인 newMap인 변수
    map.forEach((key, value) {newMap[key.toString()] = map[key];}); // 맵에  dateTime과 dynamic 값을 넣고, newMap에 key = DateTime을 String으로 변환한 값, map에 그냥 dateTime을 저장한다.
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
    _events = {};
    _selectedEvents = [];
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(decodedMap(json.decode(prefs.getString("events") ?? {})));
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
                  ... _selectedEvents.map((event) => Card(
                    elevation: 5.0,
                    child:  ListTile(
                      contentPadding: EdgeInsets.only(left: 30),
                      title: Text(event),
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
                  if (_events[_controller.selectedDay] != null){
                    _events[_controller.selectedDay].add(_eventController.text);
                  }else {
                    _events[_controller.selectedDay] = [_eventController.text];
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
}
