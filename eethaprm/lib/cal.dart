import 'package:flutter/material.dart';

class CalRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: const Text('Cal'),
          
        ),
    );
  }
}