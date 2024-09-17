import 'package:flutter/material.dart';

void myErrorMessage(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(message),
    ),
  );
}
