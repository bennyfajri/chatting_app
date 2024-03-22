import 'package:chatting_app/pages/chat_page.dart';
import 'package:chatting_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/Constant.dart';
import '../utils/auth_provider.dart';

class DashboardPage extends HookConsumerWidget {
  static String routeName = "dashboard";
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    final requestPermissionFuture = useMemoized(() => Constant.requestPermissions());
    useFuture(requestPermissionFuture);

    final auth = ref.watch(userProvider);
    final userId = auth.currentUser?.uid;
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      child: userId?.isNotEmpty == true ? const ChatPage() : const LoginPage(),
    );
  }
}
