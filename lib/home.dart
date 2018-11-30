import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'dbConnection.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TodoList"),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            iconSize: 30,
            onPressed: () {
              Navigator.pushNamed(context, '/Add');
            },
          ),
        ],
      ),
      body: TodoListView(),
    );
  }
}

class TodoListView extends StatefulWidget {
  @override
  _TodoListViewState createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  List<TodoEntry> tasks;
  final _mainRefarence = FirebaseDatabase.instance.reference();
  StreamSubscription<Event> _onTasksAddedSubscription;

  @override 
  void initState() {
    super.initState();
    tasks = new List();
    _onTasksAddedSubscription = _mainRefarence.child('Tasks').onChildAdded.listen(_onTodoAdded);
  }

  @override
  void dispose() {
    _onTasksAddedSubscription.cancel();
    super.dispose();
  }

  void _onTodoAdded(Event e) {
    setState(() {
      tasks.add(TodoEntry.fromSnapShot(e.snapshot));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('${tasks[index].title}'),
          subtitle: Text('${tasks[index].limit}'),
        );
      },
    );
  }
}