import 'package:flutter/material.dart';

import 'constants.dart';

final ThemeData appTheme = ThemeData(primarySwatch: Colors.blue);
Widget textWidget(
    String text, double fontSize, FontWeight fontWeight, Color color) {
  return Text(
    text,
    textAlign: TextAlign.left,
    style: TextStyle(
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color,
    ),
  );
}

Widget buttonWidget(Function onPressed, String text, double fontSize,
    FontWeight fontWeight, Color color) {
  return Material(
    color: appColor,
    elevation: 5.0,
    borderRadius: BorderRadius.circular(30.0),
    child: MaterialButton(
      onPressed: onPressed,
      child: textWidget(text, fontSize, fontWeight, color),
    ),
  );
}

Widget flatButtonWidget(Function onPressed, String text, double fontSize,
    FontWeight fontWeight, Color color, IconData leftIcon) {
  return Expanded(
    flex: 1,
    child: Padding(
      padding: const EdgeInsets.only(right: 3.0),
      child: Material(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(2.0),
        child: MaterialButton(
          onPressed: onPressed,
          child: Row(
            children: <Widget>[
              Icon(
                leftIcon,
                color: Colors.black,
              ),
              textWidget(text, fontSize, fontWeight, color)
            ],
          ),
        ),
      ),
    ),
  );
}

Widget roundedButtonWidget(Function onPressed, IconData leftIcon) {
  return Container(
    width: 50.0,
    height: 50.0,
    child: Material(
      color: Colors.grey.withOpacity(0.2),
      borderRadius: BorderRadius.circular(50.0),
      child: MaterialButton(
        onPressed: onPressed,
        child: Icon(
          leftIcon,
          color: Colors.grey,
        ),
      ),
    ),
  );
}
