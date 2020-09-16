import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_a_note_project/calender_view/month_table.dart';
import 'package:take_a_note_project/enum.dart';
import 'package:take_a_note_project/pomodoro/pomodoro.dart';
import 'package:take_a_note_project/pomodoro/todoList/todoList.dart';
import 'package:take_a_note_project/settings/setting_view.dart';
import 'package:take_a_note_project/siedbar/siedbar.dart';
import 'menu_item.dart';

class SideBarLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Consumer<MenuItem>(
            builder: (BuildContext context, MenuItem value, Widget child){
            if(value.menuType == MenuType.pomodoro) { return Pomodoro(); }
            else if (value.menuType == MenuType.calendar) { return MonthTable(); }
            else if (value.menuType == MenuType.todoList) { return TodoList(); }
            else if (value.menuType == MenuType.settings) { return SettingView(); }}),
          SideBar()
        ],
      ),
    );
  }
}