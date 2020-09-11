import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_a_note_project/settings/setting_data_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  var pomodoroSetting = Setting("Pomodoro Setting", [ 15, 30, 60, 90, 120]);
  var restTimeSetting = Setting("Rest Time Setting", [ 5, 10, 15, 20, 25]);
  var longRestTimeSetting = Setting("Long Rest Time Setting",  [ 10, 15, 20, 25, 30]);
  var termOfRestingTimeSetting = Setting("Term of Resting Time Setting", [ 3, 4, 5, 6, 7]);
  SettingDataHandler settingDataHandler;
  SharedPreferences prefs;
  
  @override
  void initState() {
    super.initState();
    _initPref();
  }

  @override
  Widget build(BuildContext context) {
    final setting = Provider.of<SettingDataHandler>(context, listen: false);
    settingDataHandler = setting;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(left: 10, right: 10, top: 50, bottom: 50),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 4.0,
            child: _innerLatout()
          ),
        ),
      )
    );
  }

  Widget _innerLatout(){
    return Container(
      margin: EdgeInsets.only(left: 3, right: 3, top: 5, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _settingMinute(pomodoroSetting, settingDataHandler.selectedTimes["Pomodoro Setting"]),
          _settingMinute(restTimeSetting, settingDataHandler.selectedTimes["Rest Time Setting"]),
          _settingMinute(longRestTimeSetting, settingDataHandler.selectedTimes["Long Rest Time Setting"]),
          _settingTerm(termOfRestingTimeSetting, settingDataHandler.selectedTimes["Term of Resting Time Setting"])
        ],
      ),
    );
  }
  Widget _settingMinute(Setting setting, int selectedValue){
    return ListTile(
      title: Text(setting.settingType, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: DropdownButtonHideUnderline(
        child: DropdownButton(
          elevation: 10,
          autofocus: true,
          isExpanded: true,
          value: selectedValue,
          items: setting.settingValues.map((value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value.toString() + " 분"),
            );
            },
          ).toList(),
          onChanged: (value) {
            setState(() {
              settingDataHandler.setTime(setting.settingType, value);
              _resetPref();
            });
          },
        ),
      ),
    );
  }
  Widget _settingTerm(Setting setting, int selectedValue){
    return ListTile(
      title: Text(setting.settingType, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: DropdownButtonHideUnderline(
        child: DropdownButton(
          elevation: 10,
          autofocus: true,
          isExpanded: true,
          value: selectedValue,
          items: setting.settingValues.map((value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value.toString() + " 번"),
            );
          },
          ).toList(),
          onChanged: (value) {
            setState(() {
              settingDataHandler.setTime(setting.settingType, value);
            });
          },
        ),
      ),
    );
  }

  Future<dynamic> _initPref() async {
    prefs = await SharedPreferences.getInstance();
    final timeData = prefs.get('timeData');
    return timeData;
  }

  Future<void> _resetPref() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timeData', settingDataHandler.selectedTimes["Pomodoro Setting"]);
  }

}

class Setting {
  String settingType;
  List settingValues;
  Setting(String settingType,  List settingValues){
    this.settingType = settingType;
    this.settingValues = settingValues;
  }
}