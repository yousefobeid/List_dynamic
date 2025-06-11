import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class IInternetCheck {
  Future<bool> hasInternet();
}

class InternetCheck implements IInternetCheck {
  @override
  Future<bool> hasInternet() async {
    return await InternetConnection().hasInternetAccess;
  }
}
