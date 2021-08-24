import 'package:flutter/material.dart';
import 'package:food_for_all/utils/theming.dart';

// ignore: non_constant_identifier_names
Padding InputTextMethod(
    BuildContext context,
    ThemeNotifer theme,
    TextInputType type,
    TextEditingController controller,
    int maxLength,
    String labelText,
    Icon prefixIcon,
    String validator) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
    child: TextFormField(
      keyboardType: type,
      maxLength: maxLength,
      controller: controller,
      style: TextStyle(
        color: theme.darkTheme ? Colors.black : Colors.white,
      ),
      validator: (val) {
        if (val.isEmpty) {
          return validator;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        prefixIcon: prefixIcon,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: theme.darkTheme ? Colors.black : Colors.white,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: theme.darkTheme ? Colors.black : Colors.white,
          ),
        ),
      ),
    ),
  );
}
