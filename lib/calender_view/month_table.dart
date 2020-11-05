import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:take_a_note_project/todoList/todoList_handler.dart';

class TimeTable extends StatefulWidget {
  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  CalendarController controller;
  TodoListHandler todoListHandler;
  TextStyle dayStyle(FontWeight fontWeight) {
    return TextStyle(color: Color(0xff30384c), fontWeight: fontWeight);
  }
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
  @override
  Widget build(BuildContext context) {
    todoListHandler = Provider.of<TodoListHandler>(context);
    return Container(
      child: SingleChildScrollView(
        child: Column(
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
                  todoListHandler.selectedEvents = events;
                  todoListHandler.getDone(controller.selectedDay);
                });
              },
            ),
            SizedBox(height: 20),
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
                        child: Text("Today", style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        ),),
                      ),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: todoListHandler.doneTodo.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: todoCard(context,
                                  todoListHandler.doneTodo,
                                  index
                              ),
                            );
                          }
                      )
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              Color(0xff30384c).withOpacity(0),
                              Color(0xff30384c)
                            ],
                            stops: [
                              0.0,
                              1.0
                            ]
                          )
                      ),
                    )
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget todoCard(BuildContext context, todoItem, int index) {
    Color color = Colors.white38;
    Color titleColor = Colors.white;
    String toDo = todoItem[index].todo;
    String startTime = todoItem[index].startTime;
    String endTime = todoItem[index].endTime;

    return Card(
        elevation: 5,
        color: color,
        child: ListTile(
          leading: Icon(CupertinoIcons.check_mark_circled_solid, color: Colors.greenAccent, size: 40,),
          title: Text(
              (startTime != null) ? "`$startTime` ~ `$endTime`" : "- ~ -"
              ,style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 20, color: titleColor)),
          subtitle: Text(toDo, style: TextStyle(
            fontWeight: FontWeight.normal, fontSize: 30, color: Colors.white70
          ),),
        )
    );
  }
}
