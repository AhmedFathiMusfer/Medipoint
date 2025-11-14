import 'package:diagno_bot/core/enum/pages.dart';

class Appstore {
  static Appstore get instanse {
    _istanse ??= Appstore();
    return _istanse!;
  }

  PagesEnum currentPage = PagesEnum.home;
  Appstore();
  static Appstore? _istanse;
}
