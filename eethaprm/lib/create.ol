import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:permission_handler/permission_handler.dart';
import 'model/story.dart';
import 'StoryItems.dart';
import 'splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CreateRoute extends StatefulWidget {
  CreatePage createState() => CreatePage();
}

class CreatePage extends State<CreateRoute> {

  final TextEditingController titleController = TextEditingController();
  
  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // Add padding around the search bar
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 40.0),
          // Use a Material design search bar
          child: TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: 'Prompt',
              // Add a clear button to the search bar
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => {},
              ),
              // Add a search icon or button to the search bar
              prefixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // Perform the search here
                  addDocumentToCollection();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  
  Future<void> addDocumentToCollection() async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final CollectionReference collection = firestoreInstance.collection('prompts');
      
      await collection.add({
        'prompt': titleController.text,
      });
      titleController.clear();
      print('Document added to Firestore with an automatically generated ID.');
  } catch (e) {
    print('Error adding document to Firestore: $e');
  }
}

}
