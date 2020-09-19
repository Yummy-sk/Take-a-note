import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_a_note_project/pomodoro/pomodoro_handler.dart';
import 'package:take_a_note_project/settings/setting_data_handler.dart';

class Pomodoro extends StatelessWidget {

SharedPreferences prefs;
SettingDataHandler settingDataHandler;
PomodoroHandler pomodoroHandler;
var screenWidth;


Future<int> _initPref() async {
  prefs = await SharedPreferences.getInstance();
  var timeData = prefs.get('timeData');
  if (timeData != null) {
    settingDataHandler.selectedTimes["Pomodoro Setting"] = timeData;
  }

  pomodoroHandler.pomodoroTime = settingDataHandler.selectedTimes["Pomodoro Setting"];
  pomodoroHandler.time = pomodoroHandler.pomodoroTime * 60;

  return 0;
}

@override
Widget build(BuildContext context) {
  screenWidth = MediaQuery.of(context).size.width;
  settingDataHandler = Provider.of<SettingDataHandler>(context);
  pomodoroHandler = Provider.of<PomodoroHandler>(context);

  return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black54,
        ),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _ClockView(),
            bottomBar()
        ],
      )
    )
  );
}

Widget bottomBar(){
  return Container(
    width: screenWidth,
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 40),
            child: Text(pomodoroHandler.formatTime(pomodoroHandler.elapsedTime, pomodoroHandler.time), style: TextStyle(color: Colors.black54, fontSize: 30, fontWeight: FontWeight.bold),)
        ),
        ClockButtons()
      ],
    ),
  );
}

Widget _ClockView() {
  return FutureBuilder(
    future: _initPref(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData == false) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(fontSize: 15),
            )
        );
      }

      double percent = pomodoroHandler.elapsedTime / pomodoroHandler.time;
      return Padding(
        padding: EdgeInsets.only(top: 100),
        child: CircularPercentIndicator(
            circularStrokeCap: CircularStrokeCap.round,
            percent: percent,
            animation: true,
            animateFromLastPercent: true,
            radius: 300.0,
            lineWidth: 5.0,
            progressColor: Colors.deepOrange,
            center: Text(
              pomodoroHandler.formatTime(pomodoroHandler.elapsedTime, pomodoroHandler.time),
              style: TextStyle(
                  color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.w300),
            )
        ),
      );
    },
  );
}

  Widget ClockButtons() {
    return Row(
      children: <Widget>[
        StopButton(),
        pomodoroHandler.isPlaying == true ?  PauseButton() : PlayButton(),
      ],
    );
  }

  Widget StopButton() {
    return IconButton(
      iconSize: 50,
      splashColor: Colors.white30,
      color: Colors.black54,
      icon: Icon(Icons.stop),
      onPressed: () => {
        pomodoroHandler.ResetTimer(),
      },
    );
  }

  Widget PlayButton(){
    return IconButton(
      iconSize: 50,
      splashColor: Colors.white30,
      color: Colors.black54,
      icon: Icon(Icons.play_arrow),
      onPressed: () => {
        pomodoroHandler.ChangePomodoroStatus(true)
      },
    );
  }

  Widget PauseButton() {
    return IconButton(
      iconSize: 50,
      splashColor: Colors.white30,
      color: Colors.black54,
      icon: Icon(Icons.pause),
      onPressed: () => {
        pomodoroHandler.ChangePomodoroStatus(false)
      },
    );
  }

}
