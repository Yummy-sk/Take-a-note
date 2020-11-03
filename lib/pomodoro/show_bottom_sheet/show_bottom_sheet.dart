import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_a_note_project/model/todo_model.dart';
import 'package:take_a_note_project/pomodoro/show_bottom_sheet/popup_content.dart';
import 'package:take_a_note_project/pomodoro/show_bottom_sheet/popup_layout.dart';
import 'package:take_a_note_project/pomodoro/show_bottom_sheet/select_todo.dart';
import 'package:take_a_note_project/pomodoro/show_bottom_sheet/select_todo.dart';
import 'package:take_a_note_project/services/todo_service.dart';

bottomSheet(BuildContext context, String startTime, String endTime) {
  TextEditingController textEditingController = TextEditingController();
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
                                          true,
                                          Colors.lightBlue,
                                          Text("Save", style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.lightBlue),),
                                          context,
                                        startTime,
                                        endTime,
                                        textEditingController,
                                      ),
                                      actionButton(
                                          false,
                                          Colors.deepOrangeAccent,
                                          Text(
                                            "Cancel",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepOrangeAccent),),
                                          context,
                                          startTime,
                                          endTime,
                                          textEditingController,
                                      )
                                    ]))
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.assignment_turned_in),
                      title: Text('Todo List에서 선택합니다.'),
                      onTap: () => {
                        Navigator.pop(context),
                        showPopup(context, SelectTodo())
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

  Future DatePicker(BuildContext context) {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        builder: (BuildContext context, Widget child) {
          return Theme(
              data: ThemeData.dark(),
              child: child
          );
        }
    );
  }
  Widget actionButton(bool bool, Color colors, Text text, context, String startTime, String endTime, TextEditingController eventController) {
    TodoModel todoModel = TodoModel();
    TodoService todoService = new TodoService();
    return RaisedButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: colors),
      ),
      child: text,
      onPressed: () {
        if (bool) {
          todoModel.isDone = 1;
          todoModel.todo = eventController.text;
          todoModel.dateTime = DateTime.now().millisecondsSinceEpoch;
          todoModel.startTime = startTime;
          todoModel.endTime = endTime;
          todoService.saveTodo(todoModel);
          print("저장됨");
        }
        Navigator.pop(context);
      },
    );
  }
  showPopup(BuildContext context, Widget widget, {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: 30,
        left: 30,
        right: 30,
        bottom: 50,
        child: PopupContent(
          content: Scaffold(
            appBar: AppBar(
              title: Text("했던 일을 선택합니다"),
              leading: Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    try {
                      Navigator.pop(context);
                    }catch(e) {}
                  },
                );
              },),
            ),
            resizeToAvoidBottomPadding: false,
            body: widget,
          ),
        )
      )
    );
  }

