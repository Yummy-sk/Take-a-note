import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:take_a_note_project/pomodoro/pomodoro.dart';
import 'package:take_a_note_project/pomodoro/show_bottom_sheet/show_bottom_sheet.dart';

class PomodoroHandler with ChangeNotifier {
  Timer timer;
  DateTime start;
  String startTime;
  String endTime;
  int count = 0;
  int elapsedTime = 0;
  bool isPlaying = false;
  bool isDone = false;
  int pomodoroTime;
  int time;
  Pomodoro pomodoro;
  BuildContext context;
  static final DateTime checkTime = DateTime.now();
  static final DateFormat formatter = DateFormat('MM월 dd일 H시 m분');
  final String formatted = formatter.format(checkTime);

  PomodoroHandler(BuildContext context){
    this.context = context;
  }

  HandleOnPressed() {
    if (isPlaying) {
      StartTimer();
    } else {
      timer.cancel();
    }
    notifyListeners();
  }

  ResetTimer() {
    time = pomodoroTime * 60;
    elapsedTime = 0;
    timer.cancel();
    endTime = formatter.format(new DateTime.now());
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

  StartTimer() {
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
        ResetTimer();
        ++count;
      }
      notifyListeners();
    });
  }

  ChangePomodoroStatus(bool status) {
    isPlaying = status;
    HandleOnPressed();
    notifyListeners();
  }

}