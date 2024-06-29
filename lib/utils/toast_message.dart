import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {
  static void showMessage(var msg, Color color) {
    Fluttertoast.showToast(
      msg: msg,
      fontSize: 12,
      gravity: kIsWeb ? ToastGravity.TOP_RIGHT : ToastGravity.BOTTOM,
      textColor: Colors.white,
      toastLength: kIsWeb ? Toast.LENGTH_LONG : Toast.LENGTH_LONG,
      backgroundColor: color,
    );
  }
}
