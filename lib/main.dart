import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterrealtimedatabase/databaseservice.dart';
import 'package:flutterrealtimedatabase/item.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ItemListScreen(),
    );
  }
}

class ItemListScreen extends StatefulWidget {
  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<Item> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await _databaseService.getItems();
    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  void _addItem() async {
    final String uniqueId = _generateUniqueId(); // Generate a unique ID
    final newItem = Item(uniqueId, 'New Item', 1);
    await _databaseService.createItem(newItem);
    _loadItems();
  }

  String _generateUniqueId() {
    // Combine multiple techniques for robust uniqueness
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final randomString = UniqueKey().toString(); // Use UniqueKey for randomness

    return '$timestamp-$randomString'; // Concatenate for combined uniqueness
  }

  void _deleteItem(String itemId) async {
    await _databaseService.deleteItem(itemId);
    _loadItems();
  }

  void _updateItem(Item item) async {
    final updatedItem = Item(item.id, 'Updated Item', item.quantity + 1);
    await _databaseService.updateItem(updatedItem);
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Quantity: ${item.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _updateItem(item),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteItem(item.id),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: Icon(Icons.add),
      ),
    );
  }
}
