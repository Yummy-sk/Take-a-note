import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Header{
  static Widget getCardHeader(
      {@required BuildContext context,
        @required String text,
        @required Color customColor,
        Color textColor = Colors.white,
        double customFontSize}) {
    customFontSize ??= Theme.of(context).textTheme.title.fontSize;

    return Container(
      width: 100,
      alignment: AlignmentDirectional.center,
      margin: EdgeInsets.only(left: 32),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: customColor,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: textColor,
          fontSize: customFontSize,
        ),
      ),
    );
  }
}