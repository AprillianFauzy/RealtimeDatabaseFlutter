import 'package:firebase_database/firebase_database.dart';
import 'package:flutterrealtimedatabase/item.dart';

class DatabaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<void> createItem(Item item) async {
    final reference = _database.reference().child('items');
    await reference.push().set(item.toJson());
  }

  Future<List<Item>> getItems() async {
    final snapshot = await _database.reference().child('items').once();
    final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
    final items = data.entries
        .map((entry) =>
            Item(entry.key, entry.value['name'], entry.value['quantity']))
        .toList();
    return items;
  }

  Future<void> updateItem(Item item) async {
    final reference = _database.reference().child('items/${item.id}');
    await reference.update(item.toJson());
  }

  Future<void> deleteItem(String itemId) async {
    final reference = _database.reference().child('items/$itemId');
    await reference.remove();
  }
}
