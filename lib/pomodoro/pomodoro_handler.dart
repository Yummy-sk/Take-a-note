import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:take_a_note_project/pomodoro/pomodoro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_a_note_project/pomodoro/show_bottom_sheet/show_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PomodoroHandler with ChangeNotifier {
  Timer timer;
  DateTime start;
  String startTime;
  String endTime;
  int count = 0;
  int elapsedTime = 0;
  int checkRestTime = 0;
  bool isPlaying = false;
  bool isDone = false;
  Pomodoro pomodoro;
  BuildContext context;
  SharedPreferences prefs;
  static final DateTime checkTime = DateTime.now();
  static final DateFormat formatter = DateFormat('MM월 dd일 H시 m분');
  final String formatted = formatter.format(checkTime);

  PomodoroHandler(BuildContext context){
    this.context = context;
  }

  resetTimer() {
    elapsedTime = 0;
    timer.cancel();
    endTime = formatter.format(new DateTime.now());
    isPlaying = false;
    isRestTime == false ? bottomSheet(context, startTime, endTime) : null;
    notifyListeners();
  }


  startTimer(time) {
    isDone = false;
    startTime = formatted;
    start = new DateTime.now();
    start = elapsedTime > 0
        ? start.subtract(Duration(seconds: elapsedTime))
        : start;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (time > elapsedTime) {
        elapsedTime = DateTime.now().difference(start).inSeconds;
        print(isPlaying);
      } else {

        resetTimer();
        ++count;
      }
      notifyListeners();
    });
  }

  changeStatus(bool status, int time) {
    isPlaying = status;
    if (isPlaying) {
      startTimer(time);
    } else {
      timer.cancel();
    }
    notifyListeners();
  }

}