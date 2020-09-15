import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_a_note_project/settings/setting_data_handler.dart';
import 'hello_page/welcome_page.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingDataHandler>(
      builder: (__) => SettingDataHandler(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomePage(),
      ),
    );
  }
}

