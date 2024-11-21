import 'package:flutter/material.dart';

class CustomNavigator extends StatelessWidget {
  final String id;
  final Navigator navigator;

  CustomNavigator({super.key, required this.id, required this.navigator});

  @override
  Widget build(BuildContext context) {
    return navigator;
  }

  static NavigatorState of(BuildContext context,
      {int id, ValueKey<String> key}) {
    final NavigatorState state = Navigator.of(
      context,
      rootNavigator: id == null,
    );
    if (state.widget is CustomNavigator) {
      if ((state.widget as CustomNavigator).id == id) {
        return state;
      } else {
        return of(state.context, id: id);
      }
    }
    return state;
  }
}
