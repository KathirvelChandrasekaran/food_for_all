import 'package:flutter/material.dart';
import 'package:food_for_all/screens/login.dart';

class Starter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Food",
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 88,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            Text(
              "for All",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 88,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).accentColor,
                padding: EdgeInsets.fromLTRB(125, 15, 125, 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text('Continue', style: TextStyle(fontSize: 20,),),
            ),
          ],
        ),
      ),
    );
  }
}
