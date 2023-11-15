import 'package:firebase_database/firebase_database.dart';

class Item {
  final String id;
  final String text;
  final String imageUrl;
  final int pageNum;

  Item({required this.id, required this.text, required this.imageUrl, required this.pageNum});
}

class Story {
  final String id;
  final String title;
  final List<Item> items;

  Story({required this.id, required this.title, required this.items});
}

class StoryDAL {

}