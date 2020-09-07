import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:take_a_note_project/pomodoro/pomodoro.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  var pomodoroSetting = Setting("Pomodoro Setting", "15분", [ "15분", "30분", "60분", "90분", "120분" ]);
  var restTimeSetting = Setting("Rest Time Setting", "5분", [ "5분", "10분", "15분", "20분", "25분" ]);
  var longRestTimeSetting = Setting("Long Rest Time Setting", "10분", [ "10분", "15분", "20분", "25분", "30분" ]);
  var termOfRestingTimeSetting = Setting("Term of Resting Time Setting", "3번", [ "3번", "4번", "5번", "6번", "7번" ]);
  @override
  Widget build(BuildContext context) {
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
          _settingTiles(pomodoroSetting),
          _settingTiles(restTimeSetting),
          _settingTiles(longRestTimeSetting),
          _settingTiles(termOfRestingTimeSetting)
        ],
      ),
    );
  }
  Widget _settingTiles(Setting setting){
    return ListTile(
      title: Text(setting.settingType, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: DropdownButtonHideUnderline(
        child: DropdownButton(
          elevation: 10,
          autofocus: true,
          isExpanded: true,
          value: setting.selectedValue,
          items: setting.settingValues.map((value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
            },
          ).toList(),
          onChanged: (value) {
            setState(() {
              setting.selectedValue = value;
              print(setting.selectedValue);
              print(pomodoroSetting.selectedValue);
              print(restTimeSetting.selectedValue);
            });
          },
        ),
      ),
    );
  }
}

class Setting {
  String settingType;
  String selectedValue;
  List settingValues;
  Setting(String settingType, String selectedValue, List settingValues){
    this.settingType = settingType;
    this.selectedValue = selectedValue;
    this.settingValues = settingValues;
  }
}