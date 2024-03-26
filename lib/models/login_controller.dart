class LoginController {
  String? email;
  String? password;

  LoginController({
    this.email,
    this.password,
  });

  LoginController copyWith({
    String? email,
    String? password,
  }) {
    return LoginController(
        email: email ?? this.email, password: password ?? this.password);
  }
}
