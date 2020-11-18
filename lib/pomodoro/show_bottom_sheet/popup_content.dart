import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:take_a_note_project/pomodoro/pomodoro_handler.dart';
import 'package:take_a_note_project/todoList/todoList_handler.dart';

class PopupContent extends StatefulWidget {
  TodoListHandler todoListHandler;
  String startTime;
  String endTime;
  PopupContent(TodoListHandler todoListHandler, String startTime, String endTime){
    this.todoListHandler = todoListHandler;
    this.startTime = startTime;
    this.endTime = endTime;
  }
  _PopupContentState createState() => _PopupContentState();
}

class _PopupContentState extends State<PopupContent> {
  CalendarController controller;
  bool isSelected = false;
  @override
  void initState() {
    super.initState();
    controller = CalendarController();
  }
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
  TextStyle dayStyle(FontWeight fontWeight) {
    return TextStyle(color: Color(0xff30384c), fontWeight: fontWeight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select on progress todo"),
        leading: Builder(builder: (context){
          return IconButton(
              icon: Icon(CupertinoIcons.chevron_left),
              onPressed: () {
                try {
                  Navigator.pop(context);
                }catch (e){}
              }
          );
        })
      ),
      body: Container(
        color: Colors.grey[500],
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 30,),
              TableCalendar(
                calendarController: controller,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                    weekdayStyle: dayStyle(FontWeight.normal),
                    weekendStyle: dayStyle(FontWeight.normal),
                    selectedColor: Color(0xff30374b),
                    todayColor:  Color(0xff3037b)
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                    weekendStyle: TextStyle(
                        color: Color(0xff30384c),
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                    dowTextBuilder: (date, locale){
                      return DateFormat.E(locale).format(date).substring(0, 1);
                    }
                ),
                headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(
                        color: Color(0xff30384c),
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: Color(0xff30384c),
                    ),
                    rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: Color(0xff30384c)
                    )
                ),
                onDaySelected: (date, events, holidays) {
                  setState(() {
                    widget.todoListHandler.selectedEvents = events;
                    widget.todoListHandler.getOnProgress(controller.selectedDay);
                  });
                },
              ),
              Container(
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
                        SizedBox(height: 20,),
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.todoListHandler.onProgressTodo.length,
                            itemBuilder: (context, index){
                              return GestureDetector(
                                child: Card(
                                  elevation: 5,
                                  color: Colors.white54,
                                  child: ListTile(
                                    leading: (widget.todoListHandler.onProgressTodo[index].isDone == 1)
                                        ? Icon(CupertinoIcons.check_mark_circled_solid, color: Colors.greenAccent, size: 45,)
                                        : Icon(CupertinoIcons.check_mark_circled, color: Colors.greenAccent, size: 45,),
                                    title: Text(widget.todoListHandler.onProgressTodo[index].todo),
                                    onTap: (){
                                      setState(() {
                                        print(widget.startTime); // 왜 null을 띄울까..?
                                        widget.todoListHandler.onProgressTodo[index].isDone = 1;
                                        widget.todoListHandler.onProgressTodo[index].startTime = widget.startTime;
                                        widget.todoListHandler.onProgressTodo[index].endTime = widget.endTime;
                                        widget.todoListHandler.setTodo(widget.todoListHandler.onProgressTodo[index]);
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
