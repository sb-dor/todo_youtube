import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionChecker {
  Future<bool> hasAccessToInternet() {
    return InternetConnection().hasInternetAccess;
  }
}
