import 'dart:io';
import 'dart:convert';
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
import 'package:uuid/uuid.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eethaprm/landing.dart';

class CreateRoute extends StatefulWidget {
  CreatePage createState() => CreatePage();
}

class CreatePage extends State<CreateRoute> {

  final TextEditingController _textFieldController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  bool apiCall = false;
  
  String id = "";
  List<String> _dropdownItems = <String>['Activity', 'Trips', 'Food', 'Travel', 'School', 'Sports', "Entertainment", "Learn"];
  List<Map<String, dynamic>> _stories = <Map<String, dynamic>>[];
  String _currentImageUrl = "";

  late StateSetter _setState;
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var uuid = Uuid();
    id = uuid.v1();  
    String _selectedDropdownValue = _dropdownItems.first;
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Story Assistant'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Text field
            TextField(
              controller: _textFieldController,
              decoration: InputDecoration(labelText: 'Prompt'),
            ),
            SizedBox(height: 20),

            // Dropdown
            DropdownButtonFormField(
              value: _selectedDropdownValue,
              items: _dropdownItems.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDropdownValue = newValue!;
                });
              },
              decoration: InputDecoration(labelText: 'Category'),
            ),
            SizedBox(height: 20),

            // Submit button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
              ),
              onPressed: () {
                // Handle the form submission here.
                String textFieldValue = _textFieldController.text;
                print('Text Field Value: $textFieldValue');
                print('Dropdown Value: $_selectedDropdownValue');
                addDocumentToCollection(textFieldValue, _selectedDropdownValue);
              },
              //style: Color:Colors.indigo[50],
              child: Text('Submit'),

            ),
            getProperWidget(),
            Flexible(
              flex: 6,
              fit: FlexFit.loose,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: _stories.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(title: new Column(children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Page: ${index} Text",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                      )
                    ),
                    new TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: TextEditingController(text: _stories[index]["step"]),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Prompt for generating Image:",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                      )
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: TextEditingController(text: _stories[index]["prompt"]),
                        ),
                        ),
                        IconButton(onPressed: () {
                          setState(() {apiCall = true; _currentImageUrl = "";});
                          generateImage(_stories[index]["prompt"], index);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (context, StateSetter setState) {
                                  _setState = setState;
                                  return AlertDialog(
                                    content: 
                                    Column(
                                      children: [
                                        Text(
                                          "Generating Image for the following prompt:",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                        ),
                                        Expanded(
                                        child: TextField(
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          controller: TextEditingController(text: _stories[index]["prompt"]),
                                        )),
                                        getImageWidget(context),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          );
                        }, icon: Icon(Icons.send))
                      ]
                    ),
                  ],) );
                },
              )
            ),
            ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                      ),
                      onPressed: () async {
                        CollectionReference ref = FirebaseFirestore.instance.collection('stories');
                        await ref.doc().set({
                          "story": _stories,
                          "prompt": _textFieldController.text,
                          "category": _selectedDropdownValue
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LandingRoute(category: _selectedDropdownValue, colorIndex: 0,)));
                      },
                      child: Text('Save'),
                    ),
          ],
        ),
      ),
    );
  }

  
  Future<void> addDocumentToCollection(String prompt, String category) async {
    
    List<Map<String, dynamic>> localList = <Map<String, dynamic>>[];
    try {
      setState(() {
        apiCall = true;
      });
      final User? user = auth.currentUser;
      String email = user!.email!;
      String name = user!.displayName!;
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('generateStory');
      final result = await callable.call(<String, dynamic>{
        'prompt': prompt,
        'category': category,
        'email': email,
        'name': name
      });
      localList =
        List<Map<String, dynamic>>.from(jsonDecode(result.data));
      /*for(dynamic item in jsonParsed) {
        localList.add(item);
      }*/
  } catch (e) {
    print('Error adding document to Firestore: $e');
  }
  setState(() {
        apiCall = false;
        _stories = localList;
  });
 }

 Future<void> getImage(String id, int index) async {
    String localImage = "";
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getImage');
      final result = await callable.call(<String, dynamic>{
        'id': id
      });
      
      
      //else if(resp.status == "failed") {
      if(result.data["status"] == "queued") {
        await Future.delayed(const Duration(seconds: 5));
        getImage(id, index);
      }
      else if(result.data["status"] == "failed") {
        //make retry
      }
      else {
        localImage = result.data["images"][0]["uri"];
        print(localImage);
        _setState(() {
          _currentImageUrl = localImage;
          _stories[index]["image"] = _currentImageUrl;
          print(_stories);
        });
      }

      //localList =
      //  List<Map<String, dynamic>>.from(jsonDecode(result.data));
      /*for(dynamic item in jsonParsed) {
        localList.add(item);
      }*/
  } catch (e) {
    print('Error getting image url: $e');
  }
  setState(() {
        apiCall = false;
        if(localImage != "") {
          _currentImageUrl = localImage;
          print("image state set");
        }
  });
 }
 Future<void> generateImage(String prompt, int index) async {
    try {
      setState(() {
        apiCall = true;
      });
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('generateImage');
      final result = await callable.call(<String, dynamic>{
        'prompt': prompt
      });

      print(result.data['id']);
      getImage(result.data['id'], index);
      //Map<String, dynamic> imageId = Map<String, dynamic>.from(jsonDecode(result.data));
      //print(imageId);
      //getImage(imageId["id"]);

      //localList =
      //  List<Map<String, dynamic>>.from(jsonDecode(result.data));
      /*for(dynamic item in jsonParsed) {
        localList.add(item);
      }*/
  } catch (e) {
    print('Error generating image: $e');
  }
 }


 Widget getProperWidget(){
    if(apiCall)
      return new CircularProgressIndicator();
    else {
      return new Text('');
    }
  }

  Widget getImageWidget(BuildContext context){
    if(_currentImageUrl != "") {
      return Column(children: [
        Image.network(_currentImageUrl),
        ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              //style: Color:Colors.indigo[50],
              child: Text('Save'),
            )
      ]);
      //return new Text('loading image');
    } else {
      return new CircularProgressIndicator();
    }
  }

}
