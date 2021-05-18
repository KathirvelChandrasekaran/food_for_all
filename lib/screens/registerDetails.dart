import 'package:flutter/material.dart';
import 'package:food_for_all/screens/map.dart';
import 'package:food_for_all/widgets/buttons.dart';

class RegisterDetails extends StatelessWidget {
  const RegisterDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "More about you",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'images/About.png',
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          SizedBox(
            height:MediaQuery.of(context).size.height * 0.15,
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectLocationMaps(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            icon: Icon(Icons.add_location_alt_rounded),
            label: Text(
              "Your location",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}
