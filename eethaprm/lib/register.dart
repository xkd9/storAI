import 'package:firebase_auth/firebase_auth.dart';
import 'package:eethaprm/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_auth.dart';
import 'validator.dart';
class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);
  @override
  State<RegisterView> createState() => _RegisterViewState();
}
class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Padding(  
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(hintText: "Name"),
                    controller: _nameTextController,
                    validator: (value) => Validator.validateName(name: value),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Email"),
                    controller: _emailTextController,
                    validator: (value) => Validator.validateEmail(email: value),
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
                        User? user = await FireAuth.registerUsingEmailPassword(
                          name: _nameTextController.text,
                          email: _emailTextController.text,
                          password: _passwordTextController.text,
                        );
                        if (user != null) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(user),
                            ),
                            ModalRoute.withName('/'),
                          );
                        } else {
                          print("THERE WAS AN ERROR!");
                          const AlertDialog(title: Text("There was an error!"));
                        }
                      }
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )));
  }
}