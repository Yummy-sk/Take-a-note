import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'hello_page/welcome_page.dart';

var database;

void main(){

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),

  ));

}
