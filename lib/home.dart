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
  bool isRefreshed = false;
  List<TodoEntry> tasks;
  RefreshCallback onRefresh;

  final _mainRefarence = FirebaseDatabase.instance.reference();
  StreamSubscription<Event> result;
  Completer<Null> completer;

  @override 
  void initState() {
    super.initState();
    tasks = new List();
    _mainRefarence.child('Tasks').onChildAdded.listen(_onTodoAdded);
  }

  void _onTodoAdded(Event e) {
    setState(() {
      tasks.add(TodoEntry.fromSnapShot(e.snapshot));
    });
  }

  @override 
  void dispose() {
    result.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      displacement: 10, 
      child: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          if (index.isOdd) {
            return Divider(
              color: Colors.black,
            );
          }
          return ListTile(
            title: Text('${tasks[index].title}'),
            subtitle: Text('${tasks[index].limit}'),
          );
        },
      )
    );
  }

  Future<Null> addTodo() async {
    _mainRefarence.child('Tasks').onChildAdded.listen(_onTodoAdded);
  }

  Future<Null> refresh() async {
    final Completer<Null> completer = new Completer<Null>();
    tasks.clear();
    addTodo().then((_) {
      completer.complete();
    });
    return completer.future;
  }
}