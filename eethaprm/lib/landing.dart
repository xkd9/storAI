import 'package:eethaprm/learn.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LandingRoute extends StatelessWidget {
  String category = "";
  int colorIndex = 0;
  LandingRoute({required this.category, required this.colorIndex});
  List<Color> colors = [Colors.pink[50]!,Colors.indigo[50]!, Colors.blueGrey[50]!, Colors.lime[50]!, Colors.cyan[50]!, Colors.brown[50]!, Colors.purple[50]!, Colors.lightBlue[50]! ];

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text(""),
        backgroundColor: colors[colorIndex],
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ), 
      ),
      body:StreamBuilder(
      stream: FirebaseFirestore.instance.collection('stories').where("category", isEqualTo: category).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading indicator
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return Text('No data available'); // Handle the case when there is no data
        }
        return Column(
          children: snapshot.data?.docs.map((DocumentSnapshot document) {
            return ListTile(
              trailing: Icon(
                Icons.more_vert,
              ),
              title: Text(document['prompt']),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LearnRoute(docId: document.id)));
              },
              // Add more widgets to display other fields from the document
            );
          }).toList() ?? [], // Use the null-aware operator to handle null data
        );
      },
    )
    );
  }
}