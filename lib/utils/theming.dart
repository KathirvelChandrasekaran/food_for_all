import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Color(0xff151515),
  primaryColor: Colors.white,
  selectedRowColor: Color(0xff2A044A),
  indicatorColor: Colors.black,
  accentColor: Color(0xff7AB317),
  errorColor: Color(0xffce1212),
  unselectedWidgetColor: Colors.white,
  appBarTheme: AppBarTheme(
    color: Color(0xff151515),
    elevation: 0,
    iconTheme: IconThemeData(
      color: Color(
        0xff7AB317,
      ),
    ),
    brightness: Brightness.light,
    titleTextStyle: GoogleFonts.nunito(
      color: Color(0xff0D6759),
    ),
  ),
  textTheme: TextTheme(
    bodyText1: GoogleFonts.nunito(
      color: Colors.white,
    ),
    bodyText2: GoogleFonts.nunito(
      color: Colors.white,
    ),
  ),
);

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Color(0xffe1e5ea),
  primaryColor: Color(0xff0D6759),
  selectedRowColor: Color(0xff2A044A),
  indicatorColor: Colors.black,
  accentColor: Color(0xff7AB317),
  errorColor: Color(0xffce1212),
  appBarTheme: AppBarTheme(
    color: Color(0xffe1e5ea),
    elevation: 0,
    iconTheme: IconThemeData(
      color: Color(
        0xff7AB317,
      ),
    ),
    brightness: Brightness.light,
    titleTextStyle: GoogleFonts.nunito(
      color: Color(0xff0D6759),
    ),
  ),
  textTheme: TextTheme(
    bodyText1: GoogleFonts.nunito(
      color: Colors.white,
    ),
    bodyText2: GoogleFonts.nunito(
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
