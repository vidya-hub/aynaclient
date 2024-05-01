import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension ContextExtensions on BuildContext {
  void push({required Widget navigateTo}) {
    Navigator.push(
      this,
      MaterialPageRoute(
        builder: (context) => navigateTo,
      ),
    );
  }

  T bloc<T extends BlocBase>() {
    return BlocProvider.of<T>(this);
  }

  void pop() => Navigator.pop(this);
  void pushRemoveUntil({required Widget to}) => Navigator.pushAndRemoveUntil(
        this,
        MaterialPageRoute(
          builder: (context) {
            return to;
          },
        ),
        (route) => false,
      );
  void hideKeyBoard() => FocusScope.of(this).unfocus();
}
