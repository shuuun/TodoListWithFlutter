import 'package:flutter/material.dart';
import 'dbConnection.dart';

class AddTodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todo Page"),
        elevation: 0,
      ),
      body: CreateTodo(),
    );
  }
}

class CreateTodo extends StatefulWidget {
  @override
  _CreateTodoState createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {

  final titleTextController = TextEditingController();
  final limitTextController = TextEditingController();
  final firebaseConnector = FirebaseConnector();

  @override
  void dispose() {
    titleTextController.dispose();
    limitTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
                  icon: Icon(Icons.directions_run)
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
                onPressed: () {
                  registerTodo(titleTextController.text, limitTextController.text);
                },
                color: Colors.red,
                child: Text(
                  "Register", 
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void registerTodo(String title, String limit) {
    firebaseConnector.writeDataBase(title, limit);
  }
}