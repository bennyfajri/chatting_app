import 'package:chatting_app/models/login_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginProvider =
    NotifierProvider<LoginProvider, LoginController>(LoginProvider.new);

final isLoadingProvider = StateProvider((ref) => false);

final obscureTextProvider = StateProvider((ref) => false);

class LoginProvider extends Notifier<LoginController> {
  @override
  LoginController build() {
    return LoginController();
  }

  void updateEmail(String email) {
    state.email = email;
  }

  void updatePassword(String password) {
    state.password = password;
  }
}
