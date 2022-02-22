import 'package:flutter/material.dart';

class CommonStyle {
  static InputDecoration textFieldStyle(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(
      // prefixText: prefixText,
      // prefixIcon: Icon(icon),
      // prefixStyle: Theme.of(context).textTheme.bodyText1,
      // prefixStyle: textStyle,
      // fillColor: Colors.white.withOpacity(0.6),
      // filled: true,
      // isDense: true,
      // labelStyle: Theme.of(context).textTheme.overline,
      focusColor: Colors.blue,

      border: new OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(8.0),
        ),
        borderSide: new BorderSide(
          color: Colors.blue,
          width: 1.0,
        ),
      ),
      disabledBorder: new OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(8.0),
        ),
        borderSide: new BorderSide(
          color: Colors.blue,
          width: 1.0,
        ),
      ),
      focusedBorder: new OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(8.0),
        ),
        borderSide: new BorderSide(
          color: Colors.blue,
          width: 1.0,
        ),
      ),
      hintText: hintTextStr,
      hintStyle: TextStyle(color: Colors.grey),
      labelText: labelTextStr,
      // labelStyle: new TextStyle(color: Colors.grey),
    );
  }

  static ButtonStyle elevatedSubmitButtonStyle() {
    return ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(Size(100, 50)),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                side: BorderSide(color: Colors.green))));
  }

  static TextStyle myStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green);
}
