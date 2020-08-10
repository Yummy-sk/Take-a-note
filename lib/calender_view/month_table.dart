import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MonthTable extends StatefulWidget {
  @override
  _MonthTableState createState() => _MonthTableState();
}

class _MonthTableState extends State<MonthTable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _Calender()
    );
  }
  Widget _Calender() {
    return SfCalendar(
      view: CalendarView.month,
      showNavigationArrow: true,
      monthViewSettings: MonthViewSettings(
          showAgenda: true, // 어젠다를 보여줄꺼야
          dayFormat: 'EEE',
          numberOfWeeksInView: 4, // 화면에 보여지는 어젠다 수
          appointmentDisplayCount: 2,
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          navigationDirection: MonthNavigationDirection.horizontal,
          agendaStyle: _ShowAgendaStyle()
      ), // 어젠다 보여주기
    );
  }
  _ShowAgendaStyle() {
    return AgendaStyle(
      backgroundColor: Colors.transparent,
      appointmentTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontStyle: FontStyle.italic
      ),
      dayTextStyle: TextStyle(
        color: Colors.red,
        fontSize: 13,
        fontStyle: FontStyle.italic
      ),
      dateTextStyle: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal
      )
    );
  }
}