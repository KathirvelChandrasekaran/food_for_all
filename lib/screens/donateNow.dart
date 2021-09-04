import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/utils/theming.dart';
import 'package:upi_pay/upi_pay.dart';

// ignore: must_be_immutable
class DonateNow extends StatefulWidget {
  String upiID;

  DonateNow(this.upiID);

  @override
  _DonateNowState createState() => _DonateNowState();
}

class _DonateNowState extends State<DonateNow> {
  TextEditingController _amountController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  bool _showApps = false;
  List<ApplicationMeta> _apps;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0), () async {
      _apps = await UpiPay.getInstalledUpiApplications(
          statusType: UpiApplicationDiscoveryAppStatusType.all);
      setState(() {});
      print(_apps);
    });
  }

  void createSnackBar(String message) {
    final snackBar = new SnackBar(
      content: new Text(message),
      backgroundColor: Theme.of(context).errorColor,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final theme = watch(themingNotifer);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Donate Now",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
            },
            child: SingleChildScrollView(
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                          child: Text(
                            widget.upiID,
                            style: TextStyle(
                              color:
                                  theme.darkTheme ? Colors.black : Colors.white,
                              fontSize: 28,
                            ),
                          )),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                        child: TextFormField(
                          maxLength: 50,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Amount",
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            prefixIcon: Icon(
                              Icons.money_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: theme.darkTheme
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: theme.darkTheme
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                          cursorColor: Theme.of(context).primaryColor,
                          controller: _amountController,
                          style: TextStyle(
                            color:
                                theme.darkTheme ? Colors.black : Colors.white,
                          ),
                          validator: (val) {
                            if (val.isEmpty) return "Should not be empty";
                            return null;
                          },
                          onChanged: (val) {},
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _showApps = true;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).accentColor,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 125),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          "Donate Now",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        child: _showApps
                            ? Container(
                                margin: EdgeInsets.only(top: 32, bottom: 32),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 12),
                                      child: Text(
                                        'Pay Using installed apps',
                                        style: TextStyle(
                                          color: theme.darkTheme
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    if (_apps != null) _discoverableAppsGrid(),
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              )
                            : Text(""),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onTap(ApplicationMeta app) async {
    final transactionRef = Random.secure().nextInt(1 << 32).toString();
    print("Starting transaction with id $transactionRef");

    final a = await UpiPay.initiateTransaction(
      amount: _amountController.text,
      app: app.upiApplication,
      receiverName: 'Sharad',
      receiverUpiAddress: widget.upiID,
      transactionRef: transactionRef,
      transactionNote: 'UPI Payment',
    );

    createSnackBar(a.status.toString());
  }

  GridView _discoverableAppsGrid() {
    List<ApplicationMeta> metaList = [];
    _apps.forEach((e) {
      if (e.upiApplication.discoveryCustomScheme != null) {
        metaList.add(e);
      }
    });
    return _appsGrid(metaList);
  }

  GridView _appsGrid(List<ApplicationMeta> apps) {
    apps.sort((a, b) => a.upiApplication
        .getAppName()
        .toLowerCase()
        .compareTo(b.upiApplication.getAppName().toLowerCase()));
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: apps
          .map(
            (it) => Material(
              color: Colors.transparent,
              key: ObjectKey(it.upiApplication),
              // color: Colors.grey[200],
              child: GestureDetector(
                onTap: () async {
                  print(it.upiApplication.appName);
                  await _onTap(it);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    it.iconImage(48),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      alignment: Alignment.center,
                      child: Text(
                        it.upiApplication.getAppName(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
