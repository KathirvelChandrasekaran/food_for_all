import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/providers/moneyBagProvider.dart';
import 'package:food_for_all/utils/theming.dart';

class MoneyBagDetails extends StatelessWidget {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _upiIDController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final theme = watch(themingNotifer);
      final moneyBag = watch(moneyBagProvider);
      final moneyBagDetails = watch(moneyBagDetailsProvider);
      return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                    child: TextFormField(
                      maxLength: 50,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Title",
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        prefixIcon: Icon(
                          Icons.title_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                theme.darkTheme ? Colors.black : Colors.white,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                theme.darkTheme ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      cursorColor: Theme.of(context).primaryColor,
                      controller: _titleController,
                      style: TextStyle(
                        color: theme.darkTheme ? Colors.black : Colors.white,
                      ),
                      validator: (val) {
                        if (val.isEmpty) return "Should not be empty";
                        return null;
                      },
                      onChanged: (val) {
                        moneyBag.title = val.toString();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                    child: TextFormField(
                      maxLength: 250,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        prefixIcon: Icon(
                          Icons.description_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                theme.darkTheme ? Colors.black : Colors.white,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                theme.darkTheme ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      cursorColor: Theme.of(context).primaryColor,
                      controller: _descriptionController,
                      style: TextStyle(
                        color: theme.darkTheme ? Colors.black : Colors.white,
                      ),
                      validator: (val) {
                        if (val.isEmpty) return "Should not be empty";
                        return null;
                      },
                      onChanged: (val) {
                        moneyBag.description = val.toString();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                    child: TextFormField(
                      maxLength: 5,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Amount",
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        prefixIcon: Icon(
                          Icons.money,
                          color: Theme.of(context).primaryColor,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                theme.darkTheme ? Colors.black : Colors.white,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                theme.darkTheme ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      cursorColor: Theme.of(context).primaryColor,
                      controller: _amountController,
                      style: TextStyle(
                        color: theme.darkTheme ? Colors.black : Colors.white,
                      ),
                      validator: (val) {
                        if (val.isEmpty) return "Should not be empty";
                        return null;
                      },
                      onChanged: (val) {
                        moneyBag.amount = int.parse(val);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                    child: TextFormField(
                      maxLength: 100,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "UPI ID",
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        hintText: "9876543210@okoksbi",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(
                          Icons.fingerprint_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                theme.darkTheme ? Colors.black : Colors.white,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                theme.darkTheme ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      cursorColor: Theme.of(context).primaryColor,
                      controller: _upiIDController,
                      style: TextStyle(
                        color: theme.darkTheme ? Colors.black : Colors.white,
                      ),
                      validator: (val) {
                        if (val.isEmpty) return "Should not be empty";
                        return null;
                      },
                      onChanged: (val) {
                        moneyBag.upiID = val.toString();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate())
                        moneyBagDetails.addMoneyBagDetails(
                            context,
                            moneyBag.title,
                            moneyBag.description,
                            moneyBag.upiID,
                            moneyBag.amount);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).accentColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 125),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      "Save Details",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
