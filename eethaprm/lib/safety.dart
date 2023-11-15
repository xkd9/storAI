import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import 'dart:math';
class SafetyRoute extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController();
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('safety').orderBy('ord', descending: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(); // or any loading indicator
          }

          List<DocumentSnapshot> documents = snapshot.data!.docs;

          return PageView.builder(
            controller: _pageController,
            itemCount: documents.length,
            itemBuilder: (context, index) {
              // Build your page content using data from documents[index]
              return MyPageWidget(title: documents[index]['text'], image: documents[index]['image']);
            },
          );
        },
      ),
    );
  }
}

class MyPageWidget extends StatelessWidget {
  final String title;
  final String image;

  MyPageWidget({required this.title, required this.image});

  @override
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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0),
            ),
          ),
        );
  }
}