import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

customDialog({
  required BuildContext context,
  String title = "",
  String message = "",
  String positiveButton = "",
  IconData? icon,
  Function()? onPositiveClicked,
  String negativeButton = "",
  Function()? onNegativeClicked,
}) {
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            if (positiveButton.isNotEmpty)
              CupertinoDialogAction(
                onPressed: onPositiveClicked,
                child: Text(positiveButton),
              ),
            if (negativeButton.isNotEmpty)
              CupertinoDialogAction(
                onPressed: onNegativeClicked,
                child: Text(negativeButton),
              ),
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          icon: icon != null ? Icon(icon, size: 65,) : null,
          actions: [
            if (positiveButton.isNotEmpty)
              TextButton(
                onPressed: onPositiveClicked,
                child: Text(positiveButton),
              ),
            if (negativeButton.isNotEmpty)
              TextButton(
                onPressed: onNegativeClicked,
                child: Text(negativeButton),
              ),
          ],
        );
      },
    );
  }
}
