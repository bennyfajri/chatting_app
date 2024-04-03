import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:chatting_app/firebase_options.dart';
import 'package:chatting_app/models/chat.dart';
import 'package:chatting_app/models/schedule.dart';
import 'package:chatting_app/service/local_notification_service.dart';
import 'package:chatting_app/service/local_notifications_init.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initialitzing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await configureLocalTimeZone();
  List<Schedule>? listSchedule = [];

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  /// Message  notification function
  var auth = FirebaseAuth.instance;
  FirebaseFirestore.instance
      .collection("messages")
      .orderBy("dateCreated", descending: true)
      .snapshots()
      .listen((event) async {
    if (event.docChanges.isNotEmpty) {
      var id = 0;
      final result = event.docs
          .map((snapshot) => ChatModel.fromMap(snapshot.data(), snapshot.id))
          .toList()
          .first;

      if(auth.currentUser?.uid != result.senderId) {
        const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
        const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
        await flutterLocalNotificationsPlugin.show(
            id++, result.sender, result.text, notificationDetails,
            payload: 'item x');
        // showNotificationWithActions(Schedule.empty(), flutterLocalNotificationsPlugin);
      }
    }
  });

  /// Get alarm data from firebase
  FirebaseFirestore.instance
      .collection("alarm")
      .where("userId", isEqualTo: auth.currentUser?.uid)
      .snapshots()
      .listen((event) async {
    if (event.docs.isNotEmpty) {
      final result =
      event.docs.map((e) => Schedule.fromMap(e.data(), e.id)).toList();
      listSchedule = result;
      cancelAllNotifications();
    }
  });

  /// Check periodically time to show alert
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    for (var schedule in listSchedule ?? []) {
      if (schedule.isActive == true) {
        final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
        var scheduledTime =
        nextInstanceOfTime(schedule.time);
        log("Scheduled time : $scheduledTime \n Now : $now");
        if (
            scheduledTime.hour == now.hour &&
            scheduledTime.minute == now.minute) {
          service.invoke('update', {"showAlarm": true});
          showNotificationWithActions(Schedule.empty(), flutterLocalNotificationsPlugin);
        }
      }
    }
  });
}
