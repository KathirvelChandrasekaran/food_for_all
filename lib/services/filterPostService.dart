import 'package:cloud_firestore/cloud_firestore.dart';

class FilterPostService {
  FilterPostService();

  CollectionReference db = FirebaseFirestore.instance.collection("Posts");

  Stream<QuerySnapshot> get(List<bool> food) {
    var snapshot = db
        .where('mainCourse', isEqualTo: food[0])
        .where('tiffin', isEqualTo: food[1])
        .snapshots();
    return snapshot;
  }
}
