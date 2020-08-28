import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:take_a_note_project/hello_page/card_list.dart';
class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Take a note', style: TextStyle(fontWeight: FontWeight.bold),)
        ),
        shape: RoundedRectangleBorder( // AppBar 스타일 지정
          borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30)
          )
        )
      ),
      body: Container(
        child: CardList(),
      )
    );
  }
}
