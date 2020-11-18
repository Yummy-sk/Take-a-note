import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:take_a_note_project/model/todo_model.dart';
import 'package:take_a_note_project/pomodoro/show_bottom_sheet/popup_content.dart';
import 'package:take_a_note_project/pomodoro/show_bottom_sheet/popup_layout.dart';
import 'package:take_a_note_project/services/todo_service.dart';
import 'package:take_a_note_project/todoList/todoList_handler.dart';

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
                      leading: Icon(Icons.create_outlined),
                      title: Text('직접 작성합니다.'),
                      onTap: () => {
                        Navigator.pop(context),
                        showDialog(
                            context: context,
                            builder: (context) =>
                                AlertDialog(
                                    title: Center(
                                        child: Text(startTime +
                                            " ~ " + endTime + "\n" + "동안 무엇을 하셨나요?")),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            (Radius.circular(20.0)))),
                                    content: TextField(
                                      controller: textEditingController,
                                    ),
                                    actions: <Widget>[
                                     SizedBox(
                                       width: MediaQuery.of(context).size.width,
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
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
                                           SizedBox(width: 10.0),
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
                                         ],
                                       ),
                                     )
                                    ]))
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.assignment_turned_in),
                      title: Text('Todo List에서 선택합니다.'),
                      onTap: () => {
                        Navigator.pop(context),
                        showPopup(context, startTime, endTime)
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
    DateTime now;
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
          now = DateTime.now();
          todoModel.dateTime = DateTime.utc(now.year, now.month, now.day, 12).millisecondsSinceEpoch;
          todoModel.startTime = startTime;
          todoModel.endTime = endTime;
          todoService.saveTodo(todoModel);
          print("저장됨");
        }
        Navigator.pop(context);
      },
    );
  }
  showPopup(BuildContext context, String startTime, String endTime) {
    TodoListHandler todoListHandler = new TodoListHandler();

    Navigator.push(
      context,
      PopupLayout(
        top: 30,
        left: 30,
        right: 30,
        bottom: 50,
        child: PopupContent(todoListHandler, startTime, endTime)
      )
    );
  }

