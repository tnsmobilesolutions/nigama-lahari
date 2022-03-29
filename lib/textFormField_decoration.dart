import 'package:flutter/material.dart';
import 'constant.dart';

class InputFieldDecoration {
  static var decoration = InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0),
      borderSide: BorderSide(
        color: Constant.orange,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Constant.orange),
    ),
    contentPadding: const EdgeInsets.all(15),
    labelText: 'ନାମ',
    labelStyle: TextStyle(fontSize: 15.0, color: Constant.white24),
  );
}
