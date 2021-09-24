import 'package:flutter/material.dart';
import 'package:food_for_all/modals/message.dart';

// ignore: must_be_immutable
class Notifications extends StatefulWidget {
  List<Message> messages;
  Notifications({@required this.messages});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: null == widget.messages ? 0 : widget.messages.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                widget.messages[index].body,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
