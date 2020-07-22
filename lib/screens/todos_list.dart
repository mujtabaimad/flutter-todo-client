import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/components/todoDialog.dart';
import 'package:todo/providers/todos_provider.dart';
import 'package:todo/screens/login.dart';

class TodosList extends StatelessWidget {
  static String path = 'todos_list';

  TodosList(context) {
    Provider.of<TodoProvider>(context, listen: false)
        .isUserLoggedIn()
        .then((isUserLoggedIn) {
      if (!isUserLoggedIn) {
        Navigator.popAndPushNamed(context, Login.path);
      } else {
        Provider.of<TodoProvider>(context, listen: false).fetchTodos();
      }
    });
  }

  lunchTodoDialog({context, todoIndex = -1}) async {
    if (todoIndex == -1)
      todoIndex = await Provider.of<TodoProvider>(context, listen: false)
          .createNewTodo();

    showDialog(
      context: context,
      builder: (BuildContext context) => TodoDialog(
        todoIndex: todoIndex,
      ),
    );
  }

  List<Widget> tasksList(todo, context) {
    List<Widget> tasksWidgets = [
      Container(
        padding: EdgeInsets.all(30),
        child: Text(todo.title),
      )
    ];
    for (var task in todo.tasks) {
      tasksWidgets.add(Container(
        child: Material(
          color: Colors.yellow.shade200,
          child: ListTile(
            title: Text(task.text),
            leading: Checkbox(
              value: task.isFinished,
              onChanged: null,
            ),
          ),
        ),
      ));
    }
    return tasksWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          lunchTodoDialog(context: context);
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(40),
              child: Text(
                Provider.of<TodoProvider>(context, listen: false)
                            .todoList
                            .length ==
                        0
                    ? 'Start Adding todo list using the botton on the bottom right corner'
                    : "",
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child:
                  Consumer<TodoProvider>(builder: (context, todoData, child) {
                return ListView.builder(
                  itemBuilder: (context, index) => (GestureDetector(
                    onTap: () {
                      lunchTodoDialog(context: context, todoIndex: index);
                    },
                    child: Card(
                      margin: EdgeInsets.all(30),
                      color: Colors.yellow.shade300,
                      child: Column(
                        children: tasksList(todoData.todoList[index], context),
                      ),
                    ),
                  )),
                  itemCount: todoData.todoList.length,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
