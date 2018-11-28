import 'package:flutter/material.dart';
import 'home.dart';
import 'addTodo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodoList',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      routes: {
        '/Add': (_) => AddTodoPage(),
      },
      home: HomePage(),
    );
  }
}