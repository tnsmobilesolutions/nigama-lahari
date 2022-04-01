import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Constant {
  static const blue = Color.fromARGB(207, 29, 20, 73);
  static Brightness brightness =
      SchedulerBinding.instance!.window.platformBrightness;

  static const darkBlue = Color.fromARGB(255, 20, 13, 54);
  static const darkOrange = Color.fromARGB(255, 245, 97, 64);
  static bool isDarkMode = false;
  static const lightOrange = Color.fromARGB(219, 248, 175, 97);
  static const lightYellow = Color.fromARGB(255, 255, 219, 128);
  static const lightblue = Color.fromARGB(180, 36, 29, 85);
  static const orange = Color.fromRGBO(219, 106, 2, 1);
  static const purpleRed = Color.fromARGB(255, 225, 48, 107);
  static const white = Color(0xFFffffff);
  static const white12 = Colors.white12;
  static const white24 = Colors.white24;
  static const yellow = Color.fromARGB(255, 252, 176, 69);
  static const black = Colors.black;

  static List<String> _catagory = [
    'ଜାଗରଣ',
    'ପ୍ରତୀକ୍ଷା',
    'ଆବାହନ',
    'ଆରତୀ',
    'ବନ୍ଦନା',
    'ପ୍ରାର୍ଥନା',
    'ବିଦାୟ ପ୍ରାର୍ଥନା',
  ];
}
