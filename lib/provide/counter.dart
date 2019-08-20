import 'package:flutter/material.dart';

class Counter with ChangeNotifier {
  int value = 0;

  increment() {
    value++;
    // 通知订阅者
    notifyListeners();
  }
}
