import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MonthTable extends StatefulWidget {
  @override
  _MonthTableState createState() => _MonthTableState();
}

class _MonthTableState extends State<MonthTable> {
  List<Meeting> meetings;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _Calender(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: (){},
      ),
    );
  }
  Widget _Calender() {
    return SfCalendar(
      view: CalendarView.month,
      showNavigationArrow: true,
      dataSource: MeetingDataSource(_getDataSource()),
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

  List<Meeting> _getDataSource() {
    meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
    DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false));
    return meetings;
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
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}