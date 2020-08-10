import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class TimeTable extends StatefulWidget {
  @override
  _CalanderState createState() => _CalanderState();
}

class _CalanderState extends State<TimeTable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SfCalendar(
          view: CalendarView.week,
          todayHighlightColor: Colors.red, // 해당 요일 하이라이팅 뷰
          cellBorderColor: Colors.lightBlue,
          firstDayOfWeek: 1, // 일요일 첫번째 선택
          selectionDecoration: BoxDecoration( // 해당 시간대 선택 뷰
            color: Colors.transparent,
            border: Border.all(color: Colors.red, width: 2),
            borderRadius: const BorderRadius.all((Radius.circular(4))),
            shape: BoxShape.rectangle,
          ),
        ),
      ),
    );
  }
}
