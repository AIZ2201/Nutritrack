class UserManager {
  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;
  UserManager._internal();

  String? username='testuser';///默认用户名，具体再调入

  static UserManager get instance => _instance;
}
