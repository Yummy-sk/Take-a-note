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
  var pomodoroSetting = Setting("Pomodoro Setting", [ 15, 30, 60, 90, 120], " 분");
  var restTimeSetting = Setting("Rest Time Setting", [ 5, 10, 15, 20, 25], " 분");
  var longRestTimeSetting = Setting("Long Rest Time Setting",  [ 10, 15, 20, 25, 30], " 분");
  var termOfRestingTimeSetting = Setting("Term of Resting Time Setting", [ 3, 4, 5, 6, 7], " 번");
  SettingDataHandler settingDataHandler;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    settingDataHandler = Provider.of<SettingDataHandler>(context, listen: false);
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
          _settingTime(pomodoroSetting),
          _settingTime(restTimeSetting),
          _settingTime(longRestTimeSetting),
          _settingTime(termOfRestingTimeSetting),
        ],
      ),
    );
  }
  Widget _settingTime(Setting setting){

    return ListTile(
      title: Text(setting.settingType, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: DropdownButtonHideUnderline(
        child: DropdownButton(
          elevation: 10,
          autofocus: true,
          isExpanded: true,
          value: settingDataHandler.selectedTimes[setting.settingType],
          items: setting.settingValues.map((value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value.toString() + setting.end),
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
}

class Setting {
  String settingType;
  List settingValues;
  String end;
  Setting(String settingType,  List settingValues, String end){
    this.settingType = settingType;
    this.settingValues = settingValues;
    this.end = end;
  }

}