import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetCheck {
  static Future<bool> hasInternet() async {
    return await InternetConnection().hasInternetAccess;
  }
}
