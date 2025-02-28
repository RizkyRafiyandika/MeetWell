import 'package:fitness2/constants/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void customToast(String message, {Color backgroundColor = tdcyan}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: backgroundColor,
    textColor: tdbackground,
    fontSize: 16.0,
  );
}
