import 'dart:convert';
import 'dart:developer';

import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/enum/pages.dart';
import 'package:diagno_bot/core/model/user.model.dart';
import 'package:diagno_bot/core/routing/app_router.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/stror/appStore.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager() => _instance;
  AuthManager._internal();

  UserModel? currentUser;
  String? accessToken;
  String? refreshToken;

  final Dio dio = Dio(BaseOptions(baseUrl: "https://your-api.com"));

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("access");
    refreshToken = prefs.getString("refresh");
    String? userJson = prefs.getString("user");

    if (userJson != null) {
      currentUser = UserModel.fromJson(jsonDecode(userJson));
    }
  }

  Future<void> setUser(dynamic user) async {
    log(user.toString(), name: "the user");
    currentUser = UserModel.fromJson(user);
    log(currentUser.toString(), name: "the use2r");
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("user", jsonEncode(currentUser!.toJson()));
  }

  Future<void> setToken(dynamic token) async {
    log(token.toString(), name: 'token');
    accessToken = token["access"];
    refreshToken = token["refresh"];
    await setUser(token["user"]);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("refresh", refreshToken!);
    prefs.setString("access", accessToken!);
  }

  bool isLoggedIn() {
    return accessToken != null;
  }

  Future<void> logout() async {
    accessToken = null;
    refreshToken = null;
    currentUser = null;
    Appstore.instanse.currentPage = PagesEnum.home;
    final prefs = await SharedPreferences.getInstance();
    await AppDatabase().clearAllTables();
    prefs.clear();
    AppRouter.navigatorKey.currentState!.pushNamedAndRemoveUntil(
      Routers.loginView,
      (_) => false,
    );
  }
}
