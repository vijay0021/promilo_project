import 'package:connectivity_plus/connectivity_plus.dart';

abstract class InternetConnectionService {
  Future<bool> isInternetConnected();
}

class InternetConnectionImpl implements InternetConnectionService {
  @override
  Future<bool> isInternetConnected() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    return (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi);
  }
}