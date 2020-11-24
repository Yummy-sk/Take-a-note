import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingDataHandler extends ChangeNotifier {
  SharedPreferences prefs;

  Map<String, int> selectedTimes = {
    "Pomodoro Setting": 25,
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
    return selectedTimes['Pomodoro Setting'] == 5 ? selectedTimes['Pomodoro Setting'] : selectedTimes['Pomodoro Setting'] * 60;
  }

  getRestTime(){
    return selectedTimes['Rest Time Setting'] == 3 ? selectedTimes['Rest Time Setting'] : selectedTimes['Rest Time Setting'] * 60;
  }

  getLongRestTime(){
    return selectedTimes['Long Rest Time Setting'] * 60;
  }

  getTermOfRestingTimeSetting(){
    return selectedTimes['Term of Resting Time Setting'];
  }

  Future<void> _changedTime(String key, int value) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

}