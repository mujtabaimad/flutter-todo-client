import 'package:flutter/material.dart';
import 'package:todo/models/task.dart';

class Todo {
  String title;
  String id;
  List<Task> tasks;

  Todo({ this.id,@required this.title, @required this.tasks});

  addTask(text){
    tasks.add(Task(text: text,isFinished: false));
  }

  removeTask(Task task){
    tasks.remove(task);
  }
  changeTaskText(Task task, String newValue){
    task.changeTextValue(newValue);
  }
  changeTitle(String newtitle){
    title = newtitle;
  }

}
