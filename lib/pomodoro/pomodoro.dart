import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_a_note_project/pomodoro/pomodoro_handler.dart';
import 'package:take_a_note_project/settings/setting_data_handler.dart';

class Pomodoro extends StatefulWidget {
@override
_PomodoroState createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {

SharedPreferences prefs;
SettingDataHandler settingDataHandler;
PomodoroHandler pomodoroHandler;

var screenWidth;
//static final DateTime checkTime = DateTime.now();
//static final DateFormat formatter = DateFormat('MM월 dd일 H시 m분');
//final String formatted = formatter.format(checkTime);


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
        setState((){
          pomodoroHandler.isPlaying = true;
          pomodoroHandler.HandleOnPressed();
        })
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
        setState((){
          pomodoroHandler.isPlaying = false;
          pomodoroHandler.HandleOnPressed();
        })
      },
    );
  }


//  bottomSheet() {
//    showModalBottomSheet(
//        context: context,
//        builder: (context) {
//          return Container(
//            color: Color(0xFF737373),
//            height: 170,
//            child: Container(
//              child: bottomSheetMenu(),
//              decoration: BoxDecoration(
//                  color: Theme.of(context).canvasColor,
//                  borderRadius: BorderRadius.only(
//                    topLeft: const Radius.circular(10),
//                    topRight: const Radius.circular(10),
//                  )),
//            ),
//          );
//        });
//  }
//
//  Column bottomSheetMenu() {
//    return Column(
//      children: <Widget>[
//        ListTile(
//          leading: Icon(Icons.create),
//          title: Text('직접 작성합니다.'),
//          onTap: () => {closePopup(), _writeWhatYouDid()},
//        ),
//        ListTile(
//          leading: Icon(Icons.assignment_turned_in),
//          title: Text('Todo List에서 선택합니다.'),
//          onTap: () => {closePopup()},
//        ),
//        ListTile(
//          leading: Icon(Icons.close),
//          title: Text('기록하지 않겠습니다.'),
//          onTap: () => {closePopup()},
//        )
//      ],
//    );
//  }
//
//  _writeWhatYouDid() {
//    return showDialog(
//        context: context,
//        builder: (context) => AlertDialog(
//            title: Center(
//                child: Text(pomodoroHandler.startTime +
//                    " ~ " +
//                    pomodoroHandler.endTime +
//                    " 동안 무엇을 하셨나요?")),
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.all((Radius.circular(20.0)))),
//            content: TextField(
//              controller: pomodoroHandler.eventController,
//            ),
//            actions: <Widget>[saveButton(), cancelButton()]));
//  }
//
//  Widget saveButton() {
//    return RaisedButton(
//      color: Colors.white,
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.circular(18.0),
//        side: BorderSide(color: Colors.lightBlue),
//      ),
//      child: Text(
//        "Save",
//        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue),
//      ),
//      onPressed: () {
//        closePopup();
//      },
//    );
//  }
//
//  Widget cancelButton() {
//    return RaisedButton(
//      color: Colors.white,
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.circular(18.0),
//        side: BorderSide(color: Colors.deepOrangeAccent),
//      ),
//      child: Text(
//        "Cancel",
//        style: TextStyle(
//            fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent),
//      ),
//      onPressed: () {
//        closePopup();
//      },
//    );
//  }
//
//  void closePopup() {
//    Navigator.pop(context);
//  }
}
