import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:take_a_note_project/pomodoro/todoList/todoList.dart';
import 'package:take_a_note_project/settings/setting_view.dart';

class Pomodoro extends StatefulWidget {
  @override
  _PomodoroState createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> with TickerProviderStateMixin {
  Timer timer;
  DateTime start;
  int count = 0;
  int elapsedTime = 0;
  int _currentIndex = 0;
  bool isPlaying = false;
  static int pomodoroTime = 5;
  static int time = pomodoroTime * 60;
  final List<Widget> bottomPages = [TodoList(), SettingView()];
  AnimationController _animationController;
  void _onTab(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => bottomPages[_currentIndex])
    );
  }

  @override
  void initState(){
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
  }

  @override
  void dispose(){
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _SettingButtons(),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.cyan[100], Colors.cyan[700]]
              )
          ),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _ClockView(),
              _ClockButtons(),
            ],
          ),
        )
    );
  }
  Widget _ClockView(){
    double percent = elapsedTime / time;
    return CircularPercentIndicator(
        circularStrokeCap: CircularStrokeCap.round,
        percent: percent,
        animation: true,
        animateFromLastPercent: true,
        radius: 300.0,
        lineWidth: 5.0,
        progressColor: Colors.white,
        center: Text(
          _formatTime(elapsedTime, time),
          style: TextStyle(color: Colors.white,
              fontSize: 50.0,
              fontWeight: FontWeight.w300),
        )
    );
  }

  Widget _ClockButtons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _StopButton(),
        _PalyAndPauseButton()
      ],
    );
  }

  Widget _StopButton() {
    return IconButton(
      iconSize: 50,
      splashColor: Colors.white,
      color: Colors.white,
      icon: Icon(Icons.stop),
      onPressed: () => {
        setState((){
          time = pomodoroTime * 60;
          elapsedTime = 0;
        }),
        _animationController.reverse(),
        timer.cancel()
      },
    );
  }

  Widget _PalyAndPauseButton(){
    return IconButton(
            iconSize: 50,
            splashColor: Colors.white,
            icon: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: _animationController,
              color: Colors.white
            ),
          onPressed: () => {
              _HandleOnPressed(),
          },
        );
  }
  _HandleOnPressed() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying ? _animationController.forward() : _animationController.reverse();
      if (isPlaying){ _StartTimer(); }
      else { timer.cancel();}
    });
  }
  // duration : 총시간, now : 얼마나 지났는지
  _formatTime(int now, int duration){
    String first = ((duration - now) ~/ 60).toString();
    int seconds = ((duration - now) % 60);
    String latter = (seconds < 10 ? "0" : "") + seconds.toString();
    return  first + ":" + latter;
  }

  _StartTimer(){
    start = new DateTime.now() ;
    start = elapsedTime > 0 ? start.subtract( Duration( seconds: elapsedTime)) : start;
    timer = Timer.periodic(Duration(seconds: 1), (timer){ // 1초에 한번씩 함수 실행.
      setState(() {
        if ( time > elapsedTime ){
          elapsedTime = DateTime.now().difference(start).inSeconds;
        }else {
          time = pomodoroTime * 60;
          elapsedTime = 0;
          ++count;
          _animationController.reverse();
          timer.cancel();
        }
      });
    });
  }

  Widget _SettingButtons() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: _onTab,
      currentIndex: _currentIndex,
      items: [
        _TodoButton(),
        _SetButton()
      ],
    );
  }

  BottomNavigationBarItem _TodoButton(){
    return BottomNavigationBarItem(
      icon: Icon(Icons.calendar_today),
      title: Text('Write To Do', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))
    );
  }
  BottomNavigationBarItem _SetButton(){
    return BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      title: Text('Setting', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),)
    );
  }
}