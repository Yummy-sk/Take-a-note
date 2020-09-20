import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SettingDataHandler extends ChangeNotifier {

  SharedPreferences prefs;

  Map<String, int> selectedTimes = {
    "Pomodoro Setting": 15,
    "Rest Time Setting": 5,
    "Long Rest Time Setting": 15,
    "Term of Resting Time Setting": 5
  };

  SettingDataHandler(){
    _initPref();
  }

  Future<int> _initPref() async {
    prefs = await SharedPreferences.getInstance();

    selectedTimes.forEach((key, value) {
      selectedTimes[key] = prefs.getInt(key);
    });

    return 0;
  }

  setTime(String key, int changedValue) {
    selectedTimes.update(key, (value) => changedValue);
    _changedTime(key, changedValue);
    notifyListeners();
  }

  getPomodoroTime(){
    return selectedTimes['Pomodoro Setting'] * 60;
  }

  Future<void> _changedTime(String key, int value) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }
}