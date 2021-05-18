import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/providers/authServiceProvider.dart';
import 'package:food_for_all/screens/newsFeed.dart';
import 'package:food_for_all/screens/starter.dart';

class Wrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _authState = watch(authStateProvider);
    return _authState.when(
      data: (value) {
        if (value != null)
          return NewsFeed();
        else
          return Starter();
      },
      loading: () {
        return Scaffold(
          body: Center(
            child: Container(
              width: 150,
              child: LinearProgressIndicator(),
            ),
          ),
        );
      },
      error: (_, __) {
        return Scaffold(
          body: Center(
            child: Text("Something went wrong!!!"),
          ),
        );
      },
    );
  }
}
