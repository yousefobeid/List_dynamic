import 'dart:async';

import 'package:list_dynamic/data/local/database_helper.dart';
import 'package:list_dynamic/service/network_service.dart';

class SyncManagers {
  static final SyncManagers instance = SyncManagers._internal();
  factory SyncManagers() => instance;
  SyncManagers._internal();
  Timer? _timer;
  bool isSyncing = false;
  void startSyncTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      final connectivity = await NetworkService().isActuallyConnected();
      if (connectivity) {
        isSyncing = true;
        print(" الإنترنت متاح - بدء المزامنة");
        await DatabaseHelper.instance.syncUnsentData();
        isSyncing = false;
      } else {
        print("لا يوجد إنترنت - إلغاء المزامنة الآن");
      }
    });
    print("تم تشغيل مؤقت المزامنة التلقائية كل دقيقة");
  }
}
