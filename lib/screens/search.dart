import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String query;

  Widget buildFloatingSearchBar(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Food quantity, No. of persons, food type...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 500),
      transitionCurve: Curves.easeInCubic,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 50),
      borderRadius: BorderRadius.circular(
        20,
      ),
      onQueryChanged: (query) {
        setState(() {
          query = query;
        });
        print(query);
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: Icon(
              Icons.category_outlined,
            ),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
              color: Colors.white,
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(
                  child: Text(
                    "Start searching",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              )),
        );
      },
      body: Padding(
        padding: const EdgeInsets.only(top: 75.0, left: 15),
        child: Text(
          "Search Result",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search 🔍",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: buildFloatingSearchBar(context),
    );
  }
}
