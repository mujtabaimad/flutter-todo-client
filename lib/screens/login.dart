import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/todos_provider.dart';
import 'package:todo/screens/signup.dart';
import 'package:todo/screens/todos_list.dart';

class Login extends StatelessWidget {
  static String path = 'login';
  String email;
  String password;
  final _formKey = GlobalKey<FormState>();
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => SafeArea(
          child: Center(
            child: Card(
              margin: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Can't be empty";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          helperText: 'Please enter your email',
                        ),
                        onChanged: (newEmail) {
                          email = newEmail;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Can't be empty";
                          }
                          return null;
                        },
                        obscureText: true,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          helperText: 'Please enter your password',
                        ),
                        onChanged: (newPassword) {
                          password = newPassword;
                        },
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red),
                        )),
                    RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please wait...'),
                            ),
                          );
                          Provider.of<TodoProvider>(context, listen: false)
                              .login(email, password)
                              .then((loginResponse) {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  loginResponse,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            );
                            errorMessage = loginResponse;
                            if (loginResponse == 'success') {
                              Navigator.popAndPushNamed(
                                  context, TodosList.path);
                            }
                          });
                        }
                      },
                      child: Text('Login'),
                    ),
                    FlatButton(
                      child: Text('Signup'),
                      onPressed: () {
                        Navigator.popAndPushNamed(context, Signup.path);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
