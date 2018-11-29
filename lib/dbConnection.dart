import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class TodoEntry {
  String key;
  String title;
  String limit;

  TodoEntry({this.key, this.title, this.limit});

  TodoEntry.map(dynamic obj) {
    this.key = obj['key'];
    this.title = obj['title'];
    this.limit = obj['limit'];
  }



  TodoEntry.fromSnapShot(DataSnapshot snapshot): 
    key = snapshot.key,
    title = snapshot.value["title"],
    limit = snapshot.value["limit"];

  
}

class FirebaseConnector {
  final _mainRefarence = FirebaseDatabase.instance.reference();

  void writeDataBase(String title, String limit) {
    _mainRefarence.child("Tasks").push().set({
      'title': title,
      'limit': limit
    });
  }
}