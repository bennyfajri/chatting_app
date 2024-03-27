import 'package:chatting_app/models/schedule.dart';
import 'package:chatting_app/service/local_notifications_init.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../utils/constant.dart';

tz.TZDateTime nextInstanceOfTime(DateTime time) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

  tz.TZDateTime? scheduledDate = tz.TZDateTime(
      tz.local, now.year, now.month, now.day, time.hour, time.minute);

  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

Future<void> cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> showNotificationWithActions(Schedule schedule, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  const AndroidNotificationDetails androidNotificationDetails =
  AndroidNotificationDetails(
    "channelId",
    "Alarm Reminder",
    channelDescription: "Background notification to get alarm reminder",
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    actions: <AndroidNotificationAction>[
      AndroidNotificationAction(
          urlLaunchActionId,
          'Close',
          icon: DrawableResourceAndroidBitmap('secondary_icon'),
          titleColor: Colors.blue
      ),
    ],
  );

  const DarwinNotificationDetails iosNotificationDetails =
  DarwinNotificationDetails(
    categoryIdentifier: darwinNotificationCategoryPlain,
  );

  const DarwinNotificationDetails macOSNotificationDetails =
  DarwinNotificationDetails(
    categoryIdentifier: darwinNotificationCategoryPlain,
  );

  const LinuxNotificationDetails linuxNotificationDetails =
  LinuxNotificationDetails(
    actions: <LinuxNotificationAction>[
      LinuxNotificationAction(
        key: urlLaunchActionId,
        label: 'Close',
      ),
    ],
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: iosNotificationDetails,
    macOS: macOSNotificationDetails,
    linux: linuxNotificationDetails,
  );
  await flutterLocalNotificationsPlugin.show(
      10, Constant.getNotificationTitle(schedule.type), Constant.getNotificationDesc(schedule.type), notificationDetails,
      payload: schedule.time.toString());
}