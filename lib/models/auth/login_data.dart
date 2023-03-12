class LoginData {
  String username;
  String password;
  bool rememberMe;

  LoginData(
      {required this.username,
      required this.password,
      required this.rememberMe});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    return data;
  }
}
