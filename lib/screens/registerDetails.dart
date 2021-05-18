import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/providers/mapProvider.dart';
import 'package:food_for_all/screens/map.dart';
import 'package:food_for_all/screens/newsFeed.dart';
import 'package:food_for_all/widgets/buttons.dart';

class RegisterDetails extends StatelessWidget {
  const RegisterDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();

    return Consumer(
      builder: (context, watch, child) {
        final address = watch(addressProvider).address;
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
          },
          child: Scaffold(
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
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'images/About.png',
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: ListTile(
                      leading: IconButton(
                        tooltip: "Save your location",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectLocationMaps(),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.add_location_alt_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        ),
                      ),
                      title: Text(
                        address == ""
                            ? "Press ⬅ Home icon to choose location"
                            : address.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.phone_android_outlined,
                        ),
                      ),
                      controller: phoneController,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  RoundedButton(
                    context,
                    "Submit",
                    15,
                    140,
                    NewsFeed(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
