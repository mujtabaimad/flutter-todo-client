import 'package:flutter/material.dart';
import 'package:todo/models/task.dart';

class Todo {
  String title;
  List<Task> tasks;

  Todo({@required this.title, @required this.tasks});

  addTask(text){
    tasks.add(Task(text: text));
  }

}
