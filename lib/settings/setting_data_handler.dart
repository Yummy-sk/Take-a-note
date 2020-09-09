import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingDataHandler extends ChangeNotifier {

  var pomodoroSetting = Setting("Pomodoro Setting", 15, [ 15, 30, 60, 90, 120]);
  var restTimeSetting = Setting("Rest Time Setting", 5, [ 5, 10, 15, 20, 25]);
  var longRestTimeSetting = Setting("Long Rest Time Setting", 10, [ 10, 15, 20, 25, 30]);
  var termOfRestingTimeSetting = Setting("Term of Resting Time Setting", 3, [ 3, 4, 5, 6, 7]);

}

class Setting {
  String settingType;
  int selectedValue;
  List settingValues;
  Setting(String settingType, int selectedValue, List settingValues){
    this.settingType = settingType;
    this.selectedValue = selectedValue;
    this.settingValues = settingValues;
  }
}