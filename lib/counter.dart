import 'package:flutter/material.dart';

class Counter extends ChangeNotifier {
  var _count = 0;

  int get getCounter {
    return _count;
  }

  void incrementCounter() {
    _count += 1;
    notifyListeners();
  }

  void decrementCounter() {
    _count -= 1;
    notifyListeners();
  }

  void resetCounter() {
    _count = 0;
    notifyListeners();
  }
}
