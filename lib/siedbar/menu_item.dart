import 'package:flutter/material.dart';
import 'package:take_a_note_project/enum.dart';
import 'package:take_a_note_project/navigation_provider/navigation_provider.dart';

class MenuItem with ChangeNotifier{
  MenuType menuType;
  Icon icon;
  Text title;

  MenuItem(this.menuType, {this.icon, this.title});

  updateMenu(MenuItem menuItem) {
    this.menuType = menuItem.menuType;
    this.icon = menuItem.icon;
    this.title = menuItem.title;
    notifyListeners();
  }
}
