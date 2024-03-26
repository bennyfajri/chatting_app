import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'local_notifications.dart';

class Constant {
  Constant._();

  static  Future<void> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      androidImplementation?.requestNotificationsPermission();
    }
  }

  static Future<void> goToPage(BuildContext context, Widget page) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static String getDateDifference(DateTime startDate, DateTime endDate) {
    Duration difference = endDate.difference(startDate);
    List<String> parts = [];

    if (difference.inDays > 0) {
      parts.add(
          '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'}');
    }
    if (difference.inHours.remainder(24) > 0) {
      parts.add(
          '${difference.inHours.remainder(24)} ${difference.inHours.remainder(24) == 1 ? 'hour' : 'hours'}');
    }
    if (difference.inMinutes.remainder(60) > 0) {
      parts.add(
          '${difference.inMinutes.remainder(60)} ${difference.inMinutes.remainder(60) == 1 ? 'minute' : 'minutes'}');
    }

    if (parts.isEmpty) {
      return '0 minutes';
    } else {
      String result = parts.join(' ');
      return result;
    }
  }

  static Future<dynamic> buildListBottomSheet(
      BuildContext context, String title, ListView listView) {
    return showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(title, style: Theme.of(context).textTheme.titleLarge,),
            ),
            listView
          ],
        );
      },
    );
  }
}