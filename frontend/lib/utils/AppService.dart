import 'package:flutter/material.dart';
import 'package:frontend/utils/ApiManager.dart';
import 'package:frontend/utils/AuthService.dart';
import '../user-data.dart';
import 'package:frontend/Screens/Login/login_main.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class AppService extends ChangeNotifier {
  AppService._();

  factory AppService() => _instance;

  static AppService get instance => _instance;
  static final AppService _instance = AppService._();

  final Box storageBox = Hive.box('App Service Box');
  final _kCurrentUserKey = 'current_user';

  final navigatorKey = GlobalKey<NavigatorState>();

  BuildContext get context => navigatorKey.currentContext!;

  UserData? currentUser;

  bool get isLoggedIn => currentUser != null;

  void initialize() {
    final user = storageBox.get(_kCurrentUserKey);
    if (user != null) currentUser = user;
  }

  void setUserData(UserData userData) {
    storageBox.put(_kCurrentUserKey, userData);
    currentUser = userData;
    notifyListeners();
  }

  void manageAutoLogout() {
    terminate();
    context.go(LoginPage.route);
  }

  Future<void> terminate() async {
    AuthService.logout();
    currentUser = null;
    storageBox.clear();
  }
}
