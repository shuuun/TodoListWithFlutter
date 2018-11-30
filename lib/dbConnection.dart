import 'package:firebase_database/firebase_database.dart';

class TodoEntry {

  String _key;
  String _title;
  String _limit;

  String get key => _key;
  String get title => _title;
  String get limit => _limit;

  TodoEntry(this._key, this._title, this._limit);

  TodoEntry.map(dynamic obj) {
    this._key = obj['key'];
    this._title = obj['title'];
    this._limit = obj['limit'];
  }

  TodoEntry.fromSnapShot(DataSnapshot snapshot): 
    _key = snapshot.key,
    _title = snapshot.value['title'],
    _limit = snapshot.value['limit'];
}

class FirebaseConnector {
  final _mainRefarence = FirebaseDatabase.instance.reference();
  List<TodoEntry> entries;

  void writeDataBase(String title, String limit) {
    _mainRefarence.child('Tasks').push().set({
      'title': title,
      'limit': limit
    });
  }
}