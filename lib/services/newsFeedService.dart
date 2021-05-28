import 'package:cloud_firestore/cloud_firestore.dart';

class NewsFeedService {
  NewsFeedService();

  Stream<QuerySnapshot> getPosts() {
    var snapshots = FirebaseFirestore.instance
        .collection("Posts")
        .orderBy("createdAt", descending: true)
        .snapshots();
    return snapshots;
  }
}
