import 'package:flutter/material.dart';
import 'package:list_dynamic/core/helpers/internet_chek.dart';
import 'package:list_dynamic/core/service/database_helper.dart';

class NetWorkService with WidgetsBindingObserver {
  final IInternetCheck checker;

  static NetWorkService? _instance;

  factory NetWorkService({IInternetCheck? checker}) {
    _instance ??= NetWorkService._internal(checker ?? InternetCheck());
    return _instance!;
  }

  NetWorkService._internal(this.checker);

  void start() {
    WidgetsBinding.instance.addObserver(this);
  }

  void stop() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final connected = await checker.hasInternet();
      if (connected) {
        await DatabaseHelper.instance.syncUnsentData();
        debugPrint("تمت المزامنة بعد رجوع التطبيق");
      } else {
        debugPrint("لا يوجد اتصال بعد الرجوع للتطبيق");
      }
    }
  }
}
