import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';

//import 'dart:math';
class LearnRoute extends StatelessWidget {
  String docId = "";
  FlutterTts flutterTts = FlutterTts();
  LearnRoute({required this.docId});
    @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController();
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text(""),
        backgroundColor: Colors.amber[50],
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ), 
        actions: [
          IconButton(
                onPressed: () async {
                  await configureTts();
                  await speakText("hello");
                },
                icon: Icon(Icons.volume_up, color: Colors.black12),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('stories').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(); // or any loading indicator
          }

          List<DocumentSnapshot> documents = snapshot.data!.docs;
          print(docId);
          DocumentSnapshot? document;
          for(DocumentSnapshot d in documents) {
            if(d.id == docId ) {
              document = d;
            }
          }
          Map<String, dynamic> dd = document!.data() as Map<String, dynamic>;

          List<dynamic> d1 = dd["story"] as List<dynamic>;
          return PageView.builder(
            controller: _pageController,
            itemCount: d1.length,
            itemBuilder: (context, index) {
              // Build your page content using data from documents[index]
              return MyPageWidget(title: d1[index]['step'], image: d1[index]['image']);
            },
          );
        },
      ),
    );
  }
  Future<void> configureTts() async {
    await flutterTts.setSharedInstance(true);
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.setVolume(1.0);
    await flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});
  }
  Future<void> speakText(String text) async {
    print(text);
    await flutterTts.speak(text);
  }
}

class MyPageWidget extends StatelessWidget {
  final String title;
  final String image;
  MyPageWidget({required this.title, required this.image});

  /*@override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(image),
              fit: BoxFit.fill,
            )
          ),
          child: Align(alignment: Alignment.bottomCenter,
            child: Text(title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
            ),
          ),
        );
  }*/
  @override
  Widget build(BuildContext context) {
    return Stack(
          children: <Widget>[
            Container(
            child: Positioned.fill(
              child:Image.network(
                image,
                fit: BoxFit.fitHeight,
                alignment: Alignment.topCenter,
              ),
            )),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom:40.0, left: 20.0, right: 20.0),
                 child:Expanded( 
                    child: 
                        Text(title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0, color: Colors.white),
                      ),
                 )
              )
            ),
          ]
    );
  }
}