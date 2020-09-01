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
  double percent = 0;
  static int TimeInMinut = 25;
  int TimeInSec = TimeInMinut * 60; // 초 수
  int _currentIndex = 0;
  bool isPlaying = false;
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
    return CircularPercentIndicator(
        circularStrokeCap: CircularStrokeCap.round,
        percent: percent,
        animation: true,
        animateFromLastPercent: true,
        radius: 300.0,
        lineWidth: 5.0,
        progressColor: Colors.white,
        center: Text(
          "$TimeInMinut",
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
        _PauseButton()
      ],
    );
  }
  Widget _StopButton(){
    return IconButton(
      iconSize: 50,
      splashColor: Colors.white,
      color: Colors.white,
      icon: Icon(Icons.stop),
      onPressed: () => {},
    );
  }
  Widget _PauseButton(){
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
              _StartTimer(),
          },
        );
  }
  _HandleOnPressed() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying ? _animationController.forward() : _animationController.reverse();
    });
  }
  _StartTimer(){
    TimeInMinut = 25;
    int Time = TimeInMinut * 60;
    double SecPercent = (Time/100);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (Time > 0){
          Time--;
          if(Time % 60 == 0){ // 분 수가 00 초이면, 분수를 감소.
            TimeInMinut--;
          }
          if (Time % SecPercent == 0){
            if (percent < 1) {
              percent += 0.01;
            }else {
              percent = 1;
            }
          }
        }else {
          percent = 0;
          TimeInSec = 25;
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