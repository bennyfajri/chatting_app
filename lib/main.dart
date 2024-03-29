import 'package:chatting_app/pages/chat_page.dart';
import 'package:chatting_app/pages/dashboard_page.dart';
import 'package:chatting_app/pages/login_page.dart';
import 'package:chatting_app/pages/register_page.dart';
import 'package:chatting_app/service/background_service.dart';
import 'package:chatting_app/service/local_notifications_init.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeNotification();
  await configureLocalTimeZone();
  await initializeService();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: DashboardPage.routeName,
      routes: {
        DashboardPage.routeName: (context) => const DashboardPage(),
        LoginPage.id: (context) => const LoginPage(),
        RegisterPage.id: (context) => const RegisterPage(),
        ChatPage.id: (context) => const ChatPage(),
      },
    );
  }
}
