import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:take_a_note_project/pomodoro/pomodoro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_a_note_project/pomodoro/show_bottom_sheet/show_bottom_sheet.dart';
import 'package:take_a_note_project/todoList/todoList_handler.dart';


class PomodoroHandler with ChangeNotifier {
  Timer timer;
  DateTime start;
  String startTime;
  String endTime;
  int count = 0;
  int elapsedTime = 0;
  int checkRestTime = 0;
  bool isPlaying = false;
  bool isRestTime = false;
  bool isLongRestTime = false;
  Pomodoro pomodoro;
  BuildContext context;
  static final DateTime checkTime = DateTime.now();
  static final DateFormat formatter = DateFormat('H시 m분');
  final String formatted = formatter.format(checkTime);

  PomodoroHandler(BuildContext context){
    this.context = context;
  }

  HandleOnPressed(time) {
    if (isPlaying) {
      StartTimer(time);
    } else {
      timer.cancel();
    }
    notifyListeners();
  }

  ResetTimer() {
    elapsedTime = 0;
    timer.cancel();
    endTime = formatter.format(new DateTime.now());
    print(endTime);
    isPlaying = false;
    bottomSheet(context, startTime, endTime);
    notifyListeners();
  }

  formatTime(int now, int duration) {
    String first = ((duration - now) ~/ 60).toString();
    int seconds = ((duration - now) % 60);
    String latter = (seconds < 10 ? "0" : "") + seconds.toString();
    return first + ":" + latter;
  }

  StartTimer(time) {
    startTime = formatter.format(new DateTime.now());
    start = new DateTime.now();
    print(startTime);
    start = elapsedTime > 0
        ? start.subtract(Duration(seconds: elapsedTime))
        : start;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (time > elapsedTime) {
        elapsedTime =   DateTime.now().difference(start).inSeconds;
      } else {
        AfterPomodoroDone();
        ResetTimer();
      }
      notifyListeners();
    });
  }

  AfterPomodoroDone(){
    print(count);
    ++count;
    isRestTime ? isRestTime = false : isRestTime = true;
  }

  ChangePomodoroStatus(bool status, int time) {
    isPlaying = status;
    HandleOnPressed(time);
    notifyListeners();
  }
}
