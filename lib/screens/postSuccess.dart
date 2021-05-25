import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/utils/theming.dart';

class PostSuccess extends StatelessWidget {
  const PostSuccess({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Successful upload",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final theme = watch(themingNotifer);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Image.asset(
                    'images/UploadSuccess.png',
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.7,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 125),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 20,
                    color: theme.darkTheme ? Colors.white : Colors.black,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
