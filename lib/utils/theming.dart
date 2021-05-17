import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Color(0xff0B2E59),
  primaryColor: Colors.white,
  selectedRowColor: Color(0xff7045af),
  indicatorColor: Colors.black,
  accentColor: Color(0xff7AB317),
  errorColor: Color(0xffce1212),
  appBarTheme: AppBarTheme(
    color: Color(0xff0B2E59),
    elevation: 0,
    iconTheme: IconThemeData(
      color: Color(
        0xffA0C55F,
      ),
    ),
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(
      color: Colors.white,
    ),
    bodyText2: TextStyle(
      color: Colors.white,
    ),
  ),
);

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Color(0xffe1e5ea),
  primaryColor: Colors.white,
  selectedRowColor: Color(0xff7045af),
  indicatorColor: Colors.black,
  accentColor: Color(0xff7AB317),
  errorColor: Color(0xffce1212),
  appBarTheme: AppBarTheme(
    color: Color(0xffe1e5ea),
    elevation: 0,
    iconTheme: IconThemeData(
      color: Color(
        0xffA0C55F,
      ),
    ),
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(
      color: Colors.white,
    ),
    bodyText2: TextStyle(
      color: Colors.white,
    ),
  ),
);

class ThemeNotifer extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences _prefs;
  bool _dakTheme;

  ThemeNotifer() {
    _dakTheme = true;
    _loadFromPreference();
  }

  bool get darkTheme => _dakTheme;

  toggleTheme() {
    _dakTheme = !_dakTheme;
    _saveToPreference();
    notifyListeners();
  }

  _initiatePreference() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPreference() async {
    await _initiatePreference();
    _dakTheme = _prefs.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPreference() async {
    await _initiatePreference();
    _prefs.setBool(key, _dakTheme);
  }
}

final themingNotifer = ChangeNotifierProvider(
  (ref) => ThemeNotifer(),
);
