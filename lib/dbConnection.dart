import 'package:firebase_database/firebase_database.dart';

class TodoEntry {

  String key;
  String title;
  String limit;

  TodoEntry(this.key, this.title, this.limit);

  TodoEntry.fromSnapshot(DataSnapshot snapshot): 
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

  Future<Null> writeDataBase(String title, String limit) async {
    _mainRefarence.child('Tasks').push().set({
      'title': title,
      'limit': limit
    });
    print('finish');
  }
}