import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:take_a_note_project/enum.dart';
import 'package:take_a_note_project/siedbar/menu_item.dart';

List<MenuItem> menuItems = [
  MenuItem(MenuType.pomodoro, icon: Icon(Icons.timer, color: Colors.cyan, size: 30), title: Text("Pomodoro Timer", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 26, color: Colors.white))),
  MenuItem(MenuType.calendar, icon: Icon(Icons.date_range, color: Colors.cyan, size: 30), title: Text("Calendar", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 26, color: Colors.white))),
  MenuItem(MenuType.todoList, icon: Icon(Icons.assignment_turned_in, color: Colors.cyan, size: 30), title: Text("Todo List", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 26, color: Colors.white))),
  MenuItem(MenuType.settings, icon: Icon(Icons.settings, color: Colors.cyan, size: 30), title: Text("Settings", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 26, color: Colors.white))),
];