import 'package:chatting_app/pages/register_page.dart';
import 'package:chatting_app/utils/auth_provider.dart';
import 'package:chatting_app/utils/login/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'chat_page.dart';

class LoginPage extends HookConsumerWidget {
  static const String id = 'login_page';

  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginFormController = ref.watch(loginProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final obscureText = ref.watch(obscureTextProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(),
            Hero(
              tag: 'Chatting App',
              child: Text(
                'Chatting App',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 24.0),
            TextFormField(
              initialValue: loginFormController.email,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                ref.read(loginProvider.notifier).updateEmail(value);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Email',
              ),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              initialValue: loginFormController.password,
              obscureText: obscureText,
              onChanged: (value) {
                ref.read(loginProvider.notifier).updatePassword(value);
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    ref.read(obscureTextProvider.notifier).state = !obscureText;
                  },
                ),
                hintText: 'Password',
              ),
            ),
            const SizedBox(height: 24.0),
            MaterialButton(
              color: Theme.of(context).primaryColor,
              textTheme: ButtonTextTheme.primary,
              height: 40,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onPressed: () async {
                ref.read(isLoadingProvider.notifier).state = true;
                try {
                  final navigator = Navigator.of(context);
                  final email = loginFormController.email;
                  final password = loginFormController.password;

                  var emailSignIn = await ref
                      .read(userProvider.notifier)
                      .signInWithEmailAndPassword(
                        email ?? "",
                        password ?? "",
                      );
                  if (emailSignIn.user != null) {
                    if (context.mounted) {
                      navigator.pushReplacementNamed(ChatPage.id);
                    }
                  }
                } catch (e) {
                  final snackBar = SnackBar(content: Text(e.toString()));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  var googleSignIn =
                      await ref.read(userProvider.notifier).signInWithGoogle();
                  if (googleSignIn.user != null) {
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, ChatPage.id);
                    }
                  }
                } catch (e) {
                  final snackBar = SnackBar(content: Text(e.toString()));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/google.png',
                        fit: BoxFit.contain, width: 40.0, height: 40.0),
                    const SizedBox(width: 12.0),
                    const Text(
                      'Sign in with Google',
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              child: const Text('Does not have an account yet? Register here'),
              onPressed: () => Navigator.pushNamed(context, RegisterPage.id),
            ),
          ],
        ),
      ),
    );
  }
}
