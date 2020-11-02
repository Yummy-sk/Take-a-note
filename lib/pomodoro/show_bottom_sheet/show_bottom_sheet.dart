import 'package:flutter/material.dart';
import 'package:take_a_note_project/pomodoro/show_bottom_sheet/select_todo.dart';
import 'package:take_a_note_project/pomodoro/show_bottom_sheet/select_todo.dart';

bottomSheet(BuildContext context, String startTime, String endTime) {
  TextEditingController textEditingController;
  showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              color: Color(0xFF737373),
              height: 170,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(10),
                      topRight: const Radius.circular(10),
                    )),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.create),
                      title: Text('직접 작성합니다.'),
                      onTap: () => {
                        Navigator.pop(context),
                        showDialog(
                            context: context,
                            builder: (context) =>
                                AlertDialog(
                                    title: Center(
                                        child: Text(startTime +
                                            " ~ " +
                                            endTime +
                                            " 동안 무엇을 하셨나요?")),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            (Radius.circular(20.0)))),
                                    content: TextField(
                                      controller: textEditingController,
                                    ),
                                    actions: <Widget>[
                                      actionButton(
                                          Colors.lightBlue,
                                          Text("Save", style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.lightBlue),),
                                          context),
                                      actionButton(
                                          Colors.deepOrangeAccent,
                                          Text(
                                            "Cancel",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepOrangeAccent),),
                                          context)
                                    ]))
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.assignment_turned_in),
                      title: Text('Todo List에서 선택합니다.'),
                      onTap: () => {
                        Navigator.pop(context),
                        selectTodo(context)
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.close),
                      title: Text('기록하지 않겠습니다.'),
                      onTap: () => {Navigator.pop(context)},
                    )
                  ],
                ),
              ),
            );
          });
}

  Widget actionButton(Color colors, Text text, context) {
    return RaisedButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: colors),
      ),
      child: text,
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
