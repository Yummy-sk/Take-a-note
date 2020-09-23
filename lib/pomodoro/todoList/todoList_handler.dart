import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoListHandler with ChangeNotifier{
  SharedPreferences prefs;
  Map<DateTime, List<dynamic>> events;
  TextEditingController eventController;
  List<dynamic> selectedEvents;

  TodoListHandler(){
    this.eventController = TextEditingController();
    this.selectedEvents = [];
    initPrefs();
  }

  Map<String, dynamic> toMap() {
    return {
      'todo': eventController.text,
      'isDone': false
    };
  }

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

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    events = Map<DateTime, List<dynamic>>.from(decodedMap(json.decode(prefs.getString("events") ?? "{}")));
    notifyListeners();
  }

  List<dynamic> loadList(DateTime dateTime) {
    return events[dateTime];
  }

  addTodoList(DateTime dateTime) {

    if(eventController.text.isEmpty) { return; }
    else {

      if (events[dateTime] != null) {
        events[dateTime].add(toMap());
      } else {
        events[dateTime] = [toMap()];
      }

      eventController.clear();
      save();
      eventController.clear();
      notifyListeners();
    }
  }

  changeList(int index) {
    selectedEvents[index]["todo"] = eventController.text;
    save();
  }

  void save() {
    prefs.setString("events", json.encode(encodedMap(events)));
  }
}