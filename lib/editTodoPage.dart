import 'package:flutter/material.dart';

import 'dart:async';

import 'dbConnection.dart';

class EditTodo extends StatefulWidget {
  final String snapshotKey;
  final String title;
  final String limit;

  EditTodo({@required this.snapshotKey, @required this.title, @required this.limit});

  @override
  _EditTodoState createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {

  TextEditingController titleTextController;
  TextEditingController limitTextController;
  final firebaseConnector = FirebaseConnector();

  @override
  void initState() {
    titleTextController = TextEditingController(text: widget.title);
    limitTextController = TextEditingController(text: widget.limit);
    super.initState();
  }

  @override 
  void dispose() {
    titleTextController.dispose();
    limitTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit todo tasks'),
        elevation: 0,
      ),
      body: Form(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 30, 10),
                child: TextFormField(
                  maxLength: 25,
                  controller: titleTextController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    icon: Icon(Icons.directions_run),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 30, 10),
                child: TextFormField(
                  controller: limitTextController,
                  decoration: InputDecoration(
                    labelText: 'Limit',
                    icon: Icon(Icons.timer),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: RaisedButton(
                  elevation: 0,
                  padding: EdgeInsets.fromLTRB(50, 17, 50, 17),
                  disabledColor: Colors.grey,
                  onPressed: () {
                    if (titleTextController.text == '' || limitTextController.text == '') {
                      print('中身がないです。');
                    } else {
                      updateTodo(widget.snapshotKey,titleTextController.text, limitTextController.text);
                    }
                  },
                  color: Colors.red,
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  Future<Null> updateTodo(String key, String title, String limit) async {
    await firebaseConnector.updateTodoTasks(key, title, limit);
    titleTextController.clear();
    limitTextController.clear();
  }
}
