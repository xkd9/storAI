import 'dart:async';
import 'package:flutter/material.dart';
import 'splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eetha!!!',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthLoader(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  User? user;
  MyHomePage(User? user) {
    this.user = user;
  }
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
      ()=>Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder:
                                    (context) => HomeScreen(index: 0,))));
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child:FlutterLogo(size:MediaQuery.of(context).size.height)
    );
  }
}

class AuthLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return LoginView();
          } else {
            return MyHomePage(user);
          }
        }
        return CircularProgressIndicator();
      },
    );
  }
}