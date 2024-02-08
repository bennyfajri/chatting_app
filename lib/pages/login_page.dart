import 'package:chatting_app/pages/register_page.dart';
import 'package:chatting_app/utils/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login_page';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, ChatPage.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _isLoading
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
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Email',
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    if(mounted) {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    }
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
                if(mounted) {
                  setState(() {
                    _isLoading = true;
                  });
                  try{
                    final navigator = Navigator.of(context);
                    final email = _emailController.text;
                    final password = _passwordController.text;

                    await _auth.signInWithEmailAndPassword(email: email, password: password);
                    if(mounted) navigator.pushReplacementNamed(ChatPage.id);
                  } catch(e) {
                    final snackBar = SnackBar(content: Text(e.toString()));
                    if(mounted)  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
              },
              child: const Text('Login'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  signInWithGoogle();
                  Navigator.pushReplacementNamed(context, ChatPage.id);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/google.png',
                        fit: BoxFit.contain,
                        width: 40.0,
                        height: 40.0),
                    Text(
                      'Google',
                      style: TextStyle(
                          fontSize: 25.0, color: Colors.black),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
