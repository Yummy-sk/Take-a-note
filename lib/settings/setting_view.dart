import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:take_a_note_project/settings/pomodoroTimeSetting.dart';
import 'package:take_a_note_project/settings/restTimeSetting.dart';
import 'package:take_a_note_project/settings/longRestTimeSetting.dart';
import 'package:take_a_note_project/settings/termOfRestingTime.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  var _pomodoro = PomodoroTimeSetting();
  var _restTime = RestTimeSetting();
  var _longRestTime = LongRestTimeSetting();
  var _termOfRestingTime = TermOfRestingTime();

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
          _settingTiles(_pomodoro.settingType, _pomodoro.selectedValue, _pomodoro.settingValues),
          _settingTiles(_restTime.settingType, _restTime.selectedValue, _restTime.settingValues),
          _settingTiles(_longRestTime.settingType, _longRestTime.selectedValue, _longRestTime.settingValues),
          _settingTiles(_termOfRestingTime.settingType, _termOfRestingTime.selectedValue, _termOfRestingTime.settingValues )
        ],
      ),
    );
  }
  Widget _settingTiles(String settingType, String selectedValue, List settingValues ){
    return ListTile(
      title: Text(settingType, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: DropdownButton(
        elevation: 10,
        autofocus: true,
        isExpanded: true,
        value: selectedValue,
        items: settingValues.map((value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
          },
        ).toList(),
        onChanged: (value) {
          setState(() {
            selectedValue = value;
            print(selectedValue);
          });
        },
      ),
    );
  }
}
