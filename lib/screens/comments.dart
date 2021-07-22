import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:food_for_all/services/createPostService.dart';

class Comments extends StatefulWidget {
  QueryDocumentSnapshot snapshot;

  @override
  _CommentsState createState() => _CommentsState();

  Comments({this.snapshot});
}

class _CommentsState extends State<Comments> {
  DocumentSnapshot doc;
  List<dynamic> comments;

  @override
  void initState() {
    super.initState();
    doc = widget.snapshot;
    // comments = widget.snapshot['comments'];
  }

  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  List filedata = [
    {
      'name': 'Adeleye Ayodeji',
      'pic': 'https://picsum.photos/300/30',
      'message': 'I love to code'
    },
    {
      'name': 'Biggi Man',
      'pic': 'https://picsum.photos/300/30',
      'message': 'Very cool'
    },
    {
      'name': 'Biggi Man',
      'pic': 'https://picsum.photos/300/30',
      'message': 'Very cool'
    },
    {
      'name': 'Biggi Man',
      'pic': 'https://picsum.photos/300/30',
      'message': 'Very cool'
    },
  ];

  Widget commentChild(data) {
    return ListView(
      children: [
        for (var i = 0; i < widget.snapshot['comments'].length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: Container(
                height: 50.0,
                width: 50.0,
                decoration: new BoxDecoration(
                  color: Colors.blue,
                  borderRadius: new BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    widget.snapshot['comments'][i]['commentedPhotoURL'],
                  ),
                ),
              ),
              title: Text(
                widget.snapshot['comments'][i]['commentedBy'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                widget.snapshot['comments'][i]['comment'],
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "View Comments",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Container(
          child: CommentBox(
            userImage: widget.snapshot['photo'],
            child: commentChild(filedata),
            labelText: 'Write a comment...',
            withBorder: false,
            errorText: 'Comment cannot be blank',
            sendButtonMethod: () {
              if (formKey.currentState.validate()) {
                print(commentController.text);
                AddPostDetailsToFirebase()
                    .addCommentToPost(widget.snapshot, commentController.text);
                commentController.clear();
                FocusScope.of(context).unfocus();
              } else {
                print("Not validated");
              }
            },
            formKey: formKey,
            commentController: commentController,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            sendWidget: Icon(
              Icons.send_rounded,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
