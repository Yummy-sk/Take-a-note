import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:take_a_note_project/navigation_provider/navigation_provider.dart';
import 'package:take_a_note_project/siedbar/menu_item.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin<SideBar>{
  AnimationController _animationController;
  final _animationDuration = const Duration(milliseconds: 500);
  StreamController<bool> isSideBarOpenedStreamController;
  Stream<bool> isSideBarOpenedStream;
  StreamSink<bool> isSideBarOpenendSink;
  MenuItem menuItem;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: _animationDuration);
    isSideBarOpenedStreamController = PublishSubject<bool>();
    isSideBarOpenedStream = isSideBarOpenedStreamController.stream;
    isSideBarOpenendSink = isSideBarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSideBarOpenedStreamController.close();
    isSideBarOpenendSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    menuItem = Provider.of<MenuItem>(context);
    return StreamBuilder<bool>(
      initialData: false,
      stream: isSideBarOpenedStream,
      builder: (context, isSideBarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSideBarOpenedAsync.data ? 0 : -screenWidth,
          right: isSideBarOpenedAsync.data ? 0 : screenWidth - 45,
          child: Row(
            children: <Widget>[
              sideBarBody(),
              sideBarButton()
            ],
          ),
        );
      }
    );
  }

  Widget sideBarBody(){
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.black.withOpacity(0.8),
        child: Column(
          children: <Widget>[
            SizedBox(height: 100,),
            ListTile(
              title: Text("Test")
            ),
            Divider(
              height: 64,
              thickness: 0.5,
              color: Colors.white.withOpacity(0.3),
              indent: 32,
              endIndent: 32,
            ),
            Column(
              children: menuItems.map((currentMenuItem) => onSelectedMenu(currentMenuItem)).toList()
            )
          ],
        ),
      ),
    );
  }

  Widget onSelectedMenu(MenuItem currentMenuItem) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: (){
          menuItem.updateMenu(currentMenuItem);
          isSideBarOpenendSink.add(false);
          _animationController.reverse();
          print(currentMenuItem.menuType);
        },
        child: Row(
          children: <Widget>[
            currentMenuItem.icon,
            SizedBox(width: 20,),
            currentMenuItem.title
          ],
        ),
      ),
    );
  }

  Widget sideBarButton(){
    return Align(
      alignment: Alignment(0, -0.9),
      child: GestureDetector(
        onTap: (){
          onIconPressed();
        },
        child: ClipPath(
          clipper: CustomMenuClipper(),
          child: Container(
            width: 35,
            height: 110,
            color: Colors.black.withOpacity(0.8),
            alignment: Alignment.centerLeft,
            child: AnimatedIcon(
              progress: _animationController.view,
              icon: AnimatedIcons.menu_close,
              color: Color(0xFF1BB5FD),
              size: 25
            ),
          ),
        ),
      ),
    );
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;
    if (isAnimationCompleted) {
      isSideBarOpenendSink.add(false);
      _animationController.reverse();
    }else {
      isSideBarOpenendSink.add(true);
      _animationController.forward();
    }
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}