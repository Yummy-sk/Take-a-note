import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_a_note_project/todoList/todoList_handler.dart';

import '../pomodoro_handler.dart';

class SelectTodo extends StatefulWidget {
  @override
  _SelectTodoState createState() => _SelectTodoState();
}

class _SelectTodoState extends State<SelectTodo> {
  DateTime selectedTime;
  bool isSelected = false;
  TodoListHandler todoListHandler;
  PomodoroHandler pomodoroHandler;

  @override
  Widget build(BuildContext context) {
    todoListHandler = Provider.of<TodoListHandler>(context);
    pomodoroHandler = Provider.of<PomodoroHandler>(context);
    return Scaffold(
      backgroundColor: Colors.white54,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.deepOrangeAccent)
              ),
             onPressed: (){
               isSelected = true;
               Future<DateTime> selectedDate = showDatePicker(
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
               selectedDate.then((dateTime){
                 setState(() {
                   selectedTime = dateTime;
                 });
               });
             },
              child: (isSelected) ? Text('$selectedTime') : Text("날짜를 선택해주세요")
            ),
            SingleChildScrollView(
              child: Container(
              padding:EdgeInsets.only(left: 30),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.55,
              decoration: BoxDecoration(
              color: Color(0xff30384c),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(top: 50),
                        child: Text("On Progress List", style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: todoListHandler.onProgressTodo.length,
                          itemBuilder: (context, index){
                            return GestureDetector(
                              child: Card(
                                elevation: 5,
                                color: Colors.white54,
                                child: ListTile(
                                  leading: Icon(CupertinoIcons.check_mark_circled_solid, color: Colors.amber),
                                  title: Text(todoListHandler.onProgressTodo[index].todo),
                                  onTap: (){
                                    setState(() {
                                      todoListHandler.onProgressTodo[index].isDone = 1;
                                      todoListHandler.onProgressTodo[index].startTime = pomodoroHandler.startTime;
                                      todoListHandler.onProgressTodo[index].endTime = pomodoroHandler.endTime;
                                      todoListHandler.setTodo(todoListHandler.onProgressTodo[index]);
                                    });
                                  },
                                ),
                              ),
                            );
                          }
                      )
                    ],
                  )
                ],
              ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
