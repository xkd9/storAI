import 'package:eethaprm/landing.dart';
import 'package:flutter/material.dart';
import 'model/category.dart';
import 'splash.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeRoute extends StatelessWidget {
  final Category category = Category();
  final FirebaseAuth auth = FirebaseAuth.instance;

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    String display = "";
    print(user);
    if(user != null) {
        display = user.displayName ?? "";
    }
    else {

    }
    final List<MenuData> menu = [
      //'Activity', 'Trips', 'Food', 'Travel', 'School', 'Sports', "Entertainment", "Learn"
      MenuData("assets/images/sun.png", 'Activity', Colors.pink[50]),
      MenuData("assets/images/travel.png", 'Trips', Colors.indigo[50]),
      MenuData("assets/images/cutlery.png", 'Food', Colors.blueGrey[50]),
      MenuData("assets/images/airplane.png", 'Travel', Colors.lime[50]),
      MenuData("assets/images/bus.png", 'School', Colors.cyan[50]),
      MenuData("assets/images/sports.png", 'Sports', Colors.brown[50]),
      MenuData("assets/images/party.png", 'Entertainment', Colors.purple[50]),
      MenuData("assets/images/library.png", 'Learn', Colors.lightBlue[50]),
    ];

    return Container(
    child: Scrollbar(
  thickness: 3,
  child: Padding(
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    child: SingleChildScrollView(
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: menu.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1,
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 0.5,
                color: menu[index].bgColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LandingRoute(category: menu[index].title, colorIndex: index,)));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Image(
                        image: new AssetImage(menu[index].iconPath),
                        width: 100,
                        height: 100,
                        color: null,
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        menu[index].title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.black87),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ),
  ),
));
}
}

class MenuData {
  MenuData(this.iconPath, this.title, this.bgColor);
  //final IconData icon;
  final String iconPath;
  final String title;
  final Color? bgColor;
}