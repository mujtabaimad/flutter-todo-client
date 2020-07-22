import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/task.dart';
import 'package:todo/models/todo.dart';

class TodoProvider extends ChangeNotifier {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  List<Todo> todoList = [];

  fetchTodos() async {
    print('fetchTodos');
    var user = await _auth.currentUser();
    await for (var snapshot in _firestore
        .collection('todos')
        .where('user.id', isEqualTo: user.uid)
        .snapshots()) {
      List<Todo> newTodos = [];
      for (var todo in snapshot.documents) {
        List<Task> tasks = [];
        for (var task in todo.data['tasks']) {
          tasks.add(Task(text: task['text'], isFinished: task['finished']));
        }
        newTodos.add(
            Todo(id: todo.documentID, title: todo.data['title'], tasks: tasks));
      }
      todoList = newTodos;
      notifyListeners();
    }
  }

  removeTask(int todoIndex, Task task) async {
    print('removeTask');
    todoList[todoIndex]..removeTask(task);
    await updateTodo(todoList[todoIndex]);
    notifyListeners();
  }

  changeTitle(int todoIndex, String newTitle) async {
    print('changeTitle');
    todoList[todoIndex].changeTitle(newTitle);
    await updateTodo(todoList[todoIndex]);
    notifyListeners();
  }

  updateTodo(Todo todo) async {
    var user = await _auth.currentUser();
    print('updateTodo');
    List<Map> tasks = [];
    for (var task in todo.tasks) {
      tasks.add({'text': task.text, 'finished': task.isFinished});
    }
    await _firestore.collection('todos').document(todo.id).setData({
      'title': todo.title,
      'tasks': tasks,
      'user': {'id': user.uid, 'email': user.email}
    });
  }

  changeTaskText(int todoIndex, Task task, String newValue) async {
    print('changeTaskText');
    todoList[todoIndex].changeTaskText(task, newValue);
    await updateTodo(todoList[todoIndex]);
    notifyListeners();
  }

  changeTaskCheck(int todoIndex, Task task, bool newValue) async {
    print('changeTaskCheck');
    task.isFinished = newValue;
    await updateTodo(todoList[todoIndex]);
    notifyListeners();
  }

  Future<int> createNewTodo() async {
    print('createNewTodo');
    var user = await _auth.currentUser();
//    todoList.add(Todo(title: '', tasks: []));
    await _firestore.collection('todos').add({
      'title': '',
      'tasks': [],
      'user': {'id': user.uid, 'email': user.email}
    });
    notifyListeners();
    return todoList.length - 1;
  }

  deleteTodo(int todoIndex) async {
    print('deleteTodo');
    var todoId = todoList[todoIndex].id;
    await _firestore.collection('todos').document(todoId).delete();
    notifyListeners();
  }

  isUserLoggedIn() async {
    print('isUserLoggedIn');
    return await _auth.currentUser() != null;
  }

  login(email, password) async {
    print('login');
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'success';
    } catch (e) {
      return e.message;
    }
  }

  signUp(email, password) async {
    print('signUp');
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return 'success';
    } catch (e) {
      return e.message;
    }
  }
}
