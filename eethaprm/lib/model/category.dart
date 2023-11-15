import 'package:cloud_firestore/cloud_firestore.dart';
class Category {

  Future<List<Map<String, dynamic>>?> fetchDataFromFirestore(String collectionName) async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(collectionName).get();
    List<Map<String, dynamic>> data = [];
    querySnapshot.docs.forEach((doc) {
      data.add(doc.data() as Map<String, dynamic>);
    });
    return data;
  } catch (e) {
    print('Error fetching data: $e');
    return null;
  }
}
}