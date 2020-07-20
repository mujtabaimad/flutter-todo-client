import 'package:flutter/material.dart';

class Task {
  String text;
  bool isFinished = false;

  Task({@required this.text, this.isFinished});

  toggleIsFinished() {
    isFinished = !isFinished;
  }
}
