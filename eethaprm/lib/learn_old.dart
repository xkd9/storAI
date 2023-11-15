import 'package:flutter/material.dart';

//import 'dart:math';
class LearnRoute extends StatelessWidget {
    final List<Widget> imageWidgets = [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/safety/blow.jpg'),
              fit: BoxFit.fill,
            )
          ),
        ),
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/safety/face.jpg'),
              fit: BoxFit.fill,
            )
          ),
        ),
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/safety/shallow.jpg'),
              fit: BoxFit.fill,
            )
          ),
        ),
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/safety/sit.jpg'),
              fit: BoxFit.fill,
            )
          ),
        ),
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/safety/swim.jpg'),
              fit: BoxFit.fill,
            )
          ),
        ),
    ];

  @override
  Widget build(BuildContext context) {

    /*List<Widget> flippedImages = imageUrls.map((imageUrl) {
      /*return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotation(pi),
        child: Image.asset(imageUrl),
      );*/
      return Image.asset(imageUrl);
    }).toList();*/

    /*return ListView(
        children: flippedImages,
      );*/
    PageController controller = PageController(initialPage: 0); 

    return Container(
      child: PageView(
        scrollDirection: Axis.vertical,
        controller: controller,
        children: imageWidgets,
      )
    );
  }
}
