import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_a_note_project/settings/setting_data_handler.dart';


class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  var pomodoroSetting;
  var restTimeSetting;
  var longRestTimeSetting;
  var termOfRestingTimeSetting;

  @override
  Widget build(BuildContext context) {

    final settings = Provider.of<SettingDataHandler>(context);
    pomodoroSetting = settings.pomodoroSetting;
    restTimeSetting = settings.restTimeSetting;
    longRestTimeSetting = settings.longRestTimeSetting;
    termOfRestingTimeSetting = settings.termOfRestingTimeSetting;

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
          _settingMinute(pomodoroSetting),
          _settingMinute(restTimeSetting),
          _settingMinute(longRestTimeSetting),
          _settingTerm(termOfRestingTimeSetting)
        ],
      ),
    );
  }
  Widget _settingMinute(Setting setting){
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
              child: Text(value.toString() + " 분"),
            );
            },
          ).toList(),
          onChanged: (value) {
            setState(() {
              setting.selectedValue = value;
            });
          },
        ),
      ),
    );
  }
  Widget _settingTerm(Setting setting){
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
              child: Text(value.toString() + " 번"),
            );
          },
          ).toList(),
          onChanged: (value) {
            setState(() {
              setting.selectedValue = value;
            });
          },
        ),
      ),
    );
  }
}
