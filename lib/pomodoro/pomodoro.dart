import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:take_a_note_project/pomodoro/pomodoro_handler.dart';
import 'package:take_a_note_project/settings/setting_data_handler.dart';

class Pomodoro extends StatelessWidget {

  double screenWidth;
  PomodoroHandler pomo;
  SettingDataHandler setting;
  int elapsedTime;
  int pomoTime;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    pomo = Provider.of(context);
    setting = Provider.of(context);
    
    elapsedTime = pomo.elapsedTime;
    pomoTime = setting.getTime('Pomodoro Setting');

    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.black54,
          ),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _clockView(),
              bottomBar(),
          ],
        )
      )
    );
  }

  String formatTime(int now, int duration) {
    String first = ((duration - now) ~/ 60).toString();
    int seconds = ((duration - now) % 60);
    String latter = (seconds < 10 ? "0" : "") + seconds.toString();
    return first + ":" + latter;
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
                formatTime(elapsedTime, pomoTime),
                style: TextStyle(color: Colors.black54, fontSize: 30, fontWeight: FontWeight.bold),
              )
          ),
          clockButtons(),
        ],
      ),
    );
  }

  Widget _clockView() {
    double percent = elapsedTime / pomoTime;
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
            formatTime(elapsedTime, pomoTime),
            style: TextStyle(
                color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.w300),
          )
      ),
    );
}

  Widget clockButtons() {
    return Row(
      children: <Widget>[
        iconButton(Icons.stop, pomo.resetTimer),
        pomo.isPlaying ?
          iconButton(Icons.pause, pomo.changeStatus(false, pomoTime))
          : iconButton(Icons.play_arrow, pomo.changeStatus(true, pomoTime)),
      ],
    );
  }

  Widget iconButton(icon, onPressedFunc) {
    return IconButton(
      iconSize: 50,
      splashColor: Colors.white30,
      color: Colors.black54,
      icon: Icon(icon),
      onPressed: () => {
        onPressedFunc()
      },
    );
  }
}
