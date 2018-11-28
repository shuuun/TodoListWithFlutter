import 'package:flutter/material.dart';

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

class CreateTodo extends StatelessWidget {
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
                maxLength: 20,
                decoration: InputDecoration(
                  labelText: "TODO",
                  icon: Icon(Icons.directions_run)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}