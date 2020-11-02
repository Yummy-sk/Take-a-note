import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectTodo extends StatefulWidget {
  @override
  _SelectTodoState createState() => _SelectTodoState();
}

class _SelectTodoState extends State<SelectTodo> {
  DateTime dateTime = DateTime.now();
  Future<Null> selectDate(BuildContext context) async {
    DateTime datePicker = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1947),
        lastDate: DateTime(2030),
        textDirection: TextDirection.ltr,
        initialDatePickerMode: DatePickerMode.day,
        selectableDayPredicate: (DateTime value) => value.weekday == 6 || value.weekday == 7 ? false : true,
        builder: (BuildContext context, Widget child){
          return Theme(
            data: ThemeData.dark()
          );
        }
    );
    if (datePicker != null && datePicker != dateTime) {
      setState(() {
        dateTime = datePicker;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              cursorColor: Colors.black,
              readOnly: true,
              onTap: (){
                setState(() {
                  selectDate(context);
                });
              },
              decoration:  InputDecoration(
                  labelText: "Select Date",
                  labelStyle: TextStyle(fontSize: 16.0),
                  hintText: dateTime.toString(),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0)
                  )
              ),
            ),
          )
        ],
      ),
    );
  }
}

selectTodo(BuildContext context){
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
          content: SelectTodo()
      )
  );
}
