import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NetworkHelper {
  static Future<bool> isConnected() async {
    try {
      final result = await http
          .get(
            Uri.parse('https://www.google.com/'),
            headers: {'Cache-Control': 'no-cache', 'Pragma': 'no-cache'},
          )
          .timeout(const Duration(seconds: kDebugMode ? 5 : 10));
      if (result.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    } on Exception catch (err) {
      return false;
    }
  }
}
