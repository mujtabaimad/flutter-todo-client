import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/task.dart';
import 'package:todo/providers/todos_provider.dart';

class TodoDialog extends StatefulWidget {
  int todoIndex;

  TodoDialog({@required this.todoIndex});

  @override
  _TodoDialogState createState() => _TodoDialogState();
}

class _TodoDialogState extends State<TodoDialog> {
  String title;
  bool focusNew = false;
  Task lastTask;
  String lastText;
  BuildContext lastContext;

  taskListTile(BuildContext context, Task task, onChange, onTaskCheckboxChange,
      onTaskRemove, isLast) {
    var txt = TextEditingController();
    txt.text = task.text;
    FocusNode f = FocusNode();
    if (focusNew && isLast) {
      f.requestFocus();
      focusNew = false;
    }
    f.addListener(() {
      print('${task.text} ==> ${f.hasFocus}');
      if (!f.hasFocus) {
        onChange(context, task, txt.text);
      }
    });
    return Material(
      color: Colors.yellow.shade200,
      child: ListTile(
        title: TextField(
          minLines: 1,
          maxLines: 10,
          controller: txt,
          decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: 'list item',
          ),
          focusNode: f,
          onChanged: (text) {
            lastTask = task;
            lastText = text;
            lastContext = context;
          },
        ),
        leading: Checkbox(
          value: task.isFinished,
          onChanged: (value) {
            onChange(context, task, txt.text);
            onTaskCheckboxChange(context, task, value);
          },
        ),
        trailing: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            onTaskRemove(context, task);
          },
        ),
      ),
    );
  }

  handleTaskRemove(context, task) {
    Provider.of<TodoProvider>(context, listen: false)
        .removeTask(widget.todoIndex, task);
  }

  handleTaskTextChange(context, task, newValue) {
    Provider.of<TodoProvider>(context, listen: false)
        .changeTaskText(widget.todoIndex, task, newValue);
    task.text = newValue;
  }

  handleTaskCheckboxChange(context, Task task, newValue) {
    Provider.of<TodoProvider>(context, listen: false)
        .changeTaskCheck(widget.todoIndex, task, newValue);
    task.isFinished = newValue;
  }

  onTitleChange(context, newTitle) {
    Provider.of<TodoProvider>(context, listen: false)
        .changeTitle(widget.todoIndex, newTitle);
  }

  titleComponent(context, todoData) {
    var txt = TextEditingController();
    txt.text = todoData.todoList[widget.todoIndex].title;
    FocusNode f = FocusNode();
    f.addListener(() {
      print(f.hasFocus);
      if (!f.hasFocus) {
        onTitleChange(context, txt.text);
      }
    });
    return TextField(
      decoration: new InputDecoration(
        border: InputBorder.none,
        hintText: 'Title',
      ),
      controller: txt,
      focusNode: f,
      onChanged: (newValue) {
        title = newValue;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      clipBehavior: Clip.none,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.yellow,
              padding: EdgeInsets.all(10),
              child:
                  Consumer<TodoProvider>(builder: (context, todoData, child) {
                return titleComponent(context, todoData);
              }),
            ),
            Container(
              child: Consumer<TodoProvider>(
                builder: (context, todoData, child) {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => (taskListTile(
                      context,
                      todoData.todoList[widget.todoIndex].tasks.reversed
                          .toList()[index],
                      handleTaskTextChange,
                      handleTaskCheckboxChange,
                      handleTaskRemove,
                      index == 0,
                    )),
                    itemCount: todoData.todoList[widget.todoIndex].tasks.length,
                    reverse: true,
                    shrinkWrap: true,
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(30),
              decoration: (BoxDecoration(
                color: Colors.yellow.shade300,
              )),
              child: GestureDetector(
                onTap: () {
                  Provider.of<TodoProvider>(context, listen: false)
                      .todoList[widget.todoIndex]
                      .addTask("");
//                  FocusNode f = FocusScope.of(lastContext);
//                  f.unfocus();
                  print(lastText);
                  if (lastTask != null && lastText != null)
                    handleTaskTextChange(context, lastTask, lastText);
                  if (title != null) onTitleChange(context, title);
                  setState(() {
                    focusNew = true;
                  });
                },
                child: Center(
                  child: Text('add new task'),
                ),
              ),
            ),
            Container(
              color: Colors.yellow,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      Provider.of<TodoProvider>(context, listen: false)
                          .deleteTodo(widget.todoIndex);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
