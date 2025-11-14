import 'dart:async';
import 'dart:io';

import 'package:diagno_bot/core/networking/errors/exceptions.app.dart';

class Apphelper {
  static String convertDigitsLang(String input, [int mode = 1]) {
    List<String> arabicNums = [
      '٠',
      '١',
      '٢',
      '٣',
      '٤',
      '٥',
      '٦',
      '٧',
      '٨',
      '٩',
    ];
    RegExp regex = RegExp([r'[0-9]', r'[٠-٩]'][mode]);
    Set<String> matches = Set.from(
      regex.allMatches(input).map((e) => e.group(0).toString()),
    );
    String replacement(String match) =>
        mode == 1
            ? arabicNums.indexOf(match).toString()
            : arabicNums[int.parse(match)];
    for (var match in matches) {
      input = input.replaceAll(match, replacement(match));
    }
    return input;
  }

  static isConnectionError(error) {
    return error is TimeoutException ||
        error is SocketException ||
        error is ConnectionException ||
        error.runtimeType.toString() == 'TimeoutException' ||
        error is UnexpectedException;
  }
}
