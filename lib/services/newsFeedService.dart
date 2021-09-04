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

  Stream<QuerySnapshot> getVolunteerPosts() {
    var snapshots = FirebaseFirestore.instance
        .collection("Posts")
        .where('accepted', isEqualTo: true)
        // .orderBy("createdAt", descending: true)
        .snapshots();
    return snapshots;
  }
}

class Post {
  Stream<DocumentSnapshot> get(String docID) {
    var snapshots =
        FirebaseFirestore.instance.collection("Posts").doc(docID).snapshots();
    return snapshots;
  }
}
