import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/providers/filterPostProvider.dart';
import 'package:food_for_all/utils/theming.dart';

class Filters extends StatefulWidget {
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  List<bool> isFoodSelected = [false, false];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final theme = watch(themingNotifer);
        final filters = watch(filterProvider);
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  ToggleButtons(
                    selectedColor: Theme.of(context).accentColor,
                    fillColor: Theme.of(context).accentColor,
                    borderColor: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                    children: [
                      Container(
                        width: 150,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "Main Course",
                            style: TextStyle(
                              color: !theme.darkTheme
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "Tiffin",
                            style: TextStyle(
                              color: !theme.darkTheme
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                    isSelected: filters.isFoodSelected,
                    onPressed: (int index) {
                      setState(() {
                        filters.isFoodSelected[index] =
                            !filters.isFoodSelected[index];
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Expiry time limit⏱️",
                    style: TextStyle(
                      color: !theme.darkTheme ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Slider(
                    min: 0,
                    max: 24,
                    divisions: 24,
                    activeColor: Theme.of(context).accentColor,
                    inactiveColor: Colors.redAccent,
                    value: filters.startTime.toDouble(),
                    onChanged: (value) {
                      setState(
                        () {
                          filters.startTime = value.toInt();
                        },
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Less than ${filters.startTime} Hrs",
                    style: TextStyle(
                      color: !theme.darkTheme ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Switch(
                        value: filters.optionFlag,
                        onChanged: (_) => {
                          filters.optionFlag
                              ? setState(
                                  () {
                                    filters.optionFlag = false;
                                  },
                                )
                              : setState(
                                  () {
                                    filters.optionFlag = true;
                                  },
                                ),
                          filters.listenToOptionFlag(filters.optionFlag),
                        },
                        activeColor: Theme.of(context).accentColor,
                        inactiveThumbColor: Theme.of(context).accentColor,
                        inactiveTrackColor: Colors.redAccent,
                      ),
                      Text(
                        "Toggle to show more options",
                        style: TextStyle(
                          color: !theme.darkTheme ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: filters.optionFlag
                        ? Column(
                            children: [
                              Text(
                                "Food Quantity ⚖️",
                                style: TextStyle(
                                  color: !theme.darkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Slider(
                                min: 0,
                                max: 100,
                                divisions: 100,
                                activeColor: Theme.of(context).accentColor,
                                inactiveColor: Colors.redAccent,
                                value: filters.foodQuantity.toDouble(),
                                onChanged: (value) {
                                  setState(
                                    () {
                                      filters.foodQuantity = value.toInt();
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Exactly ${filters.foodQuantity} Kg",
                                style: TextStyle(
                                  color: !theme.darkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Person Count 👨🏼‍🤝‍👨🏻",
                                style: TextStyle(
                                  color: !theme.darkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Slider(
                                min: 0,
                                max: 1000,
                                divisions: 1000,
                                activeColor: Theme.of(context).accentColor,
                                inactiveColor: Colors.redAccent,
                                value: filters.personCount.toDouble(),
                                onChanged: (value) {
                                  setState(
                                    () {
                                      filters.personCount = value.toInt();
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Less than ${filters.personCount} Persons",
                                style: TextStyle(
                                  color: !theme.darkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Vessel Count 🍜",
                                style: TextStyle(
                                  color: !theme.darkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Slider(
                                min: 0,
                                max: 250,
                                divisions: 250,
                                activeColor: Theme.of(context).accentColor,
                                inactiveColor: Colors.redAccent,
                                value: filters.vesselCount.toDouble(),
                                onChanged: (value) {
                                  setState(
                                    () {
                                      filters.vesselCount = value.toInt();
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Less than ${filters.vesselCount} Vessels",
                                style: TextStyle(
                                  color: !theme.darkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          )
                        : Text(""),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read(filterProvider).listenToFilterFlag(true);
                      context.read(filterProvider).listenToTimeFlag(false);
                      context.read(filterProvider).listenToFilters(
                          filters.isFoodSelected,
                          filters.startTime,
                          filters.foodQuantity,
                          filters.personCount,
                          filters.vesselCount);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 145),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      "Apply Filter",
                      style: TextStyle(
                        fontSize: 20,
                        color: theme.darkTheme ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read(filterProvider).listenToFilterFlag(false);
                      context.read(filterProvider).listenToTimeFlag(false);
                      context
                          .read(filterProvider)
                          .listenToFilters([false, false], 0, 0, 0, 0);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).accentColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 145),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      "Reset Filter",
                      style: TextStyle(
                        fontSize: 20,
                        color: !theme.darkTheme ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
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
