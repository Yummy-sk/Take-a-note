import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_a_note_project/settings/setting_data_handler.dart';

class Pomodoro extends StatefulWidget {
  @override
  _PomodoroState createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> with TickerProviderStateMixin {
  Timer timer;
  DateTime start;
  String startTime;
  String endTime;
  int count = 0;
  int elapsedTime = 0;
  bool isPlaying = false;
  static int pomodoroTime;
  static int time;
  static final DateTime checkTime = DateTime.now();
  static final DateFormat formatter = DateFormat('MM월 dd일 H시 m분');
  final String formatted = formatter.format(checkTime);
  TextEditingController _eventController;
  AnimationController _animationController;
  SharedPreferences prefs;
  SettingDataHandler settingDataHandler;
  DateTime _dateTimeStart;
  DateTime _dateTimeEnd;
  var screenWidth;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    _dateTimeStart = DateTime.now();
    _dateTimeEnd = DateTime.now().add(Duration(days: 7));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  Future<int> _initPref() async {
    prefs = await SharedPreferences.getInstance();
    var timeData = prefs.get('timeData');
    if (timeData != null) {
      settingDataHandler.selectedTimes["Pomodoro Setting"] = timeData;
    }

    pomodoroTime = settingDataHandler.selectedTimes["Pomodoro Setting"];
    time = pomodoroTime * 60;

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    settingDataHandler = Provider.of<SettingDataHandler>(context, listen: false);

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
              child: Text(_formatTime(elapsedTime, time), style: TextStyle(color: Colors.black54, fontSize: 30, fontWeight: FontWeight.bold),)
          ),
          _ClockButtons()
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

        double percent = elapsedTime / time;
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
                _formatTime(elapsedTime, time),
                style: TextStyle(
                    color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.w300),
              )
          ),
        );
      },
    );
  }

  Widget _ClockButtons() {
    return Row(
      children: <Widget>[_StopButton(), _PalyAndPauseButton()],
    );
  }

  Widget _StopButton() {
    return IconButton(
      iconSize: 50,
      splashColor: Colors.white30,
      color: Colors.black54,
      icon: Icon(Icons.stop),
      onPressed: () => {
        setState(() {
          time = pomodoroTime * 60;
          elapsedTime = 0;
        }),
        _animationController.reverse(),
        timer.cancel(),
        bottomSheet(),
        endTime = formatter.format(new DateTime.now())
      },
    );
  }

  Widget _PalyAndPauseButton() {
    return IconButton(
      iconSize: 50,
      splashColor: Colors.white30,
      icon: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: _animationController,
          color: Colors.black54),
      onPressed: () => {
        _HandleOnPressed(),
      },
    );
  }

  _HandleOnPressed() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying
          ? _animationController.forward()
          : _animationController.reverse();
      if (isPlaying) {
        _StartTimer();
      } else {
        timer.cancel();
      }
    });
  }

  // duration : 총시간, now : 얼마나 지났는지
  _formatTime(int now, int duration) {
    String first = ((duration - now) ~/ 60).toString();
    int seconds = ((duration - now) % 60);
    String latter = (seconds < 10 ? "0" : "") + seconds.toString();
    return first + ":" + latter;
  }

  _StartTimer() {
    startTime = formatted;
    start = new DateTime.now();
    start = elapsedTime > 0
        ? start.subtract(Duration(seconds: elapsedTime))
        : start;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // 1초에 한번씩 함수 실행.
      setState(() {
        if (time > elapsedTime) {
          elapsedTime = DateTime.now().difference(start).inSeconds;
        } else {
          endTime = formatter.format(new DateTime.now());
          time = pomodoroTime * 60;
          elapsedTime = 0;
          ++count;
          _animationController.reverse();
          timer.cancel();
          bottomSheet();
        }
      });
    });
  }

  void bottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 170,
            child: Container(
              child: bottomSheetMenu(),
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                  )),
            ),
          );
        });
  }

  Column bottomSheetMenu() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.create),
          title: Text('직접 작성합니다.'),
          onTap: () => {closePopup(), _writeWhatYouDid()},
        ),
        ListTile(
          leading: Icon(Icons.assignment_turned_in),
          title: Text('Todo List에서 선택합니다.'),
          onTap: () => {closePopup()},
        ),
        ListTile(
          leading: Icon(Icons.close),
          title: Text('기록하지 않겠습니다.'),
          onTap: () => {closePopup()},
        )
      ],
    );
  }

  _writeWhatYouDid() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Center(
                child: Text(startTime + " ~ " + endTime + " 동안 무엇을 하셨나요?")),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all((Radius.circular(20.0)))),
            content: TextField(
              controller: _eventController,
            ),
            actions: <Widget>[saveButton(), cancelButton()]));
  }

  Widget saveButton() {
    return RaisedButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.lightBlue),
      ),
      child: Text(
        "Save",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue),
      ),
      onPressed: () {
        closePopup();
      },
    );
  }

  Widget cancelButton() {
    return RaisedButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.deepOrangeAccent),
      ),
      child: Text(
        "Cancel",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent),
      ),
      onPressed: () {
        closePopup();
      },
    );
  }

  void closePopup() {
    Navigator.pop(context);
  }
}
