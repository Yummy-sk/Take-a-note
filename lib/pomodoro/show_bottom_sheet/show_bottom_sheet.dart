import 'package:flutter/material.dart';

class ShowBottomSheet extends StatelessWidget {
  String startTime, endTime;
  BuildContext buildContext;
  TextEditingController textEditingController;
  ShowBottomSheet(String startTime, String endTime){
    this.startTime = startTime;
    this.endTime = endTime;
  }
  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
      bottomSheet: bottomSheet(),
    );
  }
  bottomSheet() {
    showModalBottomSheet(
        context: buildContext,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 170,
            child: Container(
              child: bottomSheetMenu(),
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                  )),
            ),
          );
        });
  }

  Column bottomSheetMenu() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.create),
          title: Text('직접 작성합니다.'),
          onTap: () => {closePopup(), _writeWhatYouDid()},
        ),
        ListTile(
          leading: Icon(Icons.assignment_turned_in),
          title: Text('Todo List에서 선택합니다.'),
          onTap: () => {closePopup()},
        ),
        ListTile(
          leading: Icon(Icons.close),
          title: Text('기록하지 않겠습니다.'),
          onTap: () => {closePopup()},
        )
      ],
    );
  }

  _writeWhatYouDid() {
    return showDialog(
        context: buildContext,
        builder: (context) => AlertDialog(
            title: Center(
                child: Text(startTime +
                    " ~ " +
                    endTime +
                    " 동안 무엇을 하셨나요?")),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all((Radius.circular(20.0)))),
            content: TextField(
              controller: textEditingController,
            ),
            actions: <Widget>[saveButton(), cancelButton()]));
  }

  Widget saveButton() {
    return RaisedButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.lightBlue),
      ),
      child: Text(
        "Save",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue),
      ),
      onPressed: () {
        closePopup();
      },
    );
  }

  Widget cancelButton() {
    return RaisedButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.deepOrangeAccent),
      ),
      child: Text(
        "Cancel",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent),
      ),
      onPressed: () {
        closePopup();
      },
    );
  }

  void closePopup() {
    Navigator.pop(buildContext);
  }
}