import 'package:cloud_firestore/cloud_firestore.dart';

class NewsFeedService {
  NewsFeedService();

  Stream<QuerySnapshot> getPosts() {
    var snapshots = FirebaseFirestore.instance.collection("Posts").snapshots();
    return snapshots;
  }
}
