import 'package:firebase_auth/firebase_auth.dart';
import 'package:eethaprm/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_auth.dart';
import 'validator.dart';
import 'main.dart';
class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);
  @override
  State<LoginView> createState() => _LoginViewState();
}
class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyHomePage(user),
        ),
      );
    }
    return firebaseApp;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(hintText: "Email"),
                        controller: _emailTextController,
                        validator: (value) =>
                            Validator.validateEmail(email: value),
                      ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        decoration: InputDecoration(hintText: "Password"),
                        controller: _passwordTextController,
                        obscureText: true,
                        validator: (value) =>
                            Validator.validatePassword(password: value),
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            User? user =
                                await FireAuth.signInUsingEmailPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text,
                            );
                            if (user != null) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage(user)),
                              );
                            } else {
                              print("THERE WAS AN ERROR!");
                              const AlertDialog(
                                  title: Text("There was an error!"));
                            }
                          }
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const RegisterView()),
                          );
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}