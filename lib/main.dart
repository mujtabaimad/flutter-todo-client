import 'package:flutter/material.dart';
import 'package:todo/providers/todos_provider.dart';
import 'package:todo/screens/login.dart';
import 'package:todo/screens/signup.dart';
import 'package:todo/screens/todos_list.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>TodoProvider(),
      child: MaterialApp(
        initialRoute: Login.path,
        routes: {
          TodosList.path: (context) => TodosList(context),
          Login.path: (context) => Login(),
          Signup.path: (context) => Signup(),
        },
      ),
    );
  }
}
