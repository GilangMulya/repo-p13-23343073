class AuthData {
  static final AuthData instance = AuthData._internal();
  AuthData._internal();

  // Memori sementara untuk menyimpan data user
  String? registeredName;
  String? registeredEmail;
  String? registeredPassword;

  // Fungsi Register
  void register(String name, String email, String password) {
    registeredName = name;
    registeredEmail = email;
    registeredPassword = password;
  }

  // Fungsi Login
  bool login(String email, String password) {
    if (registeredEmail == null || registeredPassword == null) {
      return false; // Belum ada yang mendaftar
    }
    return email == registeredEmail && password == registeredPassword;
  }
}
