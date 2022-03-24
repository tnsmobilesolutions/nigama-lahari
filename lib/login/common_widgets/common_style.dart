import 'package:flutter/material.dart';

class CommonStyle {
  static InputDecoration textFieldStyle(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(
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
        backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
                side: BorderSide(color: Colors.teal))));
  }
}
