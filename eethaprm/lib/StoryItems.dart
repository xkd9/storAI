import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'model/story.dart';

class StoryItems extends StatefulWidget {
  //final Story story;
  //StoryItems({ required this.story});
  StoryItem createState() => StoryItem();
}

class StoryItem extends State<StoryItems> {
  String imageUrl = "";
  final TextEditingController titleController = TextEditingController();
  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(  
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(50),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(2, 2),
                    spreadRadius: 2,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: (imageUrl != "") ? Image.network(imageUrl) : Image.network('https://i.imgur.com/sUFH1Aq.png')
            ),
            ElevatedButton(
                child: Text("Upload Image", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                onPressed: (){
                  upload();
                },
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a Line about the pic',
              ),
            ),
            ElevatedButton(
                child: Text("Add More", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                onPressed: (){
                  addmore();
                },
            ),
            ElevatedButton(
                child: Text("Submit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                onPressed: (){
                  submit();
                },
            ),
          ],
        ),
      ),
    );
  }
  addmore() async {

  }
  submit() async {

  }
  upload() async {
    int uploadTimestamp = DateTime.now().millisecondsSinceEpoch;
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    //Check Permissions
    await Permission.camera.request();
    var permissionStatus = await Permission.camera.status;
    if (permissionStatus.isGranted){
      //Select Image
      final image = await _imagePicker.pickImage(source: ImageSource.camera);
      var file = File(image!.path);
      if (image != null){
        //Upload to Firebase
        var snapshot = await _firebaseStorage.ref().child('images/$uploadTimestamp').putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        
        print("imageURL" + downloadUrl);
        setState((){
          imageUrl = downloadUrl;
        });
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }
}
