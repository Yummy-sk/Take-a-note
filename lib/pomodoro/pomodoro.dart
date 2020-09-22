import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_a_note_project/pomodoro/pomodoro_handler.dart';
import 'package:take_a_note_project/settings/setting_data_handler.dart';

class Pomodoro extends StatelessWidget {

SharedPreferences prefs;
SettingDataHandler setting;
PomodoroHandler pomodoroHandler;
var screenWidth;

@override
Widget build(BuildContext context) {
  screenWidth = MediaQuery.of(context).size.width;
  setting = Provider.of<SettingDataHandler>(context);
  pomodoroHandler = Provider.of<PomodoroHandler>(context);

  return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: pomodoroHandler.isRestTime == true ? Colors.indigoAccent : Colors.black54,
        ),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _ClockView(),
            bottomBar(),
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
            child: Text(
              pomodoroHandler.formatTime(
                  pomodoroHandler.elapsedTime,
                  CheckPomodoroTime()
              ),
              style: TextStyle(color: Colors.black54, fontSize: 30, fontWeight: FontWeight.bold),)
        ),
        ClockButtons(),
      ],
    ),
  );
}

Widget _ClockView() {
  double percent = pomodoroHandler.elapsedTime / CheckPomodoroTime();
  return Padding(
    padding: EdgeInsets.only(top: 100),
    child: CircularPercentIndicator(
        circularStrokeCap: CircularStrokeCap.round,
        percent: percent,
        animation: true,
        animateFromLastPercent: true,
        radius: 300.0,
        lineWidth: 5.0,
        progressColor: pomodoroHandler.isRestTime == true ? Colors.cyanAccent :Colors.deepOrange,
        center: Text(
          pomodoroHandler.formatTime(pomodoroHandler.elapsedTime, CheckPomodoroTime()),
          style: TextStyle(
              color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.w300),
        )
    ),
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
        pomodoroHandler.ChangePomodoroStatus(true, CheckPomodoroTime())
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
        pomodoroHandler.ChangePomodoroStatus(false, CheckPomodoroTime())
      },
    );
  }

  int CheckPomodoroTime(){
    return pomodoroHandler.isRestTime ? RestTime() : setting.getPomodoroTime();
  }

  int RestTime(){
    return pomodoroHandler.count % setting.getTermOfRestingTimeSetting() == 0 ? setting.getLongRestTime() : setting.getRestTime();
  }

}
