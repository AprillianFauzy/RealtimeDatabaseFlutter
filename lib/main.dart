import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
      title: 'Flutter Firebase CRUD',
      home: FirebaseCRUD(),
    );
  }
}

class FirebaseCRUD extends StatefulWidget {
  @override
  _FirebaseCRUDState createState() => _FirebaseCRUDState();
}

class _FirebaseCRUDState extends State<FirebaseCRUD> {
  final DatabaseReference _userRef =
      FirebaseDatabase.instance.ref().child("users");
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase CRUD'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    createUser();
                  },
                  child: Text('Create'),
                ),
                ElevatedButton(
                  onPressed: () {
                    readUser();
                  },
                  child: Text('Read'),
                ),
                ElevatedButton(
                  onPressed: () {
                    updateUser();
                  },
                  child: Text('Update'),
                ),
                ElevatedButton(
                  onPressed: () {
                    deleteUser();
                  },
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void createUser() {
    _userRef.push().set({
      'name': _nameController.text,
      'age': _ageController.text,
      'address': _addressController.text,
    }).then((_) {
      _nameController.clear();
      _ageController.clear();
      _addressController.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User created successfully')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create user: $error')));
    });
  }

  void readUser() {
    _userRef.once().then((DataSnapshot snapshot) {
          print('Data : ${snapshot.value}');
        } as FutureOr Function(DatabaseEvent value));
  }

  void updateUser() {
    // Implement update functionality here
  }

  void deleteUser() {
    // Implement delete functionality here
  }
}
