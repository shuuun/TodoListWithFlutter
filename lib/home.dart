import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'dbConnection.dart';
import 'editTodoPage.dart';


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
  final firebaseConnector = FirebaseConnector();
  final _mainRefarence = FirebaseDatabase.instance.reference();
  Completer<Null> completer;
  int tasksCount = 0;

  @override 
  void initState() {
    super.initState();
    refresh();
  }

  void _onTodoAdded(Event e) {
    setState(() {
      tasks.add(TodoEntry.fromSnapshot(e.snapshot));
    });
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
          return Dismissible(
            key: Key(tasks[index].key),
            onDismissed: (direction) {
              setState(() {
                firebaseConnector.deleteTodoTasks(tasks[index].key);
                tasks.removeAt(index);
              });
            },
            background: Container(
              color: Colors.red, 
            ),
            child: Column(
              children: <Widget>[
                ListTile( 
                  key: Key(tasks[index].key),
                  title: Text('${tasks[index].title}'),
                  subtitle: Text('${tasks[index].limit}'),
                  onTap: () {
                    _showAlertDialog(context, tasks[index].key, tasks[index].title, tasks[index].limit, index);
                  },
                ),
                Divider(color: Colors.black,),
              ],
            )
          );
        },
      )
    );
  }

  Future<Null> addTodo() async {
    tasks = new List();
    setState(() {});
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

  void _showAlertDialog(BuildContext context, String key, String title, String limit, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title'),
          content: Row(
            children: <Widget>[
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
              child: Text('Edit'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTodo(snapshotKey: key, title: title, limit: limit,)
                  )
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.restore_from_trash),
              onPressed: () {
                firebaseConnector.deleteTodoTasks(key);
                Navigator.pop(context);
                refresh();
              },
              color: Colors.red,
            )
          ],
        );
      }
    );
  }
}