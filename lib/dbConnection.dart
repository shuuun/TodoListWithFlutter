import 'package:firebase_database/firebase_database.dart';

class TodoEntry {

  String key;
  String title;
  String limit;

  TodoEntry(this.key, this.title, this.limit);

  TodoEntry.fromSnapShot(DataSnapshot snapshot): 
    key = snapshot.key,
    title = snapshot.value['title'],
    limit = snapshot.value['limit'];

  toJson() {
    return {
      'title': title,
      'limit': limit
    };
  }
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