import 'package:flutter/material.dart';

displaySnackBar({required BuildContext context, required String content}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.green,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10))),
      content: Text(
        content,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
