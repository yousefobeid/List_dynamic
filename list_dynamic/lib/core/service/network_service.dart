import 'package:flutter/widgets.dart';
import 'package:list_dynamic/core/helpers/internet_chek.dart';
import 'package:list_dynamic/core/service/database_helper.dart';

class NetWorkService with WidgetsBindingObserver {
  static final NetWorkService _instance = NetWorkService._internal();

  factory NetWorkService() {
    return _instance;
  }

  NetWorkService._internal();

  void start() {
    WidgetsBinding.instance.addObserver(this);
  }

  void stop() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final connected = await InternetCheck.hasInternet();
      if (connected) {
        await DatabaseHelper.instance.syncUnsentData();
        debugPrint("تمت المزامنة بعد رجوع التطبيق");
      } else {
        debugPrint("لا يوجد اتصال بعد الرجوع للتطبيق");
      }
    }
  }
}
