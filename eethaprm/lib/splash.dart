import 'package:flutter/material.dart';
import 'home.dart';
import 'learn.dart';
import 'quiz.dart';
import 'safety.dart';
import 'cal.dart';
import 'create.dart';
import 'login.dart';
import 'landing.dart';
import 'StoryItems.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  int index = 0;
  String extra = "";

  //String userName = "";
  //HomeScreen({required this.index, required this.userName});
  HomeScreen({required this.index, this.extra = ""});
  //HomeScreen({required this.index});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;
  String _extra = "Activities";
  List<Widget> pages() => [
    HomeRoute(),
    CreateRoute(),
    //SafetyRoute(),
    LoginView(),
    //LandingRoute(category: widget.extra,),
    //_HomeScreenState.logout(),
    //StoryItems(),
  ];

  static logout() async {
    await FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = pages();
    if(FirebaseAuth.instance.currentUser == null) {
      widget.index = 2;
    }
    _selectedIndex = widget.index;
    //_extra = widget.extra;
    return Scaffold(
        body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const<BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          /*BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Learn',
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            label: 'create',
          ),
          /*BottomNavigationBarItem(
            icon: Icon(Icons.safety_check),
            label: 'Safety',
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if(index == 2) {
            if(FirebaseAuth.instance.currentUser != null) {
              logout();
              index = 0;
            }
          }
          setState(() {
            widget.index = index;
          });
        },
        currentIndex: _selectedIndex > 3 ? 2 : _selectedIndex ,
        selectedItemColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
      )
    );
  }
}