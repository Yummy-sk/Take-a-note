import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingDataHandler extends ChangeNotifier {


  Map<String, dynamic> selectedTimes = {
    "Pomodoro Setting": 15,
    "Rest Time Setting": 5,
    "Long Rest Time Setting": 15,
    "Term of Resting Time Setting": 5
  };

  setTime(String typeOfSetting, int changeValue) {
    selectedTimes.update(typeOfSetting, (value) => changeValue);
    notifyListeners();
  }
}