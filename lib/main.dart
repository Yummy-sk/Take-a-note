import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_a_note_project/enum.dart';
import 'package:take_a_note_project/pomodoro/pomodoro_handler.dart';
import 'package:take_a_note_project/settings/setting_data_handler.dart';
import 'package:take_a_note_project/siedbar/menu_item.dart';
import 'package:take_a_note_project/siedbar/sidebar_layout.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingDataHandler>(create: (context) => SettingDataHandler(),),
        ChangeNotifierProvider<MenuItem>(create: (context) => MenuItem(MenuType.pomodoro),),
        ChangeNotifierProvider<PomodoroHandler>(create: (context) => PomodoroHandler(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SideBarLayout(),
      ),
    );
  }
}

