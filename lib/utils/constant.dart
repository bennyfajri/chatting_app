import 'dart:io';
import 'dart:math';

import 'package:chatting_app/service/local_notifications_init.dart';
import 'package:chatting_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

  static String getNotificationTitle(String scheduleType) {
    List<String> listTitleText;
    if(scheduleType == Strings.listScheduleType[0].name) {
      listTitleText = Strings.listEatingTitle;
    } else if(scheduleType == Strings.listScheduleType[1].name) {
      listTitleText = Strings.listExcerciseTitle;
    } else {
      listTitleText = Strings.listMedicationTitle;
    }
    return listTitleText[Random().nextInt(listTitleText.length)];
  }

  static String getNotificationDesc(String scheduleType) {
    final scheduleTypeLower = scheduleType.capitalizeByWord();
    var listText = [
      "Hey there! Time for a break and a healthy $scheduleTypeLower session.",
      "Don't forget to take care of yourself! It's $scheduleTypeLower time.",
      "Listen to your body—it's telling you it's time for $scheduleTypeLower.",
      "Ready to nourish your body? Let's focus on $scheduleTypeLower now.",
      "A gentle reminder: prioritize your health with a session of $scheduleTypeLower.",
      "Feeling sluggish? A quick $scheduleTypeLower break can help boost your energy.",
      "Your well-being matters. Take a moment for some $scheduleTypeLower!",
      "Stay on track with your health goals. It's time for $scheduleTypeLower.",
      "Give yourself the gift of self-care. Let's do some $scheduleTypeLower!",
      "Time flies when you're having fun—especially during $scheduleTypeLower time!"
    ];
    return listText[Random().nextInt(listText.length)];
  }
}

extension StringExtension on String {
  String capitalizeByWord() {
    if (trim().isEmpty) {
      return '';
    }
    return split(' ')
        .map((element) =>
    "${element[0].toUpperCase()}${element.substring(1).toLowerCase()}")
        .join(" ");
  }
}