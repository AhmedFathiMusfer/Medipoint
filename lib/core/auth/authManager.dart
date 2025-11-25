import 'dart:convert';
import 'dart:developer';

import 'package:diagno_bot/core/model/user.model.dart';
import 'package:diagno_bot/core/routing/app_router.dart';
import 'package:diagno_bot/core/routing/router.dart';
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

    // ✅ إضافة التوكن تلقائيًا للطلبات
    // dio.interceptors.add(
    //   InterceptorsWrapper(
    //     onRequest: (options, handler) {
    //       if (accessToken != null) {
    //         options.headers["Authorization"] = "Bearer $accessToken";
    //       }
    //       return handler.next(options);
    //     },
    //     onError: (e, handler) async {
    //       // ✅ لو انتهت صلاحية التوكن
    //       if (e.response?.statusCode == 401) {
    //         bool refreshed = await refreshAccessToken();
    //         if (refreshed) {
    //           // ✅ إعادة الطلب بعد تحديث التوكن
    //           final newRequest = await _retryRequest(e.requestOptions);
    //           return handler.resolve(newRequest);
    //         }
    //       }
    //       return handler.next(e);
    //     },
    //   ),
    // );
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
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("refresh", refreshToken!);
    prefs.setString("access", accessToken!);
  }

  // ✅ تسجيل الدخول
  // Future<bool> login(String email, String password) async {
  // try {
  //   final response = await dio.post(
  //     "/auth/login",
  //     data: {"email": email, "password": password},
  //   );

  //   accessToken = response.data["accessToken"];
  //   refreshToken = response.data["refreshToken"];
  //   currentUser = UserModel.fromJson(response.data["user"]);

  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString("user", jsonEncode(currentUser!.toJson()));
  //   prefs.setString("refreshToken", refreshToken!);
  //   prefs.setString("accessToken", accessToken!);

  //   return true;
  // } catch (e) {
  //   return false;
  // }
  // }

  // ✅ تجديد التوكن تلقائيًا
  Future<bool> refreshAccessToken() async {
    try {
      if (refreshToken == null) return false;

      final response = await dio.post(
        "/auth/refresh",
        data: {"refreshToken": refreshToken},
      );

      accessToken = response.data["accessToken"];

      final prefs = await SharedPreferences.getInstance();
      prefs.setString("accessToken", accessToken!);

      return true;
    } catch (_) {
      logout();
      return false;
    }
  }

  // ✅ إعادة محاولة الطلب بعد تحديث التوكن
  Future<Response> _retryRequest(RequestOptions requestOptions) {
    final options = Options(
      method: requestOptions.method,
      headers: {"Authorization": "Bearer $accessToken"},
    );
    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  // ✅ فحص ما إذا كان المستخدم مسجّل دخول
  bool isLoggedIn() {
    return accessToken != null;
  }

  // ✅ الخروج
  Future<void> logout() async {
    accessToken = null;
    refreshToken = null;
    currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    AppRouter.navigatorKey.currentState!.pushNamedAndRemoveUntil(
      Routers.loginView,
      (_) => false,
    );
  }
}
