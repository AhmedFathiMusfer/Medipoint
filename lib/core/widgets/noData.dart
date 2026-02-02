import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class Nodata extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("no_found_data".tr()));
  }
}
