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
  List<TodoEntry> getTodos;
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
      tasks.add(TodoEntry.fromSnapshot(e.snapshot));
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
          // print('tasks length is ${tasks.length}');
          // print('$index');
          return ListTile(
            title: Text('${tasks[index].title}'),
            subtitle: Text('${tasks[index].limit}'),
            onTap: () {
              _showAlertDialog(context, tasks[index].key, tasks[index].title, tasks[index].limit);
            },
          );
        },
      )
    );
  }

  Future<Null> addTodo() async {
    tasks = new List();
    _mainRefarence.child('Tasks').onChildAdded.listen(_onTodoAdded);
  }

  Future<Null> refresh() async {
    print('リフレッシュスタート');
    final Completer<Null> completer = new Completer<Null>();
    addTodo().then((_) {
      completer.complete();
    });
    print('リフレッシュ終了');
    return completer.future;
  }
}

void _showAlertDialog(BuildContext context, String key, String title, String limit) {
  final firebaseConnector = FirebaseConnector();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('$key'),
        
        content: Row(
          children: <Widget>[
            Text('$title!!!'),
            Text('$limit'),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Delete'),
            onPressed: () {
              firebaseConnector.deleteTodoTasks(key);
            },
          ),
        ],
      );
    }
  );
}