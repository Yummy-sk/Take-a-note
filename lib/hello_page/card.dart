import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:take_a_note_project/calender_view/month_table.dart';
import 'package:take_a_note_project/pomodoro/pomodoro.dart';
import 'package:take_a_note_project/settings/setting_view.dart';

class CardView extends StatefulWidget {
  @override
  _CardState createState() => _CardState();
}

class _CardState extends State<CardView> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
            margin: const EdgeInsets.only(
                top: 16.0, bottom: 16.0, left: 24.0, right: 24.0),
            child: Column(
              children: <Widget>[
                cardLyout(Colors.indigoAccent, Text('Pomodoro'),
                    'images/pomodoro.png', Pomodoro()),
                cardLyout(Colors.grey, Text('Calendar'), 'images/calendar.png',
                    MonthTable()),
                cardLyout(Colors.amber, Text('Settings'), 'images/settings.png',
                    SettingView())
              ],
            )),
      ],
    );
  }

  Widget cardLyout(
      Color color, Text titleText, String imagePath, StatefulWidget page) {
    return GestureDetector(
      // card를 클릭 가능하게 변경
      onTap: () => {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page))
      },

      child: Card(
        margin: const EdgeInsets.only(top: 10, bottom: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 4.0,
        color: color,
        child: SizedBox(
            height: 200,
            width: 500,
            child: Center(
              child: Column(
                children: <Widget>[Image.asset(imagePath), titleText],
              ),
            )),
      ),
    );
  }
}
